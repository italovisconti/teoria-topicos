# Especificación general de WAR-BOTS

**Sistema distribuido: simulador de combate y economía circular**

Esta especificación presenta la arquitectura del sistema, la distribución de responsabilidades, las bases de datos y el catálogo consolidado de 40 APIs. Cada guía de módulo desarrolla sus APIs y su modelo MongoDB.

## Arquitectura y módulos

El sistema se organiza en cuatro módulos distribuidos y desacoplados. Cada uno cuenta con su servicio y su interfaz de usuario.

| Módulo | Servicio | Responsable | Interfaz | Alcance |
|---|---|---|---|---|
| Módulo 1 | Tienda oficial y compras unificadas | Yisheng | Tienda | Comercio de artículos de fábrica y usados de M2. |
| Módulo 2 | Chatarrería y subastas | Luis, Sección 1 | Chatarrería | Recepción, tasación, venta y subasta de artículos embargados. |
| Módulo 3 | Garaje, ensamblador y billetera | Ítalo Visconti | Garaje | Jugadores, saldo, inventario y ensamblaje de robots. |
| Módulo 4 | Arena de combate 1v1 y RNG | Luis, Sección 2 | Arena | Simulación Best of 3, cálculo de daño y liquidación. |

## Comunicación entre módulos

Las integraciones descritas en el catálogo identifican llamadas HTTP directas y webhooks. La comunicación síncrona permite que un módulo solicite una operación a otro y reciba su respuesta; los webhooks notifican eventos de forma asíncrona. La arquitectura orientada a eventos es una alternativa para desacoplar productores y consumidores. La selección e implementación de un intermediario de mensajes no está especificada.

## Bases de datos y guías de módulo

Cada módulo mantiene su propio modelo MongoDB. Los detalles de colecciones y campos están en la guía correspondiente.

