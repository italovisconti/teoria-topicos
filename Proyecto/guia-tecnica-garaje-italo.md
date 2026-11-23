# Guía técnica: Módulo 3 - Garaje, ensamblador y billetera

**Responsable:** Profesor Ítalo Visconti
**Sistema:** WAR-BOTS
**Base de datos:** `jugadores_garaje_db`
**Especificación general:** [WAR-BOTS](especificacion-general-war-bots.md)

## 1. Alcance

Esta guía desarrolla las APIs 21–30 y el modelo MongoDB del módulo: registro y perfil de jugadores, gestión de billetera, inventario, ensamblaje, alineación y rescate por bancarrota. La [especificación general](especificacion-general-war-bots.md) reúne las 40 APIs.

## 2. Reglas de negocio

- El alta asigna saldo inicial de 1000 créditos. No se permite saldo negativo; cualquier `DEBITO` superior al saldo actual se rechaza con `409 Conflict`.
- El rescate por bancarrota es único y otorga 500 créditos si el saldo es 0 y el jugador no tiene robots operativos. El servidor verifica estas condiciones; el cliente no envía el monto.
- Un robot dispone de un slot de chasis, hasta dos slots de armas y uno de escudo. Los atributos totales se calculan como atributos base más bonos de piezas. Al ingresar una pieza de tipo `chasis` mediante API 25, M3 crea automáticamente el documento de robot en estado `CHASIS_NUDO`.
- Fuerza 25 y defensa 20 son valores de ejemplo para un chasis, no valores fijos de todos los tipos. Los atributos base dependen del chasis.
- El KO ocurre con HP < 25%; exactamente 25% no activa KO. El chasis nudo conserva capacidad de combate mientras tenga HP >= 25%. Las piezas/robots por debajo del umbral se confiscan.
- Los artículos de fábrica ingresan con `hp_actual = 100` (`hp_max = 100`) y los artículos reacondicionados de Chatarrería ingresan con `hp_actual = 50` (`hp_max = 100`). Quienes sobreviven a un combate con HP >= 25% no acumulan daño permanente entre peleas y conservan su línea base operativa.

El reglamento relacionado está en [Reglamento oficial del juego de robots](reglamento-oficial-juego-robots.md).

## 3. Modelo de datos MongoDB

**Base de datos:** `jugadores_garaje_db`

El modelo mantiene saldo y estado del rescate en `jugadores`, agrupa el garaje como relación lógica mediante `garaje_id` y normaliza robots, piezas y movimientos de saldo en cuatro colecciones.

### Colección `jugadores`

| Atributo | Tipo de dato | Requerido | Descripción y propósito |
|---|---|---:|---|
| `_id` | `ObjectId` | Sí | Identificador MongoDB del jugador; corresponde al identificador interno usado por las rutas. |
| `alias` | `String` | Sí | Alias del perfil. |
| `email` | `String` | Sí | Correo asociado al jugador. |
| `saldo` | `Number` | Sí | Saldo actual. |
| `nivel` | `Number` | Sí | Nivel mostrado por el perfil; valor inicial: 1. |
| `garaje_id` | `ObjectId` | Sí | Identificador lógico de garaje devuelto al registrar. No exige colección `garajes`: el garaje corresponde al conjunto de robots y piezas del jugador. |
| `rescate_utilizado` | `Boolean` | Sí | Control para impedir más de un rescate; inicial `false`. |
| `created_at` | `Date` | Sí | Fecha de creación del registro. |
| `updated_at` | `Date` | Sí | Fecha de última actualización. |

**Índices:** índice único para `email`.

### Colección `robots`

