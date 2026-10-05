> [!NOTE] Referencias
> Riscutia, 2020 - Capítulo 3

*Empezaremos la unidad revisitando los patrones de diseño que los alumnos estudiaron el semestre pasado: Singleton, Factory, Strategy, Decorator y como nuevo patron: Composite. No nos enfocaremos en los principios SOLID. Yo les dare el UML, ellos lo implementaran en TS.*
## Patrones:
### [Singleton](Patrones/Singleton.md)
*Patrón de diseño creacional que nos permite asegurarnos de que una clase tenga una única instancia, a la vez que proporciona un punto de acceso global a dicha instancia.*
### [Factory](Patrones/Factory.md)
*Patrón de diseño creacional que proporciona una interfaz para crear objetos en una superclase, mientras permite a las subclases alterar el tipo de objetos que se crearán.*
### [Strategy](Patrones/Strategy.md)
*Patrón de diseño de comportamiento que te permite definir una familia de algoritmos, colocar cada uno de ellos en una clase separada y hacer sus objetos intercambiables. Strategy deja que sus algoritmos varíen independientemente de los clientes que los usen*
### [Composite](Patrones/Composite.md)
*Patrón de diseño estructural que te permite componer objetos en estructuras de árbol y trabajar con esas estructuras como si fueran objetos individuales.*
### [Decorator](Patrones/Decorator.md)
*Patrón estructural que te permite añadir funcionalidades a objetos colocando estos objetos dentro de objetos encapsuladores especiales que contienen estas funcionalidades.*

---
# Composicion y Tipos de datos algebraicos

Las **tuplas** en TypeScript son un tipo de dato que te permite crear arrays con un **número fijo de elementos** donde **cada posición tiene un tipo específico**.
## ¿Qué son las tuplas?

A diferencia de los arrays normales (donde todos los elementos son del mismo tipo), las tuplas te permiten mezclar tipos diferentes pero en posiciones específicas y predefinidas.

```typescript
// Array normal - todos elementos del mismo tipo
let numeros: number[] = [1, 2, 3, 4];

// Tupla - tipos específicos en posiciones específicas
let persona: [string, number, boolean] = ["Juan", 25, true];
//                ↑      ↑       ↑
//            nombre   edad   activo
```

## Características principales

### 1. **Orden importa**
```typescript
let coordenada: [number, number] = [10, 20]; // Correcto
let coordenada2: [number, number] = [20, 10]; // Correcto
let coordenada3: [number, number] = ["10", 20]; // Error: string no es number
```

### 2. **Longitud fija**
```typescript
let punto: [number, number] = [1, 2];
// punto.push(3); // Permitido pero rompe el contrato de tupla
```
``
### 3. **Acceso por índice**
```typescript
let usuario: [string, number, boolean] = ["Ana", 30, false];

console.log(usuario[0]); // "Ana" - TypeScript sabe que es string
console.log(usuario[1]); // 30 - TypeScript sabe que es number
console.log(usuario[2]); // false - TypeScript sabe que es boolean
```

## Casos de uso comunes

### 1. **Retornar múltiples valores de una función**
```typescript
function obtenerNombreYEdad(): [string, number] {
    return ["Carlos", 28];
}

const [nombre, edad] = obtenerNombreYEdad();
console.log(`${nombre} tiene ${edad} años`);
```

### 2. **Coordenadas o puntos**
```typescript
type Punto2D = [number, number];
type Punto3D = [number, number, number];

let origen: Punto2D = [0, 0];
let cubo: Punto3D = [1, 2, 3];
```

### 3. **Pares clave-valor**
```typescript
type ConfigEntry = [string, any];

let configuracion: ConfigEntry[] = [
    ["puerto", 3000],
    ["debug", true],
    ["nombre", "Mi App"]
];
```

## Tuplas vs Arrays

