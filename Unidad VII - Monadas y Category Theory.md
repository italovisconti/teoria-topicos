> [!NOTE] Referencias
> Riscutia, 2020 - Capítulo 9 y 10

---
## Cap 8: Elementos de la POO (RECAP)

### Interfaces vs. Clases Abstractas

1. La Interfaz como Contrato Puro
Una interfaz es un como un "acuerdo escrito" de qué mensajes (métodos) entiende un objeto, sin dictar cómo procesarlos. No tiene estado (datos).

- **¿Por qué usarlas?** Para desacoplar el "qué" del "cómo".

Piensa en un control remoto universal. La interfaz define botones como "encender", "cambiar canal", "subir volumen", pero no importa si controlas un TV Samsung, LG o Sony. Cada dispositivo implementa estas operaciones de manera diferente internamente, pero todos respetan el mismo contrato.

Imagina que estás diseñando una aplicación que necesita guardar datos. Puedes guardar en:
- Base de datos SQL
- Base de datos NoSQL
- Sistema de archivos
- Nube (AWS, Azure, etc.)

**Sin Interfaz**, cada vez que cambies el medio de almacenamiento, debes modificar todo el código que guarda datos.

Con Interfaz,
- El código que usa el repositorio no cambia si cambias de SQL a MongoDB
- Puedes probar tu aplicación con un `RepositorioEnMemoria` sin tocar bases de datos reales
- Diferentes partes del sistema pueden usar diferentes implementaciones sin conflictos
- **Principio de Inversión de Dependencias**: El código depende de abstracciones, no de implementaciones concretas


2. La Clase Abstracta como Identidad
La **herencia** es un mecanismo que permite crear nuevas clases basadas en clases existentes, heredando sus atributos y métodos. La clase hija **extiende** a la clase padre.

Piensa en biología, los mamíferos heredan características de los vertebrados (columna vertebral, sistema nervioso central), pero agregan características propias (glándulas mamarias, pelo). Los humanos, a su vez, heredan de los mamíferos pero agregan características específicas.

Por ejemplo
- Un `Perro` **ES UN** `Animal`
- Un `Estudiante` **ES UNA** `Persona`

**Ejemplos Inválidos**:
- Un `Auto` **TIENE UN** `Motor` → Esto es **composición**
- Una `Casa` **TIENE** `Habitaciones` → Esto es **composición**

---
### Composición vs Herencia

La **composición** es construir objetos complejos **conteniendo** instancias de otros objetos más simples. En lugar de heredar, el objeto **delega** responsabilidades a sus componentes.

Piensa en una computadora, esta no "hereda" de un procesador. Una computadora **tiene** un procesador, **tiene** memoria RAM, **tiene** un disco duro. Cada componente es independiente y puede ser reemplazado.

 La Regla "HAS-A" (TIENE-UN)

**Ejemplos de Composición** :
- Un `Auto` **TIENE UN** `Motor`
- Una `Casa` **TIENE** `Habitaciones`
- Un `Estudiante` **TIENE UNA** `Dirección`

Ustedes que están viendo Bases de datos, pensar de esta manera puede ser útil.

**Composición vs Herencia: Tabla Comparativa**

| Aspecto | Herencia | Composición |
|---------|----------|-------------|
| **Relación** | "ES-UN" (is-a) | "TIENE-UN" (has-a) |
| **Acoplamiento** | Alto (clase hija depende de padre) | Bajo (objetos independientes) |
| **Flexibilidad** | Baja (jerarquía rígida) | Alta (componentes intercambiables) |
| **Reutilización** | Vertical (por herencia) | Horizontal (componentes en diferentes contextos) |
| **Complejidad** | Puede crear jerarquías profundas | Estructura más plana |
| **Cambios** | Difíciles (afectan toda la jerarquía) | Fáciles (cambias componentes) |

### 🧪 Ejemplo Conceptual: Sistema de Vehículos

**Enfoque con Herencia (Problemático):**
```
Vehiculo
├─ VehiculoElectrico
│  ├─ AutoElectrico
│  └─ MotoElectrica
└─ VehiculoCombustion
   ├─ AutoGasolina
   └─ MotoGasolina
```

