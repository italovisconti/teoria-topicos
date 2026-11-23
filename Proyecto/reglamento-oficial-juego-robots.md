# REGLAMENTO OFICIAL DE JUEGO Y MANUAL TÉCNICO

## Simulador Distribuido de Combate de Robots 1v1 y Economía Circular (WAR-BOTS)

El presente documento constituye el Reglamento Técnico e Intensivo de Juego para la plataforma WAR-BOTS. Establece las reglas oficiales del ring, la física estocástica del combate 1v1, la gestión de inventario y billeteras, el modelo de economía circular y las responsabilidades académicas distribuidas por módulo y cátedra.

## 1. Flujo General del Jugador (Game Loop)

El ciclo de vida del usuario dentro del simulador WAR-BOTS sigue una arquitectura circular dividida en 5 etapas secuenciales:

1. **Onboarding y Registro:** El usuario se registra en la plataforma y el sistema inicializa su Billetera Digital con capital semilla.
2. **Adquisición de Equipamiento:** El piloto adquiere chasis, armas o escudos nuevos en la Tienda Oficial o reciclados en La Chatarrería.
3. **Ensamblaje y Taller:** En el Garaje, el jugador monta y desmonta accesorios, evaluando las estadísticas globales de Fuerza y Defensa.
4. **Duelo 1v1 en la Arena:** El robot entra al cuadrilátero para competir en duelos 1v1 en formato al mejor de 3 asaltos.
5. **Liquidación y Embargo:** Se procesan las bolsas de premios (+$300 ganador / +$100 participante) y se ejecutan embargos automáticos si el daño es crítico.

## 2. Economía Inicial y Gestión de Billetera (Módulo 3 — Profesor Ítalo Visconti)

- **Capital Semilla de Bienvenida:** Cada nuevo piloto registrado recibe automáticamente $1.000 créditos iniciales depositados en su Billetera Digital.
- **Estrategia de Inversión:** El jugador puede elegir entre comprar un robot de gama alta nuevo de fábrica o armar una flota de varios robots económicos con piezas recicladas.
- **Fondo de Rescate por Bancarrota:** Si la billetera llega a $0 y el jugador no cuenta con robots operativos, el sistema otorga un subsidio único de emergencia de $500 créditos para reincorporarse al juego.

## 3. Mercado de Equipamiento y E-Commerce (Módulo 1 — Profesor Yisheng; Módulo 2 — Profesor Luis, Sección 1)

El Módulo 1 (Tienda Oficial) actúa como el E-Commerce Unificado que integra dos pestañas principales de compra:

- **Pestaña «Catálogo de Fábrica»:** Artículos 100% nuevos, directo de línea de montaje con su durabilidad al máximo (HP = 100.0) y máxima potencia. Admite promociones, ofertas relámpago y cupones de hasta 80% de descuento.
- **Pestaña «La Chatarrería / Usados»:** Componentes reacondicionados y robots embargados. Se tasan con un 50% de descuento base más una rebaja proporcional según la durabilidad restante al momento del embargo (`precio_lista × 0.5 × (HP_actual / HP_max)`), sin tope del 80% y no acumulable con cupones ni ofertas de fábrica. Al adquirirse en Tienda o Subasta, la pieza se entrega reacondicionada en el Garaje con HP = 50.0 (50% de durabilidad operativa).
- **Integración síncrona M1-M2:** La Chatarrería (Módulo 2) gestiona la recepción de desechos, las subastas en vivo y expone su stock para que la Tienda (Módulo 1) procese las ventas.

## 4. Reglas de Ensamblaje y «Chasis Nudo» (Módulo 3 — Profesor Ítalo Visconti)

- **Ranuras de Equipamiento:** Cada robot dispone de ranuras dedicadas para 1 chasis, hasta 2 armas (Láser, Sierra, Mazo) y 1 escudo/armadura.
- **Atributos Nativos Base:** Todo chasis tiene atributos inherentes e inalterables de Fuerza Nativa Base y Defensa Nativa Base.
- **Regla del Chasis Nudo:** Si a un robot le desmantelan todas las armas o resultan destruidas en combate, el robot no queda indefenso. Puede entrar a la arena a pelear a puño limpio usando sus atributos nativos.