| Aspecto          | Array                   | Tupla                        |
| ---------------- | ----------------------- | ---------------------------- |
| **Tipos**        | Todos iguales           | Diferentes por posición      |
| **Longitud**     | Variable                | Fija                         |
| **Acceso**       | Por índice (mismo tipo) | Por índice (tipo específico) |
| **Flexibilidad** | Alta                    | Baja                         |

```typescript
// Array - flexible pero menos específico
let datos: (string | number)[] = ["Juan", 25, "Ana", 30];

// Tupla - rígida pero más específica
let persona: [string, number] = ["Juan", 25];
```

## Tuplas con nombres (Labeled Tuples)

```typescript
type Persona = [nombre: string, edad: number, activo: boolean];

let usuario: Persona = ["Pedro", 35, true];
// Los labels son solo para documentación, no cambian el comportamiento
```

## Tuplas opcionales y rest

```typescript
// Elementos opcionales (al final)
type Respuesta = [boolean, string?];
let ok: Respuesta = [true];
let error: Respuesta = [false, "Error de conexión"];

// Rest elements
type ListaConTotal = [number, ...string[]];
let ventas: ListaConTotal = [150, "producto1", "producto2", "producto3"];
```

## ¿Cuándo usar tuplas?

**Usa tuplas cuando:**
- Necesites retornar múltiples valores relacionados de una función
- Tengas datos con estructura fija y tipos específicos por posición
- Quieras aprovechar destructuring con tipos específicos

**Evita tuplas cuando:**
- Los datos puedan crecer dinámicamente
- Necesites flexibilidad en el orden o tipos
- La legibilidad se vea comprometida (mejor usa objetos)

```typescript
// Tupla confusa
type Usuario = [string, number, string, boolean, string];

// Mejor como objeto
type Usuario = {
    nombre: string;
    edad: number;
    email: string;
    activo: boolean;
    rol: string;
};
```

---
# Tipos Record (Tipos de Registro)

Los **tipos record** son como tuplas, pero en lugar de acceder por posición, accedes por **nombre**. Son una evolución de las tuplas que mejora significativamente la **legibilidad** y **mantenimiento** del código.

## ¿Qué son los Records?

Son estructuras de datos que **combinan múltiples tipos**, pero a diferencia de las tuplas, cada campo tiene un **nombre descriptivo**.

```typescript
// Tupla - acceso por posición
type PersonaTupla = [string, number, boolean];
const persona1: PersonaTupla = ["Ana", 25, true];
console.log(persona1[0]); // ¿Qué es [0]?

// Record - acceso por nombre
type PersonaRecord = {
    nombre: string;
    edad: number;
    activo: boolean;
};
const persona2: PersonaRecord = { nombre: "Ana", edad: 25, activo: true };
console.log(persona2.nombre); // ¡Claro y directo! 
```

## Ventajas sobre las tuplas

### 1. **Legibilidad mejorada**
```typescript
// Tupla confusa
function crearUsuario(): [string, string, number, boolean, string] {
    return ["juan123", "juan@email.com", 25, true, "admin"];
}
const usuario = crearUsuario();
// ¿Qué es usuario[3]? 🤷‍♂️

// Record claro
function crearUsuarioRecord(): {
    username: string;
    email: string;
    edad: number;
    activo: boolean;
    rol: string;
} {
    return {
        username: "juan123",
        email: "juan@email.com",
        edad: 25,
        activo: true,
        rol: "admin"
    };
}
const usuarioRecord = crearUsuarioRecord();
console.log(usuarioRecord.activo); // ¡Autodocumentado! 📖
```

### 2. **Mantenimiento sencillo**
```typescript
// Si necesitas agregar un campo nuevo:

// Con tupla - Problema: rompe todo el código existente
type UsuarioTupla = [string, number, boolean]; // Antes
type UsuarioTupla = [string, number, boolean, string]; // Después - Cambio orden

// Con record - Solucion: solo agregas el campo
type UsuarioRecord = {
    nombre: string;
    edad: number;
    activo: boolean;
    // Nuevo campo - no afecta el código existente
    telefono?: string; // Opcional para compatibilidad
};
```