**Problema**: ¿Qué pasa con un auto híbrido? ¿Hereda de VehiculoElectrico o VehiculoCombustion? La herencia nos fuerza a una categorización rígida.

**Enfoque con Composición (Flexible):**
```
Automovil
├─ tiene → Motor (puede ser: Electrico, Gasolina, Diesel, Hibrido)
├─ tiene → Transmision (puede ser: Manual, Automatica, CVT)
├─ tiene → SistemaAudio
└─ tiene → SistemaSeguiridad
```

**Ventajas**:
1. **Flexibilidad**: Puedes combinar cualquier tipo de motor con cualquier transmisión
2. **Reutilización**: El mismo `Motor` puede usarse en `Automovil`, `Motocicleta`, `Camion`
3. **Evolución**: Agregar un nuevo tipo de motor no requiere cambiar la jerarquía
4. **Delegación**: `Automovil.arrancar()` delega a `Motor.encender()`

Aquí entra un principio: **"Favorece la composición sobre la herencia"**

### Patrón Adapter: Composición en Acción

El **patrón Adapter** (adaptador) convierte la interfaz de una clase en otra interfaz que los clientes esperan. Permite que clases con interfaces incompatibles trabajen juntas.

Piensa en un adaptador de corriente cuando viajas. Si tu cargador tiene enchufe americano (2 pines planos) pero estás en Europa (2 pines redondos), necesitas un adaptador que:
- Tiene la interfaz que tu cargador espera (pines planos)
- Se conecta a la interfaz disponible (enchufe europeo)

La estructura del Adapter se ve asi:

```
Cliente → espera → [Interfaz Target]
                         ↑
                         |
                    [Adapter] → contiene → [Clase Adaptada]
```

**Componentes:**
1. **Target**: La interfaz que el cliente espera
2. **Adaptee**: La clase existente con interfaz incompatible  
3. **Adapter**: Implementa Target y contiene una instancia de Adaptee
4. **Cliente**: Usa Target sin saber que hay un Adapter

Un escenario es cuando estamos integrando una **API Legacy**

**Problema**: Tu empresa tiene un sistema antiguo de pagos con esta interfaz:
```
SistemaPagosLegacy
├─ procesarPagoTarjeta(numeroTarjeta, monto, comercio)
├─ verificarSaldo(numeroTarjeta)
└─ generarReciboTXT(transaccionId)
```

Pero tu nueva aplicación espera esta interfaz moderna:
```
ProcesadorPagos
├─ procesarPago(datosPago: PaymentData)
├─ consultarEstado(idTransaccion: string)
└─ generarRecibo(idTransaccion: string, formato: Format)
```

**Solución con Adapter**:
```
AdapterPagosLegacy implements ProcesadorPagos
├─ contiene → sistemaPagosLegacy: SistemaPagosLegacy
├─ procesarPago() → traduce y llama a procesarPagoTarjeta()
├─ consultarEstado() → traduce y llama a verificarSaldo()
└─ generarRecibo() → traduce y llama a generarReciboTXT()
```

**Beneficios:**
1. **No modificas el código legacy** (puede ser riesgoso o imposible)
2. **El código nuevo usa una interfaz limpia**
3. **Puedes reemplazar el sistema legacy gradualmente**

El Adapter usa **composición** 
### Mix-ins: Extendiendo sin Herencia Múltiple

Los **mix-ins** son una técnica para agregar funcionalidad a clases sin usar herencia múltiple (que muchos lenguajes no soportan). Permiten "mezclar" comportamiento de múltiples fuentes.

Piensa en los ingredientes de una pizza. La base (clase) es la masa. Los mix-ins son los toppings que agregas: queso, pepperoni, champiñones. Puedes mezclar los que quieras para crear tu pizza personalizada.

**Problema con Herencia Múltiple**:
```
¿Cómo hacer que Usuario tenga capacidades de:
- Logging
- Serialización
- Validación
- Cache
... sin crear una jerarquía compleja?
```