| Atributo | Tipo de dato | Requerido | Descripción y propósito |
|---|---|---:|---|
| `_id` | `ObjectId` | Sí | Identificador de instancia; se expone como `robot_id`. |
| `jugador_id` | `ObjectId` | Sí | Referencia a `jugadores._id`, propietaria del robot. |
| `nombre_robot` | `String` | Sí | Nombre de instancia del robot. |
| `chasis_pieza_id` | `ObjectId` | Sí | Referencia a la pieza de tipo chasis que aporta los atributos nativos. |
| `armas_ids` | `Array[ObjectId]` | Sí | Referencias a cero, una o hasta dos piezas de tipo arma equipadas. |
| `escudo_id` | `ObjectId` | No | Referencia a la pieza de tipo escudo si está equipada. |
| `hp_actual` | `Number` | Sí | HP operativo del robot (heredado del chasis: `100` fábrica / `50` reacondicionado). |
| `hp_max` | `Number` | Sí | HP máximo del chasis (`100`). |
| `created_at` | `Date` | Sí | Fecha de creación del robot. |
| `updated_at` | `Date` | Sí | Fecha de última actualización. |

`fuerza_total` y `defensa_total` se calculan al consultar o ensamblar como base del chasis más bonos equipados; no se persisten como valores canónicos para evitar desincronización.

### Colección `piezas`

| Atributo | Tipo de dato | Requerido | Descripción y propósito |
|---|---|---:|---|
| `_id` | `ObjectId` | Sí | Identificador de instancia; se expone como `pieza_instancia_id`. |
| `jugador_id` | `ObjectId` | Sí | Referencia al propietario. |
| `sku` | `String` | Sí | SKU de catálogo de origen; distinto de `_id`, que identifica la instancia del jugador. |
| `nombre_item` | `String` | Sí | Nombre comercial de la pieza. |
| `tipo` | `String` | Sí | Tipo de pieza: `chasis`, `arma` o `escudo`. |
| `fuerza_bono` | `Number` | Sí | Aporte de fuerza. Para una pieza chasis, estos valores representan sus atributos base nativos. |
| `defensa_bono` | `Number` | Sí | Aporte de defensa. Para una pieza chasis, estos valores representan sus atributos base nativos. |
| `precio_lista` | `Number` | Sí | Precio base de lista para referencia de tasación en M2. |
| `hp_actual` | `Number` | Sí | Durabilidad operativa actual (`100` para `FABRICA`; `50` para `CHATARRERIA`). |
| `hp_max` | `Number` | Sí | Durabilidad máxima (`100`). |
| `imagen_url` | `String` | Sí | URL de imagen recibida en el payload de inventario. |
| `origen` | `String` | Sí | Procedencia (`FABRICA` o `CHATARRERIA`) para trazabilidad y línea base de HP. |
| `created_at` | `Date` | Sí | Fecha de incorporación de la instancia. |

Cada pieza se relaciona con su instancia y propietario.

### Colección `movimientos_saldo`

| Atributo | Tipo de dato | Requerido | Descripción y propósito |
|---|---|---:|---|
| `_id` | `ObjectId` | Sí | Identificador del movimiento. |
| `jugador_id` | `ObjectId` | Sí | Referencia al jugador afectado. |
| `monto` | `Number` | Sí | Importe aplicado. |
| `operacion` | `String` | Sí | `DEBITO` o `CREDITO`, como en API 23. |
| `concepto` | `String` | Sí | Concepto recibido en API 23. |
| `saldo_anterior` | `Number` | Sí | Saldo antes de aplicar el movimiento. |
| `nuevo_saldo` | `Number` | Sí | Saldo después del movimiento. |
| `referencia_operacion` | `String` | No | Identificador externo para conciliación e idempotencia. |
| `created_at` | `Date` | Sí | Fecha de aplicación del movimiento. |

Actualizar el saldo del jugador y registrar su movimiento como una operación atómica, por ejemplo mediante una transacción MongoDB cuando el despliegue lo permita.

## 4. APIs REST

Los parámetros marcados con «Sí» son obligatorios y los marcados con «No» son opcionales.
### API 21. Registrar jugador

**Método y endpoint:** `POST /api/v1/jugadores/registro`