### 3. **Tipado fuerte y autocomplete**
```typescript
type ConfiguracionApp = {
    puerto: number;
    baseDatos: string;
    debug: boolean;
    maxUsuarios: number;
};

const config: ConfiguracionApp = {
    puerto: 3000,
    baseDatos: "mongodb://localhost",
    debug: true,
    maxUsuarios: 100
};

// TypeScript te ayuda con autocomplete
config.puerto; // El IDE te sugiere las propiedades
config.purto;  // Error: no existe esta propiedad
```

### 4. **Menos ambigüedad**
```typescript
// Tupla ambigua - ¿qué representa cada posición?
function calcularDistancia(punto1: [number, number], punto2: [number, number]): number {
    return Math.sqrt((punto2[0] - punto1[0]) ** 2 + (punto2[1] - punto1[1]) ** 2);
}

// Record claro - no hay dudas
type Punto = {
    x: number;
    y: number;
};

function calcularDistanciaClara(punto1: Punto, punto2: Punto): number {
    return Math.sqrt((punto2.x - punto1.x) ** 2 + (punto2.y - punto1.y) ** 2);
}
```

## Records vs Otros tipos

| Característica | Tupla | Record | Clase |
|----------------|-------|--------|-------|
| **Acceso** | Por índice (`[0]`) | Por nombre (`.prop`) | Por nombre (`.prop`) |
| **Mutabilidad** | Mutable | Inmutable por defecto | Mutable |
| **Métodos** | No | No | Sí |
| **Legibilidad** | Baja | Alta | Alta |
| **Simplicidad** | Alta | Media | Baja |

## Casos de uso ideales

### 1. **Configuraciones**
```typescript
type ConfigBD = {
    host: string;
    puerto: number;
    usuario: string;
    contraseña: string;
    ssl: boolean;
};

const config: ConfigBD = {
    host: "localhost",
    puerto: 5432,
    usuario: "admin",
    contraseña: "secreto",
    ssl: false
};
```

### 2. **Respuestas de API**
```typescript
type RespuestaUsuario = {
    id: number;
    nombre: string;
    email: string;
    fechaCreacion: string;
    ultimoAcceso: string | null;
};

async function obtenerUsuario(id: number): Promise<RespuestaUsuario> {
    // Lógica de API
    return {
        id: 1,
        nombre: "María",
        email: "maria@email.com",
        fechaCreacion: "2024-01-15",
        ultimoAcceso: "2024-01-20"
    };
}
```

### 3. **Estado de aplicación**
```typescript
type EstadoJuego = {
    jugadorActual: string;
    puntuacion: number;
    nivel: number;
    vidas: number;
    tiempoRestante: number;
    pausa: boolean;
};

const estadoInicial: EstadoJuego = {
    jugadorActual: "Player1",
    puntuacion: 0,
    nivel: 1,
    vidas: 3,
    tiempoRestante: 300,
    pausa: false
};
```

## Records anidados y complejos

```typescript
type Direccion = {
    calle: string;
    ciudad: string;
    codigoPostal: string;
    pais: string;
};

type Contacto = {
    telefono: string;
    email: string;
};

type Empleado = {
    id: number;
    nombre: string;
    apellidos: string;
    direccion: Direccion;     // Record anidado
    contacto: Contacto;       // Record anidado
    departamento: string;
    salario: number;
    fechaIngreso: Date;
};

const empleado: Empleado = {
    id: 1001,
    nombre: "Carlos",
    apellidos: "González",
    direccion: {
        calle: "Av. Principal 123",
        ciudad: "Caracas",
        codigoPostal: "1010",
        pais: "Venezuela"
    },
    contacto: {
        telefono: "+58-212-1234567",
        email: "carlos@empresa.com"
    },
    departamento: "Desarrollo",
    salario: 50000,
    fechaIngreso: new Date("2023-06-15")
};

// Acceso claro y autodocumentado
console.log(`${empleado.nombre} vive en ${empleado.direccion.ciudad}`);
console.log(`Contacto: ${empleado.contacto.email}`);
```