**Herencia Simple**:
```
Usuario → UsuarioConLogging → UsuarioConSerializacion → ...
```

**Mix-ins**:
```
Usuario + Logging + Serialization + Validation = UsuarioCompleto
```

**Con Mix-ins** ✅:
```
Usuario = ClaseBase + Logging + Persistencia + Validacion + Timestamps
Producto = ClaseBase + Persistencia + Validacion + Timestamps
Pedido = ClaseBase + Logging + Persistencia + Timestamps
```

Cada clase obtiene **solo** las capacidades que necesita.
```typescript
// Mix-in de Logging (simplificado)
function withLogging(BaseClass) {
    return class extends BaseClass {
        log(mensaje) { /* implementación */ }
    }
}

// Aplicación
class Usuario { /* ... */ }
const UsuarioConLogging = withLogging(Usuario);
```

**Lo que sucede:**
1. `withLogging` recibe una clase
2. Retorna una **nueva clase** que extiende la original
3. La nueva clase tiene los métodos originales + `log()`

El buen diseño orientado a objetos no se trata de usar todas las técnicas, sino de elegir las correctas para cada problema. **Simplicidad primero, sofisticación solo cuando sea necesaria.**

**Ejercicio: Detectar Problemas de Diseño**

Analiza este diseño y encuentra los problemas:

```ts
class Animal {
    nombre: string
    volar(): void
    nadar(): void
    caminar(): void
}

class Perro extends Animal {
    // Problema: Los perros no vuelan
}

class Pez extends Animal {
    // Problema: Los peces no caminan ni vuelan
}

class Ave extends Animal {
    // Algunos pueden nadar, otros no
}
```

Mejor diseño
```ts
interface Volador {
    volar(): void
}
interface Nadador {
    nadar(): void
}
interface Caminador {
    caminar(): void
}

class Animal {
    nombre: string
}

class Perro extends Animal implements Caminador, Nadador {
    caminar() { /* ... */ }
    nadar() { /* ... */ }
}
class Pez extends Animal implements Nadador {
    nadar() { /* ... */ }
}
class Pato extends Animal implements Volador, Nadador, Caminador {
    volar() { /* ... */ }
    nadar() { /* ... */ }
    caminar() { /* ... */ }
}
```

## Cap 9 y 10

# Programación Genérica - Estructuras y Algoritmos

## Estructuras de Datos Genéricas

Sin genéricos, necesitamos crear estructuras diferentes para cada tipo:

```typescript
class ListaNumeros {
    private items: number[] = [];
    agregar(item: number) { this.items.push(item); }
    obtener(index: number): number { return this.items[index]; }
}

class ListaStrings {
    private items: string[] = [];
    agregar(item: string) { this.items.push(item); }
    obtener(index: number): string { return this.items[index]; }
}
```

### La Solución Genérica

```typescript
class Lista<T> {
    private items: T[] = [];
    
    agregar(item: T): void {
        this.items.push(item);
    }
    
    obtener(index: number): T {
        return this.items[index];
    }
    
    obtenerTodos(): T[] {
        return this.items;
    }
}
```

### 📊 Tipos Genéricos Comunes

```typescript
// Par genérico
class Par<T, U> {
    constructor(
        public primero: T,
        public segundo: U
    ) {}
}

const coordenada = new Par<number, number>(10, 20);
const registro = new Par<string, number>("edad", 25);

// Opcional genérico
type Opcional<T> = T | undefined;

let valor: Opcional<number> = 42;
valor = undefined; // También válido
```

---

## 3. Iteradores: Recorriendo Estructuras

### 🎯 ¿Por Qué Print Imprime Todo?

**Pregunta para reflexión**: ¿Por qué `console.log()` puede imprimir arrays, objetos, Maps, Sets, etc.?

**Respuesta**: Porque todas estas estructuras son **iterables**.

En TypeScript/JavaScript, un **iterable** es cualquier objeto que implementa el método `[Symbol.iterator]()`.

