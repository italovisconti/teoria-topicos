### Nivel Fácil: Modelando Entidades Básicas

**Objetivo:** Familiarizarse con la sintaxis y el uso fundamental de `Tuplas`, `Records` (`type`) y `Enums`.

**Enunciado:**
Vas a modelar las entidades para una pequeña tienda online.

1.  **Producto Simple (Tupla):**
    *   Define un tipo `ProductoTupla` que represente un producto usando una tupla. Debe contener: `[código: number, nombre: string, precio: number]`.
    *   Crea una instancia de ejemplo para un producto.

2.  **Perfil de Usuario (Record):**
    *   Define un tipo `Usuario` usando un `type` (esto es un Record/Product Type). Debe contener las siguientes propiedades: `id` (number), `nombre` (string), `email` (string), y `activo` (boolean).
    *   Crea una instancia de ejemplo de un usuario.

3.  **Categoría de Producto (Enum):**
    *   Define un `enum` llamado `CategoriaProducto` con los siguientes valores: `Electronica`, `Ropa`, `Hogar`, `Alimentos`.
    *   Asigna los valores que prefieras (numéricos o de string).

4.  **Combinando todo:**
    *   Crea un nuevo tipo `ProductoCompleto` (usando un `type`) que sea un Record con las siguientes propiedades: `codigo` (number), `nombre` (string), `precio` (number), y `categoria` (del tipo `CategoriaProducto`).
    *   Crea una instancia de ejemplo de un `ProductoCompleto`.

#### Resolución
```ts
// 1. Producto Simple (Tupla)
type ProductoTupla = [codigo: number, nombre: string, precio: number];
const mouseGamer: ProductoTupla = [101, "Mouse Gamer RGB", 49.99];

console.log(`Producto: ${mouseGamer[1]}, Precio: $${mouseGamer[2]}`);


// 2. Perfil de Usuario (Record)
type Usuario = {
    id: number;
    nombre: string;
    email: string;
    activo: boolean;
};

const usuarioEjemplo: Usuario = {
    id: 1,
    nombre: "Ana López",
    email: "ana.lopez@email.com",
    activo: true,
};

console.log(`Usuario: ${usuarioEjemplo.nombre}, Email: ${usuarioEjemplo.email}`);


// 3. Categoría de Producto (Enum)
enum CategoriaProducto {
    Electronica = "ELECTRONICA",
    Ropa = "ROPA",
    Hogar = "HOGAR",
    Alimentos = "ALIMENTOS",
}

console.log(`Categoría disponible: ${CategoriaProducto.Electronica}`);


// 4. Combinando todo
type ProductoCompleto = {
    codigo: number;
    nombre: string;
    precio: number;
    categoria: CategoriaProducto;
};

const tecladoMecanico: ProductoCompleto = {
    codigo: 102,
    nombre: "Teclado Mecánico",
    precio: 120.50,
    categoria: CategoriaProducto.Electronica,
};

console.log(`Nuevo producto: ${tecladoMecanico.nombre}, Categoría: ${tecladoMecanico.categoria}`);

```

---
### Nivel Intermedio: Modelando Alternativas con Sum Types

**Objetivo:** Aplicar el concepto de **Sum Types** (uniones discriminadas) para modelar un sistema que puede tener varios estados o formas mutuamente excluyentes, combinado con **Product Types**.

**Enunciado:**
Estás construyendo una funcionalidad para procesar pagos. Un pago puede realizarse a través de tres métodos diferentes: `Tarjeta`, `PayPal` o `Efectivo`. Cada método tiene datos distintos.

1.  **Define los Product Types:**
    *   Crea un tipo `PagoTarjeta` que contenga: `tipo` (un string literal `'tarjeta'`), `numeroTarjeta` (string), y `cvv` (string).
    *   Crea un tipo `PagoPayPal` que contenga: `tipo` (un string literal `'paypal'`), y `email` (string).
    *   Crea un tipo `PagoEfectivo` que contenga: `tipo` (un string literal `'efectivo'`), y `montoEntregado` (number).

2.  **Crea el Sum Type:**
    *   Define un tipo `MetodoPago` que sea una unión de `PagoTarjeta`, `PagoPayPal` y `PagoEfectivo`. Este es tu Sum Type.