## ¿Cuándo usar Records?

**Usa Records cuando:**
- Necesites estructuras de datos con campos con nombre
- La legibilidad y autodocumentación sean importantes
- Tengas múltiples valores relacionados pero de tipos diferentes
- Quieras inmutabilidad por defecto
- El código sea mantenido por múltiples desarrolladores

**Evita Records cuando:**
- Solo necesites un par de valores simples (usa tuplas)
- Necesites métodos (usa clases)
- La estructura sea muy dinámica (usa `Map` o `any`)
- El rendimiento sea crítico y tengas millones de instancias

Los records son el **equilibrio perfecto** entre la simplicidad de las tuplas y la expresividad de las clases, especialmente útiles para **modelar datos** en aplicaciones TypeScript.

---
# Enums (Enumerados) en TypeScript

Los **enums** son una forma de definir un **conjunto de constantes nombradas** que representan valores relacionados. Es como crear tu propio "tipo personalizado" con opciones limitadas y específicas.
## ¿Qué son los Enums?

Piensa en los enums como un **menú de opciones fijas**. En lugar de usar strings o números "sueltos", defines un conjunto cerrado de valores posibles.

```typescript
// Sin enum - propenso a errores
const estado = "pendiente"; // ¿Qué pasa si escribes "pendinte"?
const estado2 = "completado";
const estado3 = "cancelado";

// Con enum - valores controlados
enum EstadoPedido {
    Pendiente,
    Procesando, 
    Completado,
    Cancelado
}

const miPedido = EstadoPedido.Pendiente; // Autocompletado y seguridad
```

## Tipos de Enums

### 1. **Enum Numérico (por defecto)**
```typescript
enum Direccion {
    Norte,    // 0
    Sur,      // 1
    Este,     // 2
    Oeste     // 3
}

console.log(Direccion.Norte); // 0
console.log(Direccion[0]);    // "Norte" (acceso reverso)
```

### 2. **Enum con valores personalizados**
```typescript
enum CodigoHTTP {
    OK = 200,
    NotFound = 404,
    ServerError = 500
}

console.log(CodigoHTTP.OK); // 200
```

### 3. **Enum de Strings**
```typescript
enum TipoUsuario {
    Admin = "ADMIN",
    Moderador = "MODERATOR", 
    Usuario = "USER"
}

console.log(TipoUsuario.Admin); // "ADMIN"
```

### 4. **Enum Mixto**
```typescript
enum Respuesta {
    No = 0,
    Si = 1,
    Mensaje = "Talvez más tarde"
}
```

## Casos de uso comunes

### 1. **Estados de aplicación**
```typescript
enum EstadoJuego {
    Menu = "MENU",
    Jugando = "PLAYING",
    Pausado = "PAUSED", 
    GameOver = "GAME_OVER"
}

function manejarJuego(estado: EstadoJuego) {
    switch (estado) {
        case EstadoJuego.Menu:
            console.log("Mostrando menú principal");
            break;
        case EstadoJuego.Jugando:
            console.log("El juego está corriendo");
            break;
        // TypeScript te obliga a manejar todos los casos
    }
}
```

### 2. **Configuraciones**
```typescript
enum NivelLog {
    Debug = 0,
    Info = 1,
    Warning = 2,
    Error = 3
}

function log(msj: string, nivel: NivelLog) {
    if (nivel >= NivelLog.Warning) {
        console.log(`[${Log[nivel].toUpperCase()}]: ${msj}`);
    }
}

log("Sistema iniciado", NivelLog.Info);
log("Archivo no encontrado", NivelLog.Error);
```

### 3. **API y constantes**
```typescript
enum MetodoHTTP {
    GET = "GET",
    POST = "POST", 
    PUT = "PUT",
    DELETE = "DELETE"
}

async function hacerPeticion(url: string, metodo: MetodoHTTP) {
    return fetch(url, { method: metodo });
}

// Uso claro y sin errores de tipeo
hacerPeticion("/api/users", MetodoHTTP.GET);
```