```typescript
class Rango {
    constructor(
        private inicio: number,
        private fin: number
    ) {}
    
    // Hace que la clase sea iterable
    *[Symbol.iterator]() {
        for (let i = this.inicio; i <= this.fin; i++) {
            yield i;
        }
    }
}
// Uso
const rango = new Rango(1, 5);
for (const num of rango) {
    console.log(num); // 1, 2, 3, 4, 5
}
```

### ¿Qué es `yield`?

`yield` es como un **botón de "Pausa y Entrega"**:

1. **Pausa la ejecución**: La función se congela en esa línea
2. **Entrega un valor**: Le da el valor actual al llamador
3. **Mantiene el estado**: Recuerda dónde quedó para continuar después
4. **Espera**: No continúa hasta que se pida el siguiente valor


**Ejemplo práctico:**
```typescript
// Generador de números infinitos
function* numerosPares(): IterableIterator<number> {
    let n = 0;
    while (true) {
        yield n;
        n += 2;
    }
}

const gen = numerosPares();
console.log(gen.next().value); // 0
console.log(gen.next().value); // 2
console.log(gen.next().value); // 4
```

---

## 5. Restricciones de Tipos (Type Constraints)

### El Problema

A veces necesitamos que `T` no sea **cualquier** tipo, sino que cumpla ciertos requisitos.

**Ejemplo**: Queremos una función que compare dos elementos:

```typescript
// No sabemos si T tiene el operador <
function minimo<T>(a: T, b: T): T {
    return a < b ? a : b; // Error de compilación
}
```

### Solución: Restricciones con `extends`

```typescript
interface Comparable {
    compareTo(other: this): number;
}

function minimo<T extends Comparable>(a: T, b: T): T {
    return a.compareTo(b) < 0 ? a : b;
}
```

#### Restricción: Múltiples interfaces

```typescript
interface Identificable {
    id: number;
}
interface Nombrable {
    nombre: string;
}

// T debe implementar AMBAS interfaces
function registrar<T extends Identificable & Nombrable>(obj: T): void {
    console.log(`Registrando: ${obj.id} - ${obj.nombre}`);
}
```

#### Restricción: Tipos primitivos

```typescript
// Solo acepta number o string
function procesar<T extends number | string>(valor: T): void {
    console.log(`Procesando: ${valor}`);
}

procesar(42);        // OK
procesar("hola");    // OK
procesar(true);      // Error: boolean no es number ni string
```

---

## Patrón de Diseño Iterator

El **patrón Iterator** es un patrón de diseño de comportamiento que proporciona una forma de acceder secuencialmente a los elementos de una colección sin exponer su representación interna.

Te permite recorrer una colección (lista, árbol, grafo, etc.) sin necesitar saber cómo está implementada internamente.

### Diagrama del Patrón

```
┌─────────────────┐
│    Cliente      │
└────────┬────────┘
         │ usa
         ↓
┌─────────────────┐         ┌──────────────────┐
│   Iterator      │◄────────│   Aggregate      │
├─────────────────┤         ├──────────────────┤
│ + next()        │         │ + createIterator()│
│ + hasNext()     │         └──────────────────┘
│ + current()     │                  △
└─────────────────┘                  │
         △                           │
         │                           │
┌────────┴────────┐         ┌───────┴──────────┐
│ ConcreteIterator│◄────────│ ConcreteAggregate│
├─────────────────┤         ├──────────────────┤
│ - collection    │         │ - items[]        │
│ - position      │         │ + createIterator()│
└─────────────────┘         └──────────────────┘
```

**Componentes:**

1. **Iterator**: Interfaz que define operaciones para recorrer elementos
2. **ConcreteIterator**: Implementación específica del iterador
3. **Aggregate**: Interfaz de la colección que crea iteradores
4. **ConcreteAggregate**: Colección concreta que retorna su iterador

**Sistema de Playlists**

**Escenario**: Imagina una aplicación de música como Spotify que maneja diferentes tipos de playlists:

#### El Problema
Tienes tres tipos de playlists:
1. **Playlist Lineal**: Canciones en orden secuencial (1, 2, 3, 4...)
2. **Playlist Aleatoria**: Canciones en orden aleatorio shuffle
3. **Playlist por Género**: Agrupa canciones por categoría, luego reproduce