**Propósito:** registrar al jugador y crear su billetera con 1000 créditos iniciales.

**Integración:** Servicio bancario inicial.

#### Parámetros

| Parámetro | Ubicación | Tipo de dato | Requerido | Descripción |
|---|---|---|---|---|
| `alias` | body | String | Sí | Alias único del jugador. |
| `email` | body | String | Sí | Correo único del jugador. |

#### Request
```json
{
  "alias": "piloto_01",
  "email": "piloto01@example.test"
}
```

#### Response - 201 Created
```json
{
  "jugador_id": "jug_001",
  "saldo_inicial": 1000,
  "garaje_id": "gar_001"
}
```

| Campo | Tipo de dato | Descripción |
|---|---|---|
| `jugador_id` | String | Identificador del jugador. |
| `saldo_inicial` | Number | Saldo inicial: 1000 créditos. |
| `garaje_id` | String | Identificador del garaje creado. |

### API 22. Consultar perfil

**Método y endpoint:** `GET /api/v1/jugadores/:id/perfil`

**Propósito:** consultar información, saldo y estadísticas del jugador.

**Integración:** Consultada por los módulos que necesitan datos del jugador y su saldo.

#### Parámetros

| Parámetro | Ubicación | Tipo de dato | Requerido | Descripción |
|---|---|---|---|---|
| `id` | ruta | String | Sí | Identificador del jugador. |

#### Request

Sin cuerpo.

#### Response - 200 OK
```json
{
  "jugador_id": "jug_001",
  "alias": "piloto_01",
  "saldo": 1000,
  "nivel": 1
}
```

| Campo | Tipo de dato | Descripción |
|---|---|---|
| `jugador_id` | String | Identificador del jugador. |
| `alias` | String | Alias del jugador. |
| `saldo` | Number | Saldo actual. |
| `nivel` | Number | Nivel del jugador. |

### API 23. Actualizar saldo

**Método y endpoint:** `PUT /api/v1/jugadores/:id/saldo`

**Propósito:** efectuar débitos o créditos. La operación se integra con M1, M2 y M4.

**Integración:** Invocada por M1, M2 y M4.

#### Parámetros

| Parámetro | Ubicación | Tipo de dato | Requerido | Descripción |
|---|---|---|---|---|
| `id` | ruta | String | Sí | Identificador del jugador. |
| `monto` | body | Number | Sí | Monto positivo de la operación (> 0). |
| `operacion` | body | String | Sí | `DEBITO` o `CREDITO`. |
| `concepto` | body | String | Sí | Concepto de la operación. |
| `referencia_operacion` | body | String | No | Identificador externo opcional para idempotencia. |

#### Request
```json
{
  "monto": 300,
  "operacion": "CREDITO",
  "concepto": "premio_combate",
  "referencia_operacion": "cmb_001_premio"
}
```

#### Response - 200 OK
```json
{
  "jugador_id": "jug_001",
  "saldo_anterior": 1000,
  "nuevo_saldo": 1300
}
```

| Campo | Tipo de dato | Descripción |
|---|---|---|
| `jugador_id` | String | Identificador del jugador. |
| `saldo_anterior` | Number | Saldo previo. |
| `nuevo_saldo` | Number | Saldo resultante. |

No se permite saldo negativo: un `DEBITO` con `monto > saldo` debe responder `409 Conflict` sin modificar el saldo.

### API 24. Consultar inventario

**Método y endpoint:** `GET /api/v1/jugadores/:id/inventario`

**Propósito:** obtener el inventario de robots, chasis y armas.

**Integración:** Entrega los datos de inventario del jugador.

#### Parámetros

| Parámetro | Ubicación | Tipo de dato | Requerido | Descripción |
|---|---|---|---|---|
| `id` | ruta | String | Sí | Identificador del jugador. |

#### Request

Sin cuerpo.

#### Response - 200 OK
```json
{
  "robots": [],
  "piezas_sueltas": []
}
```