3.  **Implementa una función de procesamiento:**
    *   Escribe una función `procesarPago(pago: MetodoPago)` que reciba un objeto del tipo `MetodoPago`.
    *   Dentro de la función, utiliza un `switch` sobre la propiedad `tipo` (el discriminador) para determinar qué tipo de pago se está procesando.
    *   La función debe imprimir un mensaje descriptivo según el método de pago. Por ejemplo:
        *   Para tarjeta: `"Procesando pago con tarjeta que termina en XXXX..."` (muestra los últimos 4 dígitos).
        *   Para PayPal: `"Procesando pago con PayPal desde el email xxx@yyy.com..."`
        *   Para efectivo: `"Procesando pago en efectivo. Monto entregado: $XX.XX"`

```
// 1. Define los Product Types
type PagoTarjeta = {
    tipo: 'tarjeta';
    numeroTarjeta: string;
    cvv: string;
};

type PagoPayPal = {
    tipo: 'paypal';
    email: string;
};

type PagoEfectivo = {
    tipo: 'efectivo';
    montoEntregado: number;
};

// 2. Crea el Sum Type
type MetodoPago = PagoTarjeta | PagoPayPal | PagoEfectivo;

// 3. Implementa una función de procesamiento
function procesarPago(pago: MetodoPago): void {
    switch (pago.tipo) {
        case 'tarjeta':
            // TypeScript sabe que 'pago' es de tipo PagoTarjeta aquí
            const ultimosDigitos = pago.numeroTarjeta.slice(-4);
            console.log(`Procesando pago con tarjeta que termina en ${ultimosDigitos}.`);
            break;

        case 'paypal':
            // TypeScript sabe que 'pago' es de tipo PagoPayPal aquí
            console.log(`Procesando pago con PayPal desde el email ${pago.email}.`);
            break;

        case 'efectivo':
            // TypeScript sabe que 'pago' es de tipo PagoEfectivo aquí
            console.log(`Procesando pago en efectivo. Monto entregado: $${pago.montoEntregado}.`);
            break;
        
        default:
            // Caso para asegurar que todos los tipos son manejados
            const _exhaustiveCheck: never = pago;
            console.error("Método de pago no reconocido", _exhaustiveCheck);
    }
}

// Ejemplos de uso
const pago1: MetodoPago = {
    tipo: 'tarjeta',
    numeroTarjeta: '1234-5678-9012-3456',
    cvv: '123'
};

const pago2: MetodoPago = {
    tipo: 'paypal',
    email: 'comprador@email.com'
};

const pago3: MetodoPago = {
    tipo: 'efectivo',
    montoEntregado: 100
};

procesarPago(pago1); // Procesando pago con tarjeta que termina en 3456.
procesarPago(pago2); // Procesando pago con PayPal desde el email comprador@email.com.
procesarPago(pago3); 
```

---
### Nivel Difícil: Refactorizando hacia un Modelo de Datos Robusto

**Objetivo:** Identificar los problemas de un código débilmente tipado y refactorizarlo usando un modelo de datos robusto basado en Tipos Algebraicos (Product y Sum Types), eliminando `any` y manejando los casos de éxito y error de forma explícita.

**Enunciado:**
Tienes una función que recibe la respuesta de una API, pero está implementada con tipos muy permisivos (`any`), lo que la hace frágil y propensa a errores en tiempo de ejecución. Tu tarea es refactorizarla.

**Código Inicial (Problemático):**
```typescript
function manejarRespuestaAPI(respuesta: any) {
    if (!respuesta) {
        console.error("Error: La respuesta es nula o indefinida.");
        return;
    }

    if (respuesta.status === 200) {
        console.log("Usuario encontrado:", respuesta.data.name);
    } else if (respuesta.status === 404) {
        console.warn("Advertencia:", respuesta.errorMsg); // Ojo: a veces la propiedad es 'errorMsg', otras 'error'
    } else {
        console.error("Ocurrió un error inesperado en el servidor.");
    }
}
```

**Problemas a resolver:**
1.  El tipo `any` no ofrece ninguna seguridad.
2.  El manejo de errores es inconsistente (a veces la propiedad es `errorMsg`, otras `error`).
3.  No se manejan todos los posibles estados de forma explícita.

**Tu Tarea:**