**Sin el Patrón Iterator**:
El reproductor necesitaría tener código específico para cada tipo:
```
Si es PlaylistLineal:
    reproducir en orden
Si es PlaylistAleatoria:
    generar orden aleatorio, luego reproducir
Si es PlaylistPorGenero:
    buscar canciones del género, luego reproducir
```
❌ El reproductor está **acoplado** a cada implementación de playlist

**Con el Patrón Iterator**:
El reproductor simplemente pide "siguiente canción" sin importar el tipo:
```
Mientras haya canciones:
    Dame la siguiente canción
    Reproducir
```
✅ El reproductor está **desacoplado** - no necesita saber cómo está organizada la playlist

#### Diagrama del Flujo

```
                    ┌─────────────────┐
                    │   Reproductor   │
                    │  (Cliente)      │
                    └────────┬────────┘
                             │
                             │ "Dame la siguiente canción"
                             ↓
                    ┌─────────────────┐
                    │ Iterator        │
                    │ Interface       │
                    │ - next()        │
                    │ - hasNext()     │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              ↓              ↓              ↓
    ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
    │ Iterador    │  │ Iterador    │  │ Iterador    │
    │ Lineal      │  │ Aleatorio   │  │ Por Género  │
    └──────┬──────┘  └──────┬──────┘  └──────┬──────┘
           │                │                │
           ↓                ↓                ↓
    ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
    │ Playlist    │  │ Playlist    │  │ Playlist    │
    │ Lineal      │  │ Aleatoria   │  │ Por Género  │
    │ [1,2,3,4,5] │  │ [3,1,5,2,4] │  │ {Rock:[...]}│
    └─────────────┘  └─────────────┘  └─────────────┘
```

#### Cómo Funciona

**Paso 1**: Cada playlist crea su propio iterador especializado:
- `PlaylistLineal` → crea `IteradorLineal` (recorre posición 0, 1, 2...)
- `PlaylistAleatoria` → crea `IteradorAleatorio` (recorre índices mezclados)
- `PlaylistPorGenero` → crea `IteradorPorGenero` (recorre por categoría)

**Paso 2**: El reproductor recibe el iterador y usa la misma interfaz para todos:
```
iterator.hasNext() → ¿Hay más canciones?
iterator.next()    → Dame la siguiente
```

**Paso 3**: Cada iterador sabe internamente cómo obtener "la siguiente":
- **Lineal**: Incrementa posición (pos++)
- **Aleatorio**: Toma siguiente de lista pre-mezclada
- **Por Género**: Salta al siguiente género cuando termina uno

---
## Mónadas

Una **mónada** es un patrón de diseño de la programación funcional que te permite **encadenar operaciones** sobre valores envueltos (wrapped values) de manera segura y componible.

**Analogía del Mundo Real**: Piensa en una **línea de ensamblaje en una fábrica**:
- Cada estación (operación) recibe un producto parcial
- Transforma el producto
- Lo pasa a la siguiente estación
- Si algo falla en alguna estación, la línea se detiene sin intentar operaciones inválidas

### 📐 Los Tres Componentes de una Mónada

Una mónada debe tener tres cosas:

| Componente | Operación | Descripción | Ejemplo en TypeScript |
|------------|-----------|-------------|-----------------------|
| **1. Contenedor (Wrapper Type)** | - | Tipo que envuelve un valor | `Maybe<T>`, `Promise<T>`, `Array<T>` |
| **2. Constructor (Unit/Return)** | `of()` o `return()` | Mete un valor dentro del contenedor | `Maybe.of(5)` → `Maybe<number>` |
| **3. Encadenador (Bind/FlatMap)** | `flatMap()` o `bind()` | Aplica una función y aplana el resultado | `maybe.flatMap(x => Maybe.of(x * 2))` |

### 🧪 El Problema que Resuelven las Mónadas

#### Escenario: Búsqueda de Usuario en Base de Datos