| Módulo | Base de datos | Modelo y APIs desarrollados |
|---|---|---|
| Módulo 1 | `tienda_db` | [Tienda — Yisheng](https://github.com/italovisconti/war-bots/blob/main/guia-tecnica-tienda-yisheng.md) |
| Módulo 2 | `chatarreria_db` | [Chatarrería — Luis, Sección 1](https://github.com/italovisconti/war-bots/blob/main/guia-tecnica-chatarreria-luis-sec1.md) |
| Módulo 3 | `jugadores_garaje_db` | [Garaje y billetera — Ítalo Visconti](guia-tecnica-garaje-italo.md) |
| Módulo 4 | `arena_combate_db` | [Arena — Luis, Sección 2](https://github.com/italovisconti/war-bots/blob/main/guia-tecnica-arena-luis-sec2.md) |

## Despliegue y entrega continua (CD)

- Cada módulo (servicio backend con sus 10 APIs, frontend e instancia MongoDB) debe desplegarse en el proveedor de nube de preferencia del equipo (por ejemplo, Render, Railway, Fly.io, Vercel, Azure, AWS o GCP, junto con MongoDB Atlas), exponiendo una URL pública HTTPS para permitir la integración entre los cuatro módulos.
- Cada repositorio debe incorporar un flujo de **CD** *Continuous Deployment* (mediante GitHub Actions o integración nativa del proveedor) que ejecute el despliegue de forma automática en cada actualización de la rama principal (`main`).

## Reglas de negocio comunes

- La cuenta nueva recibe 1.000 créditos. El único rescate por bancarrota otorga 500 créditos cuando el saldo es 0 y no quedan robots operativos. No se permite saldo negativo.
- Cada robot tiene un slot de chasis, hasta dos slots de armas y un slot de escudo (`tipo` válido: `chasis`, `arma`, `escudo`). Al ingresar un `chasis` en M3 se crea automáticamente el robot en estado `CHASIS_NUDO`.
- El combate es Best of 3 (concluye al alcanzar 2 victorias de asalto o por KO técnico sin robots operativos; en empate tras 3 asaltos gana mayor HP% restante). El servidor genera `RNG_Golpe` entre 0.5 y 1.2 y `RNG_Defensa` entre 0.3 y 1.0. El daño neto al chasis se calcula como `max(5, daño_bruto - mitigación)`; el escudo equipado recibe `round(daño_neto × 0.5)` y cada arma equipada `round(daño_bruto × 0.2)`.
- KO y embargo requieren HP < 25 %; exactamente 25 % no activa el umbral. Los artículos que terminan el combate con HP >= 25 % regresan a su línea base operativa en M3 (100 % fábrica; 50 % reacondicionado).
- El descuento máximo de 80 % en Tienda aplica solo a promociones, ofertas relámpago y cupones sobre artículos de fábrica. M2 tasa los artículos embargados con `precio_lista × 0.5 × (HP_actual / HP_max)` y la Tienda los publica a ese `precio_remate` sin tope del 80 % y sin acumular cupones. Al comprarse en M1 o subasta M2, el artículo se entrega reacondicionado en M3 con `hp_actual = 50` (`hp_max = 100`).

## Catálogo de las 40 APIs

## APIs 01–10 — Módulo 1: Tienda (Yisheng)

| API | Método y endpoint | Propósito | Request | Response | Conexión / integración |
|---:|---|---|---|---|---|
| 01 | `GET /api/v1/tienda/catalogo` | Obtener catálogo unificado con filtros (fábrica y usados). | Query: `tipo: String` (op.), `es_chatarra: Bool` (op.), `precio_max: Num` (op.). | `200 OK`: `{total_items: Num, items: Array[{sku, nombre_item, precio_final, es_chatarra, imagen_url}]}` | Llama síncronamente a M2 `GET /items` para refrescar stock usado. |
| 02 | `POST /api/v1/tienda/comprar-fabrica` | Procesar la compra de un producto nuevo de fábrica. | Body: `{jugador_id: String, sku: String, cantidad: Num, cupon_codigo: String}` | `201 Created`: `{transaccion_id: String, estado: 'COMPLETADO', monto_debitado: Num, saldo_restante: Num}` | Llama a M3 `PUT /saldo` y M3 `POST /inventario`. |
| 03 | `POST /api/v1/tienda/comprar-chatarra` | Procesar la compra agregada de un ítem usado de la Chatarrería. | Body: `{jugador_id: String, item_chatarra_id: String, precio_acordado?: Num}` | `201 Created`: `{transaccion_id: String, origen: 'CHATARRERIA', monto_debitado: Num}` | Consulta precio en M2, descuenta stock en M2, debita en M3 `PUT /saldo` e inyecta en M3 `POST /inventario` (`hp_actual: 50`). |
| 04 | `POST /api/v1/tienda/cupones/validar` | Validar un código promocional de e-commerce. | Body: `{codigo: String, monto_carrito: Num}` | `200 OK`: `{valido: Bool, porcentaje_descuento: Num, monto_ahorrado: Num}` | Interna de M1. |
| 05 | `GET /api/v1/tienda/historial/:jugador_id` | Consultar el historial de compras de un usuario. | Path: `jugador_id: String`. Query: `limite: Num`. | `200 OK`: `{jugador_id: String, compras: Array[{transaccion_id, sku, fecha, monto}]}` | Consulta MongoDB local `tienda_db`. |
| 06 | `POST /api/v1/tienda/ofertas/crear` | Publicar promociones relámpago con tiempo limitado. | Body: `{sku: String, descuento_porcentaje: Num, duracion_minutos: Num}` | `201 Created`: `{oferta_id: String, sku: String, fecha_expiracion: String}` | Interna administrativa de M1. |
| 07 | `PUT /api/v1/tienda/stock/actualizar` | Reabastecer inventario oficial de fábrica. | Body: `{sku: String, cantidad_agregar: Num}` | `200 OK`: `{sku: String, nuevo_stock: Num}` | Interna administrativa de M1. |
| 08 | `POST /api/v1/tienda/eventos/embargo` | Webhook receptor de notificaciones de embargo tasado desde M2. | Body: `{evento: 'ITEM_EMBARGADO', item_id: String, hp_restante: Num, precio_remate?: Num}` | `200 OK`: `{recibido: true, catalogo_actualizado: true}` | Notificación asíncrona enviada por M2 tras tasar el artículo. |
| 09 | `GET /api/v1/tienda/destacados` | Obtener los artículos más vendidos para la vista Hero. | Query: `limite: Num` (op.). | `200 OK`: `{destacados: Array[{sku, nombre_item, compras_totales}]}` | Interna de M1. |
| 10 | `POST /api/v1/tienda/devolucion` | Procesar garantía o devolución pre-combate de piezas. | Body: `{transaccion_id: String, motivo: String}` | `200 OK`: `{reembolsado: true, monto_reembolso: Num}` | Retira pieza en M3 `POST /embargo-piezas` (`motivo: 'DEVOLUCION'`) y abona en M3 `PUT /saldo`. |

## APIs 11–20 — Módulo 2: Chatarrería (Luis, Sección 1)

| API | Método y endpoint | Propósito | Request | Response | Conexión / integración |
|---:|---|---|---|---|---|
| 11 | `GET /api/v1/chatarreria/items` | Obtener lista de piezas y robots embargados disponibles. | Query: `disponible: Bool`, `tipo: String`. | `200 OK`: `{items: Array[{id, nombre_item, hp_actual, precio_remate, imagen_url}]}` | Consumida por M1 para poblar la pestaña «Usados». |
| 12 | `POST /api/v1/chatarreria/recepcion-desecho` | Registrar piezas y robots confiscados enviados desde M4. | Body: `{robot_id: String, combate_id?: String, jugador_anterior_id?: String, piezas_embargadas: Array[Object], hp_restante: Num}` | `201 Created`: `{recepcion_id: String, estado: 'TASADO'}` | Invocada por M4 tras un Knockout o HP < 25 %. Notifica a M1 `POST /eventos/embargo`. |
| 13 | `POST /api/v1/chatarreria/descontar-stock` | Remover stock de chatarra vendido por el Módulo 1. | Body: `{item_id: String, comprador_id: String, transaccion_m1_id: String}` | `200 OK`: `{item_id: String, estado: 'RESERVADO_Y_RETIRADO'}` | Invocada síncronamente por M1 tras confirmar el pago. |
| 14 | `POST /api/v1/chatarreria/subasta/crear` | Aperturar subasta pública para un robot confiscado completo. | Body: `{robot_id: String, precio_base: Num, duracion_segundos: Num}` | `201 Created`: `{subasta_id: String, fecha_cierre: String}` | Interna de M2. |
| 15 | `POST /api/v1/chatarreria/subasta/pujar` | Registrar oferta de compra en subasta activa. | Body: `{subasta_id: String, pujador_id: String, monto_oferta: Num}` | `200 OK`: `{subasta_id: String, oferta_actual: Num, lider_id: String}` | Valida saldo con M3 `GET /perfil`. |
| 16 | `POST /api/v1/chatarreria/subasta/cerrar` | Finalizar subasta, debitar saldo y transferir robot. | Body: `{subasta_id: String}` | `200 OK`: `{ganador_id: String, monto_final: Num, robot_transferido: true}` | Solicita débito en M3 `PUT /saldo` (con fallback al siguiente postor si falla) e inyección en M3 `POST /inventario`. |
| 17 | `GET /api/v1/chatarreria/tasacion/:item_id` | Calcular el precio de remate según desgaste. | Path: `item_id: String`. | `200 OK`: `{item_id: String, precio_base: Num, porcentaje_descuento: Num, precio_remate: Num}` | Aplica fórmula: 50 % OFF base + ajuste por daño. |
| 18 | `GET /api/v1/chatarreria/historial-remates` | Consultar histórico de piezas recicladas para auditoría. | Query: `limite: Num`. | `200 OK`: `{remates: Array[{item_id, fecha, precio_final, comprador_id}]}` | Interna de M2. |
| 19 | `POST /api/v1/chatarreria/chatarra-express` | Venta directa de piezas usadas del jugador a la Chatarrería. | Body: `{jugador_id: String, pieza_id: String}` | `200 OK`: `{monto_pagado: Num, nuevo_saldo_m3: Num}` | Verifica en M3 `GET /inventario`, retira en M3 `POST /embargo-piezas` (`motivo: 'VENTA_EXPRESS'`) y abona en M3 `PUT /saldo`. |
| 20 | `GET /api/v1/chatarreria/subastas/activas` | Obtener el feed en vivo de subastas con temporizador. | Query: ninguna. | `200 OK`: `{subastas: Array[{subasta_id, robot_id, oferta_lider, tiempo_restante}]}` | Consumida por el frontend de M2. |

## APIs 21–30 — Módulo 3: Garaje y billetera (Ítalo Visconti)

| API | Método y endpoint | Propósito | Request | Response | Conexión / integración |
|---:|---|---|---|---|---|
| 21 | `POST /api/v1/jugadores/registro` | Registrar jugador y asignar billetera con 1.000 créditos. | Body: `{alias: String, email: String}` | `201 Created`: `{jugador_id: String, saldo_inicial: 1000, garaje_id: String}` | Servicio bancario inicial. |
| 22 | `GET /api/v1/jugadores/:id/perfil` | Consultar información del jugador, saldo y estadísticas. | Path: `id: String`. | `200 OK`: `{jugador_id: String, alias: String, saldo: Num, nivel: Num}` | Consulta central de estado. |
| 23 | `PUT /api/v1/jugadores/:id/saldo` | API bancaria central para débitos y créditos de saldo. | Body: `{monto: Num, operacion: 'DEBITO'\|'CREDITO', concepto: String, referencia_operacion?: String}` | `200 OK`: `{jugador_id: String, saldo_anterior: Num, nuevo_saldo: Num}` | Invocada por M1, M2 y M4. Rechaza saldo negativo (`409`). |
| 24 | `GET /api/v1/jugadores/:id/inventario` | Obtener inventario completo de robots, chasis y armas. | Path: `id: String`. | `200 OK`: `{robots: Array, piezas_sueltas: Array}` | Consumida por el frontend del Garaje y M2 `chatarra-express`. |
| 25 | `POST /api/v1/jugadores/:id/inventario` | Inyectar piezas o robots al inventario (crea robot si `tipo='chasis'`). | Body: `{pieza_payload: {sku, nombre_item, tipo, fuerza_bono, defensa_bono, precio_lista, imagen_url, origen?, hp_actual?, piezas_adjuntas?}}` | `201 Created`: `{pieza_instancia_id: String, robot_id?: String, asignada: true}` | Invocada por M1 y M2 tras la compra o adjudicación. |
| 26 | `POST /api/v1/jugadores/:id/embargo-piezas` | Retirar piezas o robots por embargo, devolución o venta express. | Body: `{piezas_confiscadas_ids: Array[String], motivo?: 'EMBARGO'\|'DEVOLUCION'\|'VENTA_EXPRESS'}` | `200 OK`: `{removidas: Array[String], inventario_actualizado: true}` | Invocada síncronamente por M4, M1 y M2. |
| 27 | `POST /api/v1/jugadores/:id/robots/ensamblar` | Montar armas y escudos calculando fuerza y defensa. | Body: `{robot_id: String, armas_ids: Array[String], escudo_id?: String}` | `200 OK`: `{robot_id: String, fuerza_total: Num, defensa_total: Num}` | Calcula estadísticas combinadas. |
| 28 | `POST /api/v1/jugadores/:id/robots/desmontar` | Retirar accesorios dejando el «Chasis Nudo». | Body: `{robot_id: String}` | `200 OK`: `{robot_id: String, estado: 'CHASIS_NUDO', stats_base: {fuerza, defensa}}` | Mantiene atributos nativos base. |
| 29 | `GET /api/v1/jugadores/:id/robots/alineacion` | Validar alineación activa y entregar snapshot completo de combate. | Path: `id: String`. | `200 OK`: `{alineacion: Array[{robot_id, nombre_robot, hp_actual, listo_combate, fuerza_total, defensa_total, chasis, armas, escudo}]}` | Invocada por M4 al crear sala 1v1. |
| 30 | `POST /api/v1/jugadores/:id/bancarrota/reset` | Fondo de rescate (500 $) para evitar bloqueo por quiebra. | Path: `id: String`. | `200 OK`: `{rescate_otorgado: true, nuevo_saldo: 500}` | Prevención de parálisis económica. |

## APIs 31–40 — Módulo 4: Arena (Luis, Sección 2)

| API | Método y endpoint | Propósito | Request | Response | Conexión / integración |
|---:|---|---|---|---|---|
| 31 | `POST /api/v1/arena/combates/crear` | Crear sala 1v1 entre dos jugadores validando alineaciones. | Body: `{jugador_p1_id: String, jugador_p2_id: String, robots_p1: Array, robots_p2: Array}` | `201 Created`: `{combate_id: String, estado: 'EN_PROGRESO'}` | Invoca M3 `GET /alineacion` para validar. |
| 32 | `POST /api/v1/arena/combates/ejecutar-asalto` | Procesar simulación estocástica de disparo y bloqueo (RNG). | Body: `{combate_id: String, asalto_num: Num, robot_p1_id?: String, robot_p2_id?: String}` | `200 OK`: `{dano_p1: Num, dano_p2: Num, hp_restante_p1: Num, hp_restante_p2: Num, log: String}` | Aplica fórmulas RNG de fuerza, defensa y desgaste de accesorios. |
| 33 | `GET /api/v1/arena/combates/:id/estado` | Consultar estado del duelo en vivo (HP %, asaltos Best of 3). | Path: `id: String`. | `200 OK`: `{combate_id: String, asalto_actual: Num, marcador: {p1: Num, p2: Num}}` | Consumida por el visor de la Arena. |
| 34 | `POST /api/v1/arena/combates/:id/finalizar` | Cierre oficial del combate y declaración de ganador. | Path: `id: String`. Body: `{combate_id?: String}` | `200 OK`: `{ganador_id: String, perdedor_id: String, motivo: 'KO'\|'PUNTOS'}` | Desencadena liquidación y embargos desde estado en servidor. |
| 35 | `PUT /api/v1/arena/liquidacion/premios` | Acreditar bolsa de premios (+$300 ganador / +$100 participante). | Body: `{combate_id: String}` | `200 OK`: `{premios_acreditados: true}` | Lee ganador/perdedor de `arena_combate_db` y llama a M3 `PUT /saldo`. |
| 36 | `POST /api/v1/arena/liquidacion/embargos` | Verificar HP < 25 % y ejecutar confiscación de piezas. | Body: `{combate_id: String}` | `200 OK`: `{embargo_ejecutado: true, enviadas_a_m2: Array}` | Lee piezas bajo umbral de `arena_combate_db`, llama a M3 `POST /embargo-piezas` y M2 `POST /recepcion-desecho`. |
| 37 | `GET /api/v1/arena/ranking/global` | Obtener la tabla de clasificación mundial (Leaderboard). | Query: `limite: Num` (op.). | `200 OK`: `{ranking: Array[{posicion, jugador_id, alias, victorias, derrotas, ratio_efectividad}]}` | Interna de M4. |
| 38 | `GET /api/v1/arena/combates/historial` | Registro histórico de peleas y logs de disparos. | Query: `jugador_id: String` (op.). | `200 OK`: `{historial: Array[{combate_id, fecha, ganador, log_resumen}]}` | Interna de M4. |
| 39 | `POST /api/v1/arena/simulacion/rapida` | Simulador sintético de 100 peleas para balance de estadísticas. | Body: `{stats_robot_a: {fuerza_total, defensa_total, hp_max}, stats_robot_b: {fuerza_total, defensa_total, hp_max}}` | `200 OK`: `{winrate_a: Num, winrate_b: Num, promedio_asaltos: Num}` | Herramienta de ajuste estocástico (`winrate` en `[0.0, 1.0]`). |
| 40 | `POST /api/v1/arena/webhooks/suscribir` | Registro de webhooks pub/sub para eventos de combate. | Body: `{modulo_suscriptor: String, callback_url: String, eventos: Array}` | `201 Created`: `{suscripcion_id: String, estado: 'ACTIVA'}` | Suscripción para M1 y M2. |