| Campo | Tipo de dato | Descripción |
|---|---|---|
| `robots` | Array de objetos | Robots del jugador con `{robot_id, nombre_robot, chasis_pieza_id, armas_ids, escudo_id, hp_actual, hp_max, fuerza_total, defensa_total}`. |
| `piezas_sueltas` | Array de objetos | Piezas no equipadas con `{pieza_instancia_id, sku, nombre_item, tipo, fuerza_bono, defensa_bono, precio_lista, hp_actual, hp_max, origen, imagen_url}`. |

### API 25. Ingresar pieza al inventario

**Método y endpoint:** `POST /api/v1/jugadores/:id/inventario`

**Propósito:** agregar piezas compradas o ganadas al inventario desde M1 y M2. Si `tipo` es `chasis`, crea automáticamente el robot correspondiente en estado `CHASIS_NUDO` (y equipa `piezas_adjuntas` si provienen de una subasta de robot completo).

**Integración:** Recibe productos comprados por M1 y M2.

#### Parámetros

| Parámetro | Ubicación | Tipo de dato | Requerido | Descripción |
|---|---|---|---|---|
| `id` | ruta | String | Sí | Identificador del jugador. |
| `pieza_payload` | body | Object | Sí | Datos de la pieza. |
| `pieza_payload.sku` | body | String | Sí | SKU de la pieza. |
| `pieza_payload.nombre_item` | body | String | Sí | Nombre comercial de la pieza. |
| `pieza_payload.tipo` | body | String | Sí | Tipo de pieza: `chasis`, `arma` o `escudo`. |
| `pieza_payload.fuerza_bono` | body | Number | Sí | Bono de fuerza (o fuerza base si es `chasis`). |
| `pieza_payload.defensa_bono` | body | Number | Sí | Bono de defensa (o defensa base si es `chasis`). |
| `pieza_payload.precio_lista` | body | Number | Sí | Precio base de lista para tasación futura. |
| `pieza_payload.imagen_url` | body | String | Sí | URL de imagen. |
| `pieza_payload.origen` | body | String | No | `FABRICA` (por defecto) o `CHATARRERIA`. |
| `pieza_payload.hp_actual` | body | Number | No | Durabilidad inicial (`100` para `FABRICA`, `50` para `CHATARRERIA` por defecto). |
| `pieza_payload.piezas_adjuntas` | body | Array[Object] | No | Accesorios adjuntos cuando M2 transfiere un robot completo adjudicado en subasta. |

#### Request
```json
{
  "pieza_payload": {
    "sku": "ARM-LASER-01",
    "nombre_item": "Láser Plasma X",
    "tipo": "arma",
    "fuerza_bono": 10,
    "defensa_bono": 0,
    "precio_lista": 450,
    "origen": "FABRICA",
    "hp_actual": 100,
    "imagen_url": "https://ejemplo.test/piezas/laser-01.png"
  }
}
```

#### Response - 201 Created
```json
{
  "pieza_instancia_id": "pza_001",
  "robot_id": null,
  "asignada": true
}
```

| Campo | Tipo de dato | Descripción |
|---|---|---|
| `pieza_instancia_id` | String | Identificador de instancia de la pieza. |
| `robot_id` | String \| null | Identificador del robot creado si `tipo` es `chasis`; `null` en otro caso. |
| `asignada` | Boolean | Indica que fue asignada al inventario. |

### API 26. Procesar embargo de piezas

**Método y endpoint:** `POST /api/v1/jugadores/:id/embargo-piezas`

**Propósito:** retirar del inventario (y desequipar de cualquier robot) las piezas o robots confiscados por Arena, devueltos en Tienda o vendidos vía Chatarra Express.

**Integración:** Invocada por M4 (embargos), M1 (devoluciones API 10) y M2 (Chatarra Express API 19).

#### Parámetros