Imagina que necesitas:
1. Buscar un usuario por ID
2. Obtener su dirección
3. Obtener su código postal

Cada operación puede **fallar** (usuario no existe, dirección no registrada, etc.)

**Sin Mónadas (Código Imperativo con `null`):**

```typescript
function obtenerCodigoPostal(userId: number): string | null {
    const usuario = buscarUsuario(userId);
    if (usuario === null) {
        return null;
    }
    
    const direccion = obtenerDireccion(usuario);
    if (direccion === null) {
        return null;
    }
    
    const codigoPostal = obtenerCodigoPostal(direccion);
    if (codigoPostal === null) {
        return null;
    }
    
    return codigoPostal;
}
```

❌ **Problemas:**
- Mucho código repetitivo (`if (... === null)`)
- Difícil de leer y mantener
- Fácil olvidar un chequeo

**Con Mónadas (Maybe):**

```typescript
function obtenerCodigoPostalMonadico(userId: number): Maybe<string> {
    return buscarUsuario(userId)
        .flatMap(usuario => obtenerDireccion(usuario))
        .flatMap(direccion => obtenerCodigoPostal(direccion));
}
```

✅ **Beneficios:**
- Código declarativo y limpio
- El manejo de errores está implícito
- Composición de operaciones clara

### 📦 Implementación de la Mónada `Maybe`

La mónada `Maybe` (también llamada `Optional`) representa un valor que puede existir o no.

```typescript
// Definición de Maybe
abstract class Maybe<T> {
    // Constructor: Envuelve un valor
    static of<T>(value: T): Maybe<T> {
        return value === null || value === undefined
            ? new Nothing<T>()
            : new Just<T>(value);
    }
    
    // Bind/FlatMap: Encadena operaciones
    abstract flatMap<U>(fn: (value: T) => Maybe<U>): Maybe<U>;
    
    // Helpers
    abstract getOrElse(defaultValue: T): T;
    abstract isNothing(): boolean;
}

// Caso: Hay un valor
class Just<T> extends Maybe<T> {
    constructor(private value: T) {
        super();
    }
    
    flatMap<U>(fn: (value: T) => Maybe<U>): Maybe<U> {
        return fn(this.value);
    }
    
    getOrElse(defaultValue: T): T {
        return this.value;
    }
    
    isNothing(): boolean {
        return false;
    }
}

// Caso: No hay valor
class Nothing<T> extends Maybe<T> {
    flatMap<U>(fn: (value: T) => Maybe<U>): Maybe<U> {
        return new Nothing<U>();
    }
    
    getOrElse(defaultValue: T): T {
        return defaultValue;
    }
    
    isNothing(): boolean {
        return true;
    }
}
```

### 🔗 Ejemplo Completo: Sistema de Usuarios

```typescript
interface Usuario {
    id: number;
    nombre: string;
    direccionId?: number;
}

interface Direccion {
    id: number;
    calle: string;
    codigoPostal?: string;
}

// Funciones que retornan Maybe
function buscarUsuario(id: number): Maybe<Usuario> {
    const usuarios: Usuario[] = [
        { id: 1, nombre: "Ana", direccionId: 10 },
        { id: 2, nombre: "Luis" } // Sin direccionId
    ];
    const usuario = usuarios.find(u => u.id === id);
    return Maybe.of(usuario);
}

function buscarDireccion(direccionId: number): Maybe<Direccion> {
    const direcciones: Direccion[] = [
        { id: 10, calle: "Av. Principal", codigoPostal: "1234" },
        { id: 11, calle: "Calle Secundaria" } // Sin codigoPostal
    ];
    const direccion = direcciones.find(d => d.id === direccionId);
    return Maybe.of(direccion);
}

// Composición con flatMap
function obtenerCodigoPostalDeUsuario(userId: number): string {
    return buscarUsuario(userId)
        .flatMap(usuario => 
            Maybe.of(usuario.direccionId)
        )
        .flatMap(direccionId => 
            buscarDireccion(direccionId)
        )
        .flatMap(direccion => 
            Maybe.of(direccion.codigoPostal)
        )
        .getOrElse("Código postal no disponible");
}

// Uso
console.log(obtenerCodigoPostalDeUsuario(1)); // "1234"
console.log(obtenerCodigoPostalDeUsuario(2)); // "Código postal no disponible"
console.log(obtenerCodigoPostalDeUsuario(999)); // "Código postal no disponible"
```