## 5. Reglas de la Arena y Motor de Combate (Módulo 4 — Profesor Luis, Sección 2)

- **Formato de Duelo 1v1:** Los duelos se disputan entre 2 pilotos en formato al mejor de 3 asaltos (Best of 3). La serie concluye en cuanto uno de los pilotos alcanza 2 asaltos ganados o cuando el rival queda sin robots operativos por Knockout Técnico; si tras 3 asaltos hay empate, gana el piloto cuyo robot activo conserve mayor porcentaje de HP restante.
- **Rotación de Alineación:** El piloto puede cambiar libremente el robot de su alineación activa entre un asalto y otro enviando su identificador al ejecutar el asalto.

### Física de Ring: Fórmula Estocástica de Daño y Mitigación (RNG)

- **Cálculo de Ataque:** Daño bruto = (Fuerza Nativa + Bono de Armas) × RNG_Golpe, donde RNG_Golpe es una variable aleatoria entre 0.5 y 1.2.
- **Cálculo de Defensa:** Mitigación = (Defensa Nativa + Bono de Escudo) × RNG_Defensa, donde RNG_Defensa es una variable aleatoria entre 0.3 y 1.0.
- **Daño Neto:** Daño real aplicado = max(5, Daño bruto − Mitigación). Cada impacto resta HP al chasis, y desgasta los accesorios equipados: el escudo recibe `round(Daño neto × 0.5)` y cada arma equipada recibe `round(Daño bruto × 0.2)`.

## 6. Regla Crítica de Embargo y Confiscación (HP < 25%)

Si durante el combate la durabilidad del robot o de un accesorio cruza el umbral crítico, se activa el protocolo automático:

- **Umbral de Knockout Técnico:** Se declara cuando la salud actual cae estrictamente por debajo del 25% (HP < 25%); exactamente 25% no activa el umbral.
- **Embargo Parcial de Pieza:** Si el daño desgasta un accesorio (arma o escudo) por debajo de 25% HP, la pieza se desequipa para los asaltos restantes del combate y, al finalizar, se confisca y se envía al inventario de La Chatarrería.
- **Embargo Total de Robot:** Si la durabilidad del chasis cae por debajo de 25% HP, el robot completo (chasis y accesorios restantes) es confiscado y transferido al catálogo de subastas/remate de La Chatarrería sin reembolso.
- **No persistencia en sobrevivientes:** Los robots y piezas que terminan el combate con HP >= 25% no acumulan daño permanente entre combates; regresan a su línea base operativa en el Garaje (100% para artículos de fábrica, 50% para artículos reacondicionados).

## 7. Reparto de Premios e Incentivos Financieros

- **Premio al Ganador:** El piloto ganador recibe una bolsa de +$300 créditos acreditados inmediatamente en su Billetera Digital.
- **Incentivo de Participación:** El piloto perdedor recibe +$100 créditos por el simple hecho de completar el combate. Esto incentiva a enviar «chasis nudos» a pelear incluso en momentos de crisis económica.

## 8. Matriz de Responsabilidad por Cátedra y Módulos

A continuación se resume la distribución formal de responsabilidades entre los profesores y secciones:

| Módulo | Nombre del Módulo | Profesor Responsable | Alcance Principal |
|---|---|---|---|
| Módulo 1 | Tienda Oficial y Compras Unificadas | Profesor Yisheng | E-Commerce unificado (Fábrica + Usados) |
| Módulo 2 | La Chatarrería y Subastas | Profesor Luis (Sección 1) | Embargos (HP < 25%), tasación y subastas |
| Módulo 3 | Garaje, Ensamblador y Billetera | Profesor Ítalo Visconti | Billetera ($1.000), taller y Chasis Nudo |
| Módulo 4 | Arena 1v1 y Simulación | Profesor Luis (Sección 2) | Motor RNG, mejor de 3 y premios (+$300/+$100) |