| Parámetro | Ubicación | Tipo de dato | Requerido | Descripción |
|---|---|---|---|---|
| `id` | ruta | String | Sí | Identificador del jugador afectado. |
| `piezas_confiscadas_ids` | body | Array[String] | Sí | Identificadores de instancia o `robot_id` a retirar. |
| `motivo` | body | String | No | `EMBARGO` (por defecto), `DEVOLUCION` o `VENTA_EXPRESS`. |

#### Request
```json
{
  "piezas_confiscadas_ids": [
    "pza_001"
  ]
}
```

#### Response - 200 OK
```json
{
  "removidas": [
    "pza_001"
  ],
  "inventario_actualizado": true
}
```

| Campo | Tipo de dato | Descripción |
|---|---|---|
| `removidas` | Array de strings | Identificadores efectivamente removidos. |
| `inventario_actualizado` | Boolean | Indica actualización del inventario. |

### API 27. Ensamblar robot

**Método y endpoint:** `POST /api/v1/jugadores/:id/robots/ensamblar`

**Propósito:** montar armas y escudo y calcular fuerza y defensa combinadas.

**Integración:** Calcula estadísticas combinadas.

#### Parámetros

| Parámetro | Ubicación | Tipo de dato | Requerido | Descripción |
|---|---|---|---|---|
| `id` | ruta | String | Sí | Identificador del jugador. |
| `robot_id` | body | String | Sí | Identificador del robot. |
| `armas_ids` | body | Array[String] | Sí | Lista de hasta 2 `pieza_instancia_id` de tipo `arma` (puede ser vacía `[]`). |
| `escudo_id` | body | String \| null | No | `pieza_instancia_id` de tipo `escudo`; omitir o enviar `null` para ensamblar sin escudo. |

#### Request
```json
{
  "robot_id": "rob_001",
  "armas_ids": [
    "pza_001",
    "pza_002"
  ],
  "escudo_id": "pza_003"
}
```

#### Response - 200 OK
```json
{
  "robot_id": "rob_001",
  "fuerza_total": 45,
  "defensa_total": 30
}
```

| Campo | Tipo de dato | Descripción |
|---|---|---|
| `robot_id` | String | Identificador del robot. |
| `fuerza_total` | Number | Fuerza base más bonos equipados. |
| `defensa_total` | Number | Defensa base más bonos equipados. |

La configuración contempla un chasis, hasta dos armas y un escudo. Los valores base dependen del chasis; 25 de fuerza y 20 de defensa son solo un ejemplo.

### API 28. Desmontar robot

**Método y endpoint:** `POST /api/v1/jugadores/:id/robots/desmontar`

**Propósito:** retirar accesorios y dejar el robot como Chasis Nudo, manteniendo sus atributos nativos.

**Integración:** Deja el robot con chasis y atributos nativos.

#### Parámetros

| Parámetro | Ubicación | Tipo de dato | Requerido | Descripción |
|---|---|---|---|---|
| `id` | ruta | String | Sí | Identificador del jugador. |
| `robot_id` | body | String | Sí | Identificador del robot. |

#### Request
```json
{
  "robot_id": "rob_001"
}
```

#### Response - 200 OK
```json
{
  "robot_id": "rob_001",
  "estado": "CHASIS_NUDO",
  "stats_base": {
    "fuerza": 25,
    "defensa": 20
  }
}
```

| Campo | Tipo de dato | Descripción |
|---|---|---|
| `robot_id` | String | Identificador del robot. |
| `estado` | String | Estado resultante: `CHASIS_NUDO`. |
| `stats_base` | Object | Atributos nativos. |
| `stats_base.fuerza` | Number | Fuerza base de este ejemplo. |
| `stats_base.defensa` | Number | Defensa base de este ejemplo. |

### API 29. Consultar alineación

**Método y endpoint:** `GET /api/v1/jugadores/:id/robots/alineacion`

**Propósito:** validar la alineación activa y entregar el snapshot completo de combate antes del duelo.