### ⚡ Otras Mónadas Comunes

#### 1. Mónada `Promise` (Async)

`Promise` es una mónada para operaciones asíncronas:

```typescript
// Constructor: Promise.resolve()
const promesa = Promise.resolve(42);

// FlatMap: .then() con retorno de Promise
fetch('/api/usuario/1')
    .then(response => response.json()) // flatMap
    .then(usuario => fetch(`/api/direccion/${usuario.direccionId}`)) // flatMap
    .then(response => response.json())
    .then(direccion => console.log(direccion.codigoPostal));
```

#### 2. Mónada `Array` (Listas)

`Array` es una mónada para operaciones sobre colecciones:

```typescript
// Constructor: Array.of() o [valor]
const arr = [1, 2, 3];

// FlatMap: .flatMap()
const resultado = [1, 2, 3]
    .flatMap(x => [x, x * 2]) // [1, 2, 2, 4, 3, 6]
    .flatMap(x => x > 3 ? [x] : []); // [4, 6]

console.log(resultado); // [4, 6]
```

#### 3. Mónada `Either` (Manejo de Errores)

`Either` representa un valor que puede ser **éxito (Right)** o **error (Left)**:

```typescript
abstract class Either<L, R> {
    static left<L, R>(value: L): Either<L, R> {
        return new Left<L, R>(value);
    }
    
    static right<L, R>(value: R): Either<L, R> {
        return new Right<L, R>(value);
    }
    
    abstract flatMap<U>(fn: (value: R) => Either<L, U>): Either<L, U>;
}

class Left<L, R> extends Either<L, R> {
    constructor(private value: L) { super(); }
    
    flatMap<U>(fn: (value: R) => Either<L, U>): Either<L, U> {
        return new Left<L, U>(this.value);
    }
}

class Right<L, R> extends Either<L, R> {
    constructor(private value: R) { super(); }
    
    flatMap<U>(fn: (value: R) => Either<L, U>): Either<L, U> {
        return fn(this.value);
    }
}

// Uso: División segura
function dividir(a: number, b: number): Either<string, number> {
    return b === 0
        ? Either.left("Error: División por cero")
        : Either.right(a / b);
}

const resultado = dividir(10, 2)
    .flatMap(x => dividir(x, 0)) // Error aquí
    .flatMap(x => dividir(x, 2)); // No se ejecuta

// Resultado contiene Left("Error: División por cero")
```

### 📊 Tabla Comparativa de Mónadas

| Mónada | Propósito | Constructor | FlatMap | Uso Común |
|--------|-----------|-------------|---------|-----------|
| **Maybe/Optional** | Valores opcionales | `Maybe.of()` | `.flatMap()` | Búsquedas, datos faltantes |
| **Either** | Manejo de errores | `Either.left()` / `.right()` | `.flatMap()` | Validación, operaciones fallibles |
| **Promise** | Operaciones async | `Promise.resolve()` | `.then()` | APIs, I/O, timeouts |
| **Array** | Colecciones | `[...]` | `.flatMap()` | Transformaciones, filtros |

### 🧬 Leyes de las Mónadas

Para que un tipo sea una mónada válida, debe cumplir tres leyes:

#### 1. **Ley de Identidad Izquierda**
```typescript
// of(a).flatMap(f) === f(a)
Maybe.of(5).flatMap(x => Maybe.of(x * 2))
===
Maybe.of(5 * 2)
```

#### 2. **Ley de Identidad Derecha**
```typescript
// m.flatMap(of) === m
const m = Maybe.of(5);
m.flatMap(x => Maybe.of(x))
===
m
```