## Enum vs Otras alternativas

### Enum vs Union Types
```typescript
// Union type - más flexible
type Estado = "pendiente" | "completado" | "cancelado";

// Enum - más estructurado
enum EstadoPedido {
    Pendiente = "pendiente",
    Completado = "completado", 
    Cancelado = "cancelado"
}

// Union type permite extensión más fácil
type NuevoEstado = Estado | "enviado";

// Enum requiere modificar la definición original
```

### Enum vs Object as const
```typescript
// Enum tradicional
enum Color {
    Rojo = "red",
    Verde = "green",
    Azul = "blue"
}

// Object as const (alternativa moderna)
const Color = {
    Rojo: "red",
    Verde: "green", 
    Azul: "blue"
} as const;

type Color = typeof Color[keyof typeof Color]; // "red" | "green" | "blue"
```
## ¿Cuándo usar Enums?

**Usa enums cuando:**
- Tengas un **conjunto fijo y conocido** de valores
- Quieras **prevenir errores de tipeo**
- Los valores estén **semánticamente relacionados**
- Necesites **refactoring seguro**

**Evita enums cuando:**
- Los valores puedan **cambiar dinámicamente**
- Necesites máxima **flexibilidad**
- Sea un caso muy simple (mejor usar union types)
- El **bundle size** sea crítico

Los enums son especialmente útiles para **modelar estados, configuraciones y constantes** que forman parte del dominio de tu aplicación, proporcionando seguridad de tipos y mejor experiencia de desarrollo.

---
# Tipos Opcionales y Tipos Exception

## Tipos Opcionales

Los **tipos opcionales** representan valores que **pueden existir o no**. En lugar de usar `null` o `undefined` sueltos (que pueden causar errores), encapsulamos esa "ausencia" en un tipo específico.
### En TypeScript:
```typescript
// Usando union types con undefined/null
function buscarUsuario(id: number): Usuario | undefined {
    // Puede devolver un usuario o undefined
    if (id > 0) {
        return { nombre: "Ana", edad: 25 };
    }
    return undefined; // Explícitamente "no hay resultado"
}

// Uso seguro
const usuario = buscarUsuario(1);
if (usuario) { // Verificación obligatoria
    console.log(usuario.nombre); // Seguro
}
```

## Tipos Exception/Error

Los **tipos exception** encapsulan errores como valores, permitiendo manejarlos de forma **explícita y tipada** en lugar de lanzar excepciones.
## Ejemplo básico con Union Types
```typescript
// En lugar de lanzar excepciones, devolvemos un tipo que puede ser éxito o error
type Exito = { tipo: 'exito', valor: number };
type Error = { tipo: 'error', mensaje: string };

// El tipo exception es simplemente la unión de ambos
type ResultadoDivision = Exito | Error;

function dividir(a: number, b: number): ResultadoDivision {
    if (b === 0) {
        return { tipo: 'error', mensaje: 'División por cero no permitida' };
    }
    
    return { tipo: 'exito', valor: a / b };
}

// Uso - el compilador te obliga a verificar ambos casos
const resultado = dividir(10, 2);

if (resultado.tipo === 'exito') {
    console.log('Resultado:', resultado.valor); // 5
} else {
    console.log('Error:', resultado.mensaje);
}
```

---
# Product Type y Sum Type

Los **Product Types** y **Sum Types** son conceptos fundamentales de los **tipos algebraicos** (algebraic data types) que nos ayudan a **combinar tipos** de maneras diferentes y predecibles.

## Product Types (Tipos Producto)

**Definición:**
Un **Product Type** combina múltiples tipos donde **necesitas TODOS los valores** para formar el tipo completo. Es como una multiplicación: tienes que tener A **Y** B.

### Ejemplos básicos:

```typescript
// Record/Object - es un Product Type
type Persona = {
    nombre: string;  // Necesitas nombre y edad y activo
    edad: number;    // para tener una Persona completa
    activo: boolean;
}

// Tupla - también es un Product Type  
type Coordenada = [number, number]; // NECESITAS x Y y

// Función con múltiples parámetros
function sumar(a: number, b: number): number {
    return a + b; // Necesitas ambos parámetros
}
```

**¿Por qué se llama "Producto"?**
Porque la cantidad de valores posibles es la **multiplicación** de cada tipo:

```typescript
type Semaforo = {
    color: "rojo" | "amarillo" | "verde";  // 3 posibilidades
    encendido: boolean;                     // 2 posibilidades
}
// Total de combinaciones posibles: 3 × 2 = 6 valores diferentes
```

## Sum Types (Tipos Suma)

**Definición:**
Un **Sum Type** representa valores que pueden ser **UNO DE varios tipos**. Es como una suma: puede ser A **O** B, pero no ambos al mismo tiempo.

### Ejemplos básicos:

```typescript
// Union Type - es un Sum Type
type Resultado = "exito" | "error" | "cargando";

// Puede ser string O number, pero no ambos
type ID = string | number;

// Ejemplo más complejo
type Respuesta = 
    | { tipo: "exito", datos: any }
    | { tipo: "error", mensaje: string }
    | { tipo: "cargando" };
```

**¿Por qué se llama "Suma"?**
Porque la cantidad de valores posibles es la **suma** de cada tipo:

```typescript
type Estado = "activo" | "inactivo";     // 2 posibilidades
type Prioridad = "alta" | "media" | "baja"; // 3 posibilidades

type Configuracion = Estado | Prioridad;
// Total de valores posibles: 2 + 3 = 5 valores diferentes
```

## Comparación 

### Product Type - "Necesito TODO"
```typescript
type Usuario = {
    id: number;
    nombre: string;
    email: string;
}

// Para crear un usuario, NECESITO los 3 campos
const usuario: Usuario = {
    id: 1,
    nombre: "Juan",
    email: "juan@email.com"  // Si falta alguno, ¡error!
}
```

### Sum Type - "Puede ser UNO de estos"
```typescript
type EstadoConexion = "conectado" | "desconectado" | "conectando";

// Solo puede ser UNO de estos valores
let estado: EstadoConexion = "conectado";    // Válido
// let estado2: EstadoConexion = "conectado" | "conectando"; // Error
```

## Ejemplo del mundo real: Sistema de pagos

```typescript
// Product Types - necesitas TODOS los datos
type TarjetaCredito = {
    numero: string;
    cvv: string;
    expiracion: string;
    titular: string;
}

type PayPal = {
    email: string;
    contraseña: string;
}

// Sum Type - puede ser UNO de estos métodos
type MetodoPago = TarjetaCredito | PayPal | "efectivo";

// Función que maneja diferentes tipos de pago
function procesarPago(metodo: MetodoPago, monto: number) {
    if (typeof metodo === "string") {
        console.log(`Pago en ${metodo}: $${monto}`);
    } else if ("numero" in metodo) {
        console.log(`Pago con tarjeta terminada en ${metodo.numero.slice(-4)}`);
    } else if ("email" in metodo) {
        console.log(`Pago con PayPal: ${metodo.email}`);
    }
}

// Uso
const pago1: MetodoPago = "efectivo";
const pago2: MetodoPago = {
    numero: "1234-5678-9012-3456",
    cvv: "123",
    expiracion: "12/25",
    titular: "Juan Pérez"
};
```

## ¿Para qué sirven?

**Product Types:**
- **Modelar entidades** con múltiples propiedades
- **Garantizar completitud** de datos
- **Estructuras complejas** y objetos del mundo real

**Sum Types:**
- **Modelar alternativas** mutuamente excluyentes
- **Manejo de errores** de forma tipada
- **Estados de aplicación** que no pueden coexistir

---
### [ Ejercicios](Ejercicios/Composicion%20y%20Tipos%20de%20Datos%20Alg.md)