**Integración:** Consultada por M4 al crear una sala 1v1. `listo_combate` es `true` únicamente cuando el chasis del robot tiene `hp_actual >= 25`.

#### Parámetros

| Parámetro | Ubicación | Tipo de dato | Requerido | Descripción |
|---|---|---|---|---|
| `id` | ruta | String | Sí | Identificador del jugador. |

#### Request

Sin cuerpo.

#### Response - 200 OK
```json
{
  "alineacion": [
    {
      "robot_id": "rob_001",
      "nombre_robot": "Titan-01",
      "hp_actual": 100,
      "listo_combate": true,
      "fuerza_total": 45,
      "defensa_total": 30,
      "chasis": {
        "pieza_instancia_id": "pza_000",
        "sku": "CHA-TITAN-01",
        "nombre_item": "Chasis Titan",
        "precio_lista": 300,
        "hp_actual": 100,
        "imagen_url": "https://ejemplo.test/piezas/chasis-01.png"
      },
      "armas": [
        {
          "pieza_instancia_id": "pza_001",
          "sku": "ARM-LASER-01",
          "nombre_item": "Láser Plasma X",
          "precio_lista": 200,
          "fuerza_bono": 20,
          "hp_actual": 100,
          "imagen_url": "https://ejemplo.test/piezas/laser-01.png"
        }
      ],
      "escudo": {
        "pieza_instancia_id": "pza_003",
        "sku": "ESC-AEGIS-01",
        "nombre_item": "Escudo Aegis",
        "precio_lista": 150,
        "defensa_bono": 10,
        "hp_actual": 100,
        "imagen_url": "https://ejemplo.test/piezas/escudo-01.png"
      }
    }
  ]
}
```

| Campo | Tipo de dato | Descripción |
|---|---|---|
| `alineacion` | Array de objetos | Robots operativos de la alineación. |
| `alineacion[].robot_id` | String | Identificador del robot. |
| `alineacion[].nombre_robot` | String | Nombre del robot. |
| `alineacion[].hp_actual` | Number | HP operativo del robot. |
| `alineacion[].listo_combate` | Boolean | `true` si `chasis.hp_actual >= 25`. |
| `alineacion[].fuerza_total` | Number | Fuerza base del chasis más bonos de armas. |
| `alineacion[].defensa_total` | Number | Defensa base del chasis más bono de escudo. |
| `alineacion[].chasis` | Object | Snapshot de la pieza chasis. |
| `alineacion[].armas` | Array de objetos | Snapshot de armas equipadas (0 a 2). |
| `alineacion[].escudo` | Object \| null | Snapshot del escudo equipado o `null`. |

### API 30. Restablecer por bancarrota

**Método y endpoint:** `POST /api/v1/jugadores/:id/bancarrota/reset`

**Propósito:** otorgar el fondo de rescate por bancarrota, sujeto a validación del servidor.

**Integración:** Aplica las condiciones de rescate por bancarrota.

#### Parámetros

| Parámetro | Ubicación | Tipo de dato | Requerido | Descripción |
|---|---|---|---|---|
| `id` | ruta | String | Sí | Identificador del jugador. El servidor valida saldo 0, ausencia de robots operativos y que el rescate único no se haya usado. |

#### Request

Sin cuerpo; no se envía monto desde el cliente.

#### Response - 200 OK
```json
{
  "rescate_otorgado": true,
  "nuevo_saldo": 500
}
```

| Campo | Tipo de dato | Descripción |
|---|---|---|
| `rescate_otorgado` | Boolean | Indica que se otorgó el rescate. |
| `nuevo_saldo` | Number | Nuevo saldo: 500 créditos. |


## 5. Puntos abiertos

- Política de autenticación, autorización e idempotencia entre módulos.
- Catálogo de códigos de error estandarizados para validaciones de negocio (p. ej. `409 Conflict` en débito insuficiente o rescate ya utilizado).