#### 3. **Ley de Asociatividad**
```typescript
// m.flatMap(f).flatMap(g) === m.flatMap(x => f(x).flatMap(g))
const m = Maybe.of(5);
const f = (x: number) => Maybe.of(x * 2);
const g = (x: number) => Maybe.of(x + 1);

m.flatMap(f).flatMap(g)
===
m.flatMap(x => f(x).flatMap(g))
```

### 💡 ¿Por Qué Son Importantes las Mónadas?

| Problema | Solución con Mónadas |
|----------|---------------------|
| **Null checks repetitivos** | `Maybe` maneja la ausencia implícitamente |
| **Manejo de errores verboso** | `Either` propaga errores automáticamente |
| **Callbacks anidados (callback hell)** | `Promise` aplana la estructura |
| **Transformaciones de listas complejas** | `Array.flatMap()` simplifica |
| **Composición difícil** | `flatMap` permite encadenar operaciones |

**Implementa una mónada `Result<T>` para manejo de excepciones**:

```typescript
// TODO: Implementar Result<T>
abstract class Result<T> {
    static success<T>(value: T): Result<T> {
        // Tu código aquí
    }
    
    static failure<T>(error: Error): Result<T> {
        // Tu código aquí
    }
    
    abstract flatMap<U>(fn: (value: T) => Result<U>): Result<U>;
    abstract getOrElse(defaultValue: T): T;
}

// Caso de uso: Parseo de JSON
function parsearJSON(texto: string): Result<any> {
    try {
        return Result.success(JSON.parse(texto));
    } catch (error) {
        return Result.failure(error as Error);
    }
}

function obtenerNombre(json: any): Result<string> {
    return json.nombre 
        ? Result.success(json.nombre)
        : Result.failure(new Error("Campo 'nombre' no encontrado"));
}

// Composición
const resultado = parsearJSON('{"nombre": "Ana"}')
    .flatMap(json => obtenerNombre(json))
    .getOrElse("Nombre desconocido");

console.log(resultado); // "Ana"
```

<details>
<summary>💡 Ver solución</summary>

```typescript
abstract class Result<T> {
    static success<T>(value: T): Result<T> {
        return new Success<T>(value);
    }
    
    static failure<T>(error: Error): Result<T> {
        return new Failure<T>(error);
    }
    
    abstract flatMap<U>(fn: (value: T) => Result<U>): Result<U>;
    abstract getOrElse(defaultValue: T): T;
}

class Success<T> extends Result<T> {
    constructor(private value: T) {
        super();
    }
    
    flatMap<U>(fn: (value: T) => Result<U>): Result<U> {
        try {
            return fn(this.value);
        } catch (error) {
            return Result.failure(error as Error);
        }
    }
    
    getOrElse(defaultValue: T): T {
        return this.value;
    }
}

class Failure<T> extends Result<T> {
    constructor(private error: Error) {
        super();
    }
    
    flatMap<U>(fn: (value: T) => Result<U>): Result<U> {
        return new Failure<U>(this.error);
    }
    
    getOrElse(defaultValue: T): T {
        console.error("Error:", this.error.message);
        return defaultValue;
    }
}
```

**Explicación:**
1. **`Success`**: Contiene un valor válido, ejecuta `fn` en `flatMap`
2. **`Failure`**: Contiene un error, propaga el error sin ejecutar `fn`
3. **Try-catch en `flatMap`**: Captura excepciones durante la ejecución de `fn`
4. **`getOrElse`**: Extrae el valor o retorna un default si hay error

</details>

### 📚 Resumen Ejecutivo

> [!TIP] Puntos Clave
> - **Mónada = Contenedor + Constructor + FlatMap**
> - **Propósito**: Encadenar operaciones sobre valores envueltos sin boilerplate
> - **Ejemplos comunes**: `Maybe`, `Either`, `Promise`, `Array`
> - **Beneficio principal**: Código más limpio, componible y seguro
> - **Ya las usas**: `Promise.then()`, `Array.flatMap()` son mónadas

**Mónadas en una frase**: Una forma estándar de encadenar operaciones que pueden fallar, ser asíncronas, o tener múltiples valores.

---