1.  **Modela los Datos con Tipos Algebraicos:**
    *   Crea un tipo `Usuario` (Product Type) para los datos del usuario: `{ id: number; nombre: string; email: string }`.
    *   Crea un tipo `RespuestaExitosa` (Product Type) que contenga: `{ tipo: 'exito'; datos: Usuario }`.
    *   Crea un tipo `RespuestaError` (Product Type) que contenga: `{ tipo: 'error'; mensaje: string }`.
    *   Crea un tipo `RespuestaAPI` (Sum Type) que sea la unión de `RespuestaExitosa` y `RespuestaError`.
    *   Crea un tipo `ResultadoPeticion` (Sum Type) que represente el resultado completo de la llamada: `RespuestaAPI | { tipo: 'peticion_fallida' }`.

2.  **Crea Funciones de "Parseo" Seguras:**
    *   Escribe una función `parsearRespuesta(respuesta: any): ResultadoPeticion` que reciba la respuesta cruda de la API (`any`) y la transforme en tu modelo de datos seguro (`ResultadoPeticion`).
    *   Esta función debe validar la estructura de la respuesta y devolver el tipo correcto. Por ejemplo:
        *   Si `respuesta` es `null` o `undefined`, devuelve `{ tipo: 'peticion_fallida' }`.
        *   Si `respuesta.status === 200` y `respuesta.data` existe, devuelve un objeto `RespuestaExitosa`.
        *   Si `respuesta.status` es 4xx o 5xx, extrae el mensaje de error (de `error` o `errorMsg`) y devuelve un objeto `RespuestaError`.

3.  **Refactoriza la Función Principal:**
    *   Re-escribe `manejarRespuestaAPI` para que ahora reciba un parámetro del tipo `ResultadoPeticion`.
    *   Usa un `switch` (o `if/else`) sobre la propiedad `tipo` para manejar cada caso de forma segura y explícita, sin riesgo de acceder a propiedades que no existen.

```
// 1. Modelado de Datos
type Usuario = {
    id: number;
    nombre: string;
    email: string;
};

type RespuestaExitosa = {
    tipo: 'exito';
    datos: Usuario;
};

type RespuestaError = {
    tipo: 'error';
    mensaje: string;
};

type RespuestaAPI = RespuestaExitosa | RespuestaError;

type ResultadoPeticion = RespuestaAPI | { tipo: 'peticion_fallida' };

// 2. Función de "Parseo" Segura
function parsearRespuesta(respuesta: any): ResultadoPeticion {
    if (!respuesta) {
        return { tipo: 'peticion_fallida' };
    }

    if (respuesta.status === 200 && respuesta.data) {
        // Validar la estructura del usuario (simplificado)
        if (typeof respuesta.data.id === 'number' && typeof respuesta.data.nombre === 'string') {
            return {
                tipo: 'exito',
                datos: respuesta.data
            };
        }
    }

    // Unificar el mensaje de error
    const mensajeError = respuesta.error || respuesta.errorMsg || 'Error desconocido';
    return {
        tipo: 'error',
        mensaje: mensajeError
    };
}

// 3. Función Principal Refactorizada
function manejarRespuestaAPI(resultado: ResultadoPeticion): void {
    switch (resultado.tipo) {
        case 'exito':
            // TypeScript sabe que 'resultado.datos' es de tipo Usuario
            console.log(`Éxito: Bienvenido, ${resultado.datos.nombre}!`);
            break;
        
        case 'error':
            // TypeScript sabe que 'resultado.mensaje' es un string
            console.error(`Error de API: ${resultado.mensaje}`);
            break;

        case 'peticion_fallida':
            console.error("Error de Red: La petición a la API no pudo completarse.");
            break;

        default:
            const _exhaustiveCheck: never = resultado;
            return _exhaustiveCheck;
    }
}

// --- Pruebas ---
console.log("--- Caso Exitoso ---");
const respuestaExitosaAPI = { status: 200, data: { id: 1, nombre: 'Italo Visconti', email: 'italo@profe.com' } };
manejarRespuestaAPI(parsearRespuesta(respuestaExitosaAPI));

console.log("\n--- Caso Error Cliente ---");
const respuestaErrorAPI = { status: 404, errorMsg: "El recurso solicitado no fue encontrado." };
manejarRespuestaAPI(parsearRespuesta(respuestaErrorAPI));

console.log("\n--- Caso Petición Fallida ---");
const respuestaNula = null;
manejarRespuestaAPI(parsearRespuesta(respuestaNula));

console.log("\n--- Caso Error Servidor (formato inconsistente) ---");
const respuestaErrorServidor = { status: 500, error: "Fallo en la base de datos." };
manejarRespuestaAPI(parsearRespuesta(respuestaErrorServidor));

```

