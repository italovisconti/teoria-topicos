> [!NOTE] Grabaciones de clase — 24 de noviembre de 2026
> - [Programación asíncrona — parte 1](https://drive.google.com/file/d/174pxu-hQiWS1NwraG05JQWTe288rn2sb/view?usp=drive_link)
> - [Programación asíncrona — parte 2](https://drive.google.com/file/d/1BdU6V7ry2NwER83xQQyOSH_Y7UKYnbbV/view?usp=sharing)

> [!NOTE] Referencias
> Riscutia, 2020 - Capítulo 6
> Jansen, 2019 - Capítulo 3
> Mozilla MDN - [How to use promises](https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Async_JS/Promises)

---

Usar el [TS Playground](https://www.typescriptlang.org/play/)

---

## Programación Asíncrona

La programación asíncrona es un método que permite a un programa **iniciar una tarea que podría tardar mucho** (como pedir datos a una API o consultar una base de datos) y, en lugar de quedarse esperando la respuesta, **seguir adelante con otras tareas**.

Esto contrasta directamente con la **programación síncrona**, donde todo funciona como una fila única: no puedes empezar la Tarea B hasta que la Tarea A haya terminado. Si la Tarea A es lenta (como una consulta de red), todo el programa se "congela" esperando.

Imaginemos una llamada a una API, algo que ustedes ya han manejado en Programación Web. Esa petición tiene que viajar por internet, quizás consultar una base de datos, procesar los datos y luego volver.

Para nosotros, eso puede ser solo un segundo. Pero para el procesador de una computadora, **un segundo es una eternidad**. Es como si a ustedes les pidieran esperar un año en una fila sin hacer nada más.

Aquí es donde brilla la programación asíncrona. Nos permite decirle al programa: "Ok, ve a buscar esos datos, y **avísame cuando llegues**. Mientras tanto, yo sigo dibujando la interfaz de usuario y respondiendo a los clics del usuario".

#### ¿Por qué necesitamos esto?

Hay tres razones principales para incorporar la programación asíncrona en sus proyectos:

1.  **Mejor Rendimiento (General)**
	* Ojo, esto es clave: una tarea asíncrona **no se ejecuta más rápido** por sí sola. La petición a la API va a tardar lo mismo. La ganancia está en que la aplicación puede hacer **más cosas en el mismo periodo de tiempo**. Al no esperar, mejoramos el rendimiento general (*throughput*) de todo el sistema.

2.  **Mejor Uso de los Recursos**
	* Esto se conecta con lo que ven en Sistemas Operativos. La programación asíncrona utiliza operaciones "no bloqueantes". Esto asegura que su CPU no esté "de brazos cruzados" simplemente esperando que la red o la base de datos respondan. En lugar de estar ocioso, el procesador puede dedicarse a otras tareas, aprovechando al máximo su capacidad.

3.  **Mejor Experiencia de Usuario (UX)**
	* A nadie le gusta mirar un ícono de "cargando" que no desaparece. La programación asíncrona es la base de una experiencia de usuario fluida y receptiva. Permite que el usuario siga interactuando con la aplicación (como hacer scroll o llenar un formulario) mientras las tareas pesadas se manejan "tras bastidores".

---

#### **1. El Problema: Código Bloqueante**

**Experimentemos primero:**

```typescript
// 🧪 EXPERIMENTO 1: Ejecuta esto en la consola
console.log("1. Inicio");

const endTime = Date.now() + 3000; // 3 segundos después
while (Date.now() < endTime) {
  // Esperando... (bloqueando el programa)
}

console.log("2. Después de 3 segundos");
console.log("3. Fin");
```

**¿Qué observas?**
- El navegador se congela
- No puedes hacer clic en nada
- La interfaz no responde

*"¿Qué pasaría si esto fuera una aplicación real y estuvieras descargando una imagen de 10MB?"*

---

#### **2. La Solución: Callbacks**

```typescript
// 🧪 EXPERIMENTO 2: Ejecuta esto
console.log("1. Inicio");

setTimeout(() => {
  console.log("2. Esto aparece después de 3 segundos");
}, 3000);

console.log("3. Fin (¡pero aparece primero!)");

// Output:
// 1. Inicio
// 3. Fin (¡pero aparece primero!)
// 2. Esto aparece después de 3 segundos
```

**Observaciones:**
- El código no se bloquea
- `console.log("3. Fin")` se ejecuta inmediatamente
- El navegador sigue respondiendo

<img src="assets/Unidad%20VI%20-%20Programacion%20asincrona/sincrono-vs-asincrono.gif" width="900" alt="Comparación en línea de tiempo entre ejecución síncrona bloqueante, que congela la interfaz, y ejecución asíncrona no bloqueante, que delega la espera y mantiene la interfaz fluida.">


#### Pero... ¿Qué es un callback?

Son funciones que son llamadas o invocadas al terminar la ejecución de alguna otra función o tarea. Pero no interrumpen el proceso. 

Se usan como parámetros de funciones que se ejecutan en segundo plano. O mejor dicho, parámetros de funciones que sabes que se ejecutarán pero no sabes exactamente cuándo.

En el ejemplo tenemos un callback en el método setTimeout(), ese callback se ejecuta cuando finaliza el conteo de tiempo de setTimeout(), que se ejecuta en segundo plano.

Otro caso habitual son los eventos. Las funciones que se asignan como manejadores de eventos son funciones callback, que se ejecutan cuando se produce un evento. La espera del evento es una tarea que se está ejecutando en segundo plano. (De esto se trata también la programación reactiva)

Un ejemplo más sencillo es que si pedido() y entrega() son dos funciones asíncronas y no se manejan bien, entrega puede ocurrir primero que pedido (no es lo que queremos).

FOTO

**Pero los callbacks tienen un problema...**

```typescript
// Callback Hell - El código crece hacia la derecha
setTimeout(() => {
  console.log("Paso 1");
  setTimeout(() => {
    console.log("Paso 2");
    setTimeout(() => {
      console.log("Paso 3");
      setTimeout(() => {
        console.log("Paso 4 - ¡Esto es difícil de leer!");
      }, 1000);
    }, 1000);
  }, 1000);
}, 1000);
```

---

#### **3. Promesas: La Solución Moderna**

> [!IMPORTANT]
> **Lectura recomendada:** es muy importante revisar la documentación oficial de [Promise en MDN](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Promise) para profundizar en sus estados, el encadenamiento con `.then()` / `.catch()` y todos sus métodos combinadores.

##### **3.1 Usando fetch() - Tu Primera Promesa Real**

**🧪 EXPERIMENTO 3: Ejecuta esto en la consola**

```typescript
const fetchPromise = fetch(
  "https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/products.json"
);

console.log(fetchPromise);

fetchPromise.then((response) => {
  console.log(`Respuesta recibida: ${response.status}`);
});

console.log("Solicitud iniciada...");
```

**Output esperado:**
```
Promise { <state>: "pending" }
Solicitud iniciada...
Respuesta recibida: 200
```

**Paso a paso:**

1. **`fetch()`** retorna una **Promesa** inmediatamente
2. La promesa está en estado `"pending"` (pendiente)
3. `"Solicitud iniciada..."` se imprime ANTES de recibir la respuesta
4. Cuando la respuesta llega, se ejecuta el callback de `.then()`

**¿Qué es una Promesa?**

> Una **Promesa** es un objeto que representa el resultado **eventual** de una operación asíncrona.

**Estados de una Promesa:**

```typescript
// Estado 1: PENDING (pendiente)
const promise = fetch("https://api.example.com/data");
console.log(promise); // Promise { <state>: "pending" }

// Estado 2: FULFILLED (cumplida) - cuando tiene éxito
promise.then(response => {
  console.log("✅ Promesa cumplida!");
});

// Estado 3: REJECTED (rechazada) - cuando falla
promise.catch(error => {
  console.log("❌ Promesa rechazada!");
});
```

##### **3.2 Encadenamiento de Promesas (Chaining)**

**El Problema:**

```typescript
// ❌ MAL: Anidación (parece callback hell)
const fetchPromise = fetch("https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/products.json");

fetchPromise.then((response) => {
  const jsonPromise = response.json();
  jsonPromise.then((data) => {
    console.log(data[0].name);
  });
});
```

**La Solución: Encadenamiento**

```typescript
// ✅ BIEN: Encadenamiento plano
const fetchPromise = fetch(
  "https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/products.json"
);

fetchPromise
  .then((response) => response.json())  // Retorna otra promesa
  .then((data) => {
    console.log(data[0].name); // "baked beans"
  });
```

**¿Por qué funciona?**

> `.then()` retorna una **nueva promesa** que se cumple con el valor que devuelve el callback.

**Versión completa con validación:**

```typescript
// 🧪 EXPERIMENTO 4: Copia esto completo
fetch("https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/products.json")
  .then((response) => {
    if (!response.ok) {
      throw new Error(`HTTP error: ${response.status}`);
    }
    return response.json();
  })
  .then((data) => {
    console.log(`Producto: ${data[0].name}`);
  });
```

##### **3.3 Manejo de Errores con .catch()**

```typescript
// 🧪 EXPERIMENTO 5: URL inválida
fetch("bad-scheme://ejemplo-invalido.com")
  .then((response) => {
    if (!response.ok) {
      throw new Error(`HTTP error: ${response.status}`);
    }
    return response.json();
  })
  .then((data) => {
    console.log(data[0].name);
  })
  .catch((error) => {
    console.error(`❌ Error: ${error}`);
  });
```

**Ventajas del .catch():**

- Un **solo lugar** para manejar todos los errores
- Captura errores de **cualquier** `.then()` anterior
- Similar a `try...catch` pero para promesas

##### **3.4 ¿Cómo funciona por dentro? El Event Loop**

JavaScript es **monohilo** (*single-threaded*): solo puede ejecutar **una instrucción a la vez**. Para no congelar el navegador cuando una operación tarda, el entorno de ejecución (el navegador o Node.js) coordina cuatro piezas. Una forma sencilla de imaginarlo es pensar en un **restaurante de comida rápida con un solo cajero**:

1. **Call Stack (Pila de llamadas) — *El cajero***
	* Es una pila **LIFO** *Last-In, First-Out* donde se ejecuta el código JavaScript línea por línea.
	* Si una función entra en la pila, el cajero no puede atender ninguna otra hasta que termine y salga.

2. **Web APIs (APIs del navegador) — *La cocina***
	* Son tareas que el navegador gestiona en segundo plano (`setTimeout`, `fetch`, eventos del **DOM** *Document Object Model*) *(en Node.js pasa exactamente igual, solo que esa «cocina» la pone el propio servidor en lugar del navegador; más abajo lo vemos con calma)*.
	* Cuando el código llama a `setTimeout` o `fetch`, el Call Stack delega la espera a las Web APIs y pasa de inmediato a la siguiente línea.

3. **Cola de espera — *El mostrador de entregas***
	* Cuando la tarea en segundo plano termina, su callback no interrumpe al Call Stack; espera su turno en la **Cola de espera** hasta que el cajero quede libre.

4. **Event Loop (Bucle de eventos) — *El encargado***
	* Vigila de forma continua si el **Call Stack** está completamente vacío.
	* Cuando queda vacío, toma el siguiente callback de la cola y lo sube al Call Stack para ejecutarlo.

**🧪 EXPERIMENTO 5B: ¿Qué se imprime primero?**

```typescript
console.log("1. Inicio");

setTimeout(() => {
  console.log("2. Luego");
}, 0);

console.log("3. Fin");
```

**Output esperado:**
```text
1. Inicio
3. Fin
2. Luego
```

<img src="assets/Unidad%20VI%20-%20Programacion%20asincrona/event-loop.gif" width="900" alt="Circuito del Event Loop con Call Stack, Web APIs y Cola de espera mostrando por qué un setTimeout de 0 milisegundos se ejecuta después del código síncrono.">

**¿Por qué `"3. Fin"` sale antes que `"2. Luego"`?**

1. `"1. Inicio"` entra al **Call Stack**, se imprime y sale enseguida.
2. `setTimeout(..., 0)` delega el temporizador a las **Web APIs** y deja su callback en la **Cola de espera**.
3. `"3. Fin"` se ejecuta directo en el **Call Stack** mientras el callback espera afuera.
4. Cuando el **Call Stack** queda vacío, el **Event Loop** sube `"2. Luego"` desde la cola y lo ejecuta.

> [!TIP]
> **Prioridad de las Promesas:** en realidad existen dos colas —una fila prioritaria (**Microtask Queue**) para promesas y `await`, y una fila normal (**Task Queue**) para `setTimeout` y eventos—. El Event Loop siempre vacía primero las promesas.

---

#### **4. Combinando Múltiples Promesas**

##### **4.1 Promise.all() - Todas las promesas**

**Escenario:** Necesitas cargar datos de 3 APIs diferentes

```typescript
// 🧪 EXPERIMENTO 6
const fetchPromise1 = fetch(
  "https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/products.json"
);
const fetchPromise2 = fetch(
  "https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/not-found"
);
const fetchPromise3 = fetch(
  "https://mdn.github.io/learning-area/javascript/oojs/json/superheroes.json"
);

Promise.all([fetchPromise1, fetchPromise2, fetchPromise3])
  .then((responses) => {
    for (const response of responses) {
      console.log(`${response.url}: ${response.status}`);
    }
  })
  .catch((error) => {
    console.error(`Error al cargar: ${error}`);
  });
```

**Características de Promise.all():**

- ✅ Ejecuta todas las promesas **en paralelo**
- ✅ Espera a que **todas** se completen
- ❌ Si **una falla**, todo falla (va al `.catch()`)

**Output esperado:**
```
https://.../products.json: 200
https://.../not-found: 404
https://.../superheroes.json: 200
```

##### **4.2 Promise.any() - La primera exitosa**

```typescript
// 🧪 EXPERIMENTO 7
const fetchPromise1 = fetch("https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/products.json");
const fetchPromise2 = fetch("https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/not-found");
const fetchPromise3 = fetch("https://mdn.github.io/learning-area/javascript/oojs/json/superheroes.json");

Promise.any([fetchPromise1, fetchPromise2, fetchPromise3])
  .then((response) => {
    console.log(`Primera en responder: ${response.url}: ${response.status}`);
  })
  .catch((error) => {
    console.error(`Todas fallaron: ${error}`);
  });
```

##### **4.3 Promise.allSettled() - Todas sin fallar en cadena**

Cuando cargas múltiples recursos independientes y **no quieres que un solo fallo descarte las respuestas exitosas**, usa `Promise.allSettled()`:

```typescript
// 🧪 EXPERIMENTO 7B
const resultados = await Promise.allSettled([
  fetch("https://pokeapi.co/api/v2/pokemon/1"),
  fetch("https://pokeapi.co/api/v2/pokemon/no-existe-99999"),
  fetch("https://pokeapi.co/api/v2/pokemon/25")
]);

for (const res of resultados) {
  if (res.status === "fulfilled") {
    console.log("✅ Éxito:", res.value.status);
  } else {
    console.log("❌ Falló:", res.reason);
  }
}
```

**Características de Promise.allSettled():**

- ✅ Espera a que **todas** terminen (éxito o error)
- ✅ **Nunca rechaza** (no salta al `.catch()`)
- ✅ Devuelve el estado individual de cada promesa (`fulfilled` o `rejected`)

**Cuándo usar cada uno:**

| Método | Uso | Cuando se cumple | Cuando falla |
|--------|-----|------------------|--------------|
| `Promise.all()` | Necesitas TODAS las respuestas | Cuando todas tienen éxito | Si UNA falla |
| `Promise.race()` | La más rápida (timeout) | Cuando la primera termina | Cuando la primera falla |
| `Promise.any()` | La primera exitosa | Primera exitosa | Si TODAS fallan |
| `Promise.allSettled()` | Todas, sin importar resultado | Siempre (nunca rechaza) | Nunca |

---

#### **5. Async/Await - Sintaxis Moderna**

##### **5.1 El Problema con las Promesas**

```typescript
// Código con promesas - puede ser confuso
fetch("https://api.example.com/user")
  .then(response => response.json())
  .then(user => fetch(`https://api.example.com/posts/${user.id}`))
  .then(response => response.json())
  .then(posts => console.log(posts))
  .catch(error => console.error(error));
```

##### **5.2 La Solución: async/await**

```typescript
// 🧪 EXPERIMENTO 8
async function fetchProducts() {
  try {
    const response = await fetch(
      "https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/products.json"
    );
    
    if (!response.ok) {
      throw new Error(`HTTP error: ${response.status}`);
    }
    
    const data = await response.json();
    console.log(data[0].name);
  } catch (error) {
    console.error(`Error: ${error}`);
  }
}

fetchProducts();
```

**¿Qué hace `async/await`?**

- `async`: Declara una función asíncrona (siempre retorna una Promesa)
- `await`: **Pausa** la ejecución de esa función hasta que la promesa se resuelva, sin bloquear el resto del programa
- Permite usar `try...catch` normalmente

<img src="assets/Unidad%20VI%20-%20Programacion%20asincrona/event-loop-async.gif" width="900" alt="Recorrido de async/await y fetch en el Event Loop: await pausa la función y libera el Call Stack para que la interfaz siga respondiendo, y el Event Loop la reanuda desde la Microtask Queue cuando llega la respuesta.">

**Comparación visual:**

```typescript
// Con Promesas
fetch(url)
  .then(r => r.json())
  .then(data => console.log(data))
  .catch(err => console.error(err));

// Con async/await (parece código síncrono!)
async function getData() {
  try {
    const response = await fetch(url);
    const data = await response.json();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}
```

##### **5.3 Error Común: await fuera de async**

```typescript
// ❌ ERROR - No puedes usar await fuera de async
const response = await fetch("https://api.example.com/data");
// Error: await is only valid in async functions

// ✅ CORRECTO
async function getData() {
  const response = await fetch("https://api.example.com/data");
  return response.json();
}
```

##### **5.4 Funciones async siempre retornan Promesas**

```typescript
// 🧪 EXPERIMENTO 9
async function fetchProducts() {
  const response = await fetch(
    "https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/products.json"
  );
  const data = await response.json();
  return data; // Esto retorna una PROMESA, no data directamente
}

// ❌ MAL
const result = fetchProducts();
console.log(result[0].name); // Error: result es una Promise

// ✅ BIEN - Opción 1: usar .then()
fetchProducts()
  .then(data => console.log(data[0].name))
  .catch(error => console.error(error));

// ✅ BIEN - Opción 2: usar await (dentro de otra función async)
async function main() {
  const data = await fetchProducts();
  console.log(data[0].name);
}
main();
```

##### **5.5 Await y Paralelismo**

```typescript
// ❌ LENTO: Secuencial (6 segundos total)
async function getSequential() {
  const pokemon1 = await fetch("https://pokeapi.co/api/v2/pokemon/1"); // 2s
  const pokemon2 = await fetch("https://pokeapi.co/api/v2/pokemon/2"); // 2s
  const pokemon3 = await fetch("https://pokeapi.co/api/v2/pokemon/3"); // 2s
  // Total: 6 segundos
}

// ✅ RÁPIDO: Paralelo (2 segundos total)
async function getParallel() {
  const [pokemon1, pokemon2, pokemon3] = await Promise.all([
    fetch("https://pokeapi.co/api/v2/pokemon/1"),
    fetch("https://pokeapi.co/api/v2/pokemon/2"),
    fetch("https://pokeapi.co/api/v2/pokemon/3")
  ]);
  // Total: ~2 segundos (el más lento)
}
```

<img src="assets/Unidad%20VI%20-%20Programacion%20asincrona/secuencial-vs-paralelo.gif" width="900" alt="Comparación temporal entre tres peticiones await secuenciales que tardan 6 segundos y Promise.all en paralelo que completa las mismas tres peticiones en 2 segundos.">

**Regla de oro:**

- Si las operaciones son **independientes** → usa `Promise.all()` + `await`
- Si una operación **depende** de la otra → usa `await` secuencial

##### **5.6 Error Común: usar async dentro de forEach**

`Array.prototype.forEach` no espera las promesas que devuelve su callback: lanza todas las peticiones sin esperar y el código que sigue se ejecuta antes de tiempo.

```typescript
const ids = [1, 4, 7];

// ❌ MAL: forEach ignora las promesas que devuelve el callback
ids.forEach(async (id) => {
  const res = await fetch(`https://pokeapi.co/api/v2/pokemon/${id}`);
  console.log(res.status);
});
console.log("Fin"); // ¡Se imprime ANTES de que lleguen los Pokémon!

// ✅ BIEN (Secuencial): for...of sí respeta await
for (const id of ids) {
  const res = await fetch(`https://pokeapi.co/api/v2/pokemon/${id}`);
  console.log(res.status);
}

// ✅ BIEN (En paralelo): map + Promise.all
const respuestas = await Promise.all(
  ids.map((id) => fetch(`https://pokeapi.co/api/v2/pokemon/${id}`))
);
```

> [!WARNING]
> **Regla práctica:** nunca uses `forEach(async ...)` si necesitas esperar a que terminen las tareas. Usa `for...of` para ir en orden o `Promise.all(arreglo.map(...))` para lanzarlas en paralelo.

---

#### **6. Patrones Avanzados y Mejores Prácticas**

##### **6.1 Timeout para Requests**

```typescript
// 🧪 EXPERIMENTO 10: Implementar timeout
function fetchWithTimeout<T>(url: string, timeout: number = 5000): Promise<T> {
  return Promise.race([
    fetch(url).then(res => res.json()),
    new Promise<T>((_, reject) => 
      setTimeout(() => reject(new Error('Timeout')), timeout)
    )
  ]);
}

// Uso
async function getData() {
  try {
    const data = await fetchWithTimeout('/api/slow', 3000);
    console.log(data);
  } catch (error) {
    console.log('Request demasiado lento o falló');
  }
}
```

##### **6.2 Retry con Exponential Backoff**

```typescript
async function fetchWithRetry(
  url: string,
  maxRetries: number = 3
): Promise<Response> {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const response = await fetch(url);
      if (response.ok) return response;
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      
      // Espera exponencial: 1s, 2s, 4s, 8s...
      const delay = Math.pow(2, i) * 1000;
      await new Promise(resolve => setTimeout(resolve, delay));
      console.log(`Reintentando... (intento ${i + 2}/${maxRetries})`);
    }
  }
  throw new Error('Máximo de reintentos alcanzado');
}
```

---

#### **7. I/O-bound vs. CPU-bound, Concurrencia y otros lenguajes**

##### **7.1 Tareas I/O-bound vs. CPU-bound**

No todas las tareas "lentas" son iguales, y entender la diferencia explica por qué el Event Loop funciona tan bien en unos casos y se bloquea en otros:

- **Tareas I/O-bound** (**I/O** *Input/Output* — entrada y salida): el cuello de botella está en **esperar** a un recurso externo (peticiones de red, consultas a una base de datos, lectura de archivos). Mientras la red responde, el procesador está libre. Aquí es donde brilla el Event Loop de JavaScript.
- **Tareas CPU-bound** (intensivas de **CPU** *Central Processing Unit*): el cuello de botella es el **cálculo** (cifrar archivos, comprimir video, entrenar un modelo, recorrer millones de datos). El procesador trabaja al 100 % sin pausas. En un entorno monohilo con Event Loop, una tarea CPU-bound **congela todo el programa**, incluso si está dentro de una función `async` o de una `Promise` (como ocurrió con el ciclo `while` del Experimento 1).

##### **7.2 Esto no son hilos: Concurrencia vs. Paralelismo real**

Cuando `Promise.all()` lanza tres peticiones `fetch()` al mismo tiempo, el sistema operativo y la red esperan las tres respuestas de forma simultánea, pero el código JavaScript sigue ejecutándose en **un solo hilo**. Por eso conviene distinguir dos conceptos:

- **Concurrencia:** gestionar múltiples tareas **intercalándolas por turnos** en un mismo hilo mientras unas esperan I/O (el modelo del Event Loop en JavaScript).
- **Paralelismo real:** ejecutar varias instrucciones de código **al mismo instante** en distintos núcleos de la CPU usando múltiples hilos.

Si en JavaScript necesitas paralelismo real para cálculo pesado (CPU-bound), debes mover ese trabajo fuera del hilo principal usando **Web Workers** (en el navegador) o **Worker Threads** (en Node.js).

##### **7.3 ¿Cómo lo resuelven otros lenguajes? JavaScript vs. Python vs. Go**

Cada lenguaje elige un modelo distinto según su diseño y caso de uso principal:

| Lenguaje | Modelo por defecto | ¿Cómo maneja I/O? | ¿Cómo logra paralelismo real (CPU)? |
|---|---|---|---|
| **JavaScript** (Navegador / Node.js) | Monohilo con **Event Loop** integrado | Asíncrono por defecto (`fetch`, timers, eventos) | **Web Workers** / **Worker Threads** |
| **Python** | Síncrono y bloqueante por defecto | `asyncio` (Event Loop explícito con `asyncio.run()` y librerías como `httpx` o `aiohttp`) | `multiprocessing` (procesos separados por el **GIL** *Global Interpreter Lock*, o modo *free-threaded* experimental en Python 3.13+) |
| **Go** | Concurrente y paralelo nativo | **Goroutines** (hilos muy livianos) con I/O no bloqueante transparente | El *runtime* reparte las goroutines automáticamente entre todos los núcleos de la CPU |

- **JavaScript** nació para responder a eventos de interfaz sin congelar el navegador; por eso trae el Event Loop encendido desde el primer momento y casi todas sus APIs de red son asíncronas.
- **Python** es síncrono por defecto (`requests.get`, `time.sleep`). Aunque ofrece `async/await` mediante `asyncio`, exige iniciar un Event Loop explícito y evitar librerías síncronas dentro de él. Además, el **GIL** tradicional impide que dos hilos ejecuten código Python a la vez en varios núcleos.
- **Go** no separa el lenguaje en funciones `async` y funciones normales: permite lanzar miles de **goroutines** con la palabra clave `go`, y su planificador las distribuye tanto para esperar I/O como para ejecutar cálculo real en paralelo sobre todos los núcleos del procesador.

> [!IMPORTANT]
> **Idea clave:** el Event Loop resuelve la **espera** (**I/O-bound**) mediante concurrencia en un solo hilo; no convierte a JavaScript en un lenguaje multihilo para cálculo pesado (**CPU-bound**).

##### **7.4 Un detalle práctico: ¿Existen las "Web APIs" en Node.js?**

Cuando aprendemos el Event Loop solemos ver el nombre **Web APIs** porque los primeros diagramas se pensaron para el navegador, pero vale la pena aclarar qué ocurre en el servidor:

- **El motor de JavaScript no hace el trabajo externo:** tanto Chrome como Node.js usan el mismo motor (**V8**), pero ese motor solo ejecuta el lenguaje base (variables, funciones y el **Call Stack**). Por sí solo no sabe conectarse a internet, contar tiempo ni leer archivos.
- **En el navegador**, la «cocina» la ponen las **Web APIs** del propio navegador (que manejan el DOM, los clics, `setTimeout` y `fetch`).
- **En Node.js** no hay navegador ni ventana gráfica, así que la «cocina» la pone el propio entorno de Node (apoyándose en una pieza interna llamada **`libuv`**) para hablar con el sistema operativo: leer archivos del disco, consultar bases de datos o abrir conexiones de red sin bloquear tu código.
- **¿Por qué en Node también funcionan `fetch` y `setTimeout`?** Porque Node.js adoptó esos mismos nombres estándar para que escribir código en el servidor sea familiar, aunque por debajo los gestione Node y no un navegador.

---
##### **Conceptos Clave:**

| Concepto | Definición |
|----------|-----------|
| **Promesa** | Objeto que representa el resultado eventual de una operación asíncrona |
| **Pending** | Estado inicial, la operación aún no terminó |
| **Fulfilled** | La promesa se completó exitosamente |
| **Rejected** | La promesa falló |
| **then()** | Maneja el caso exitoso de una promesa |
| **catch()** | Maneja errores de una promesa |
| **async** | Declara una función asíncrona |
| **await** | Pausa la ejecución hasta que una promesa se resuelva |
| **Promise.all()** | Espera a que todas las promesas se cumplan |
| **Promise.any()** | Espera a que la primera promesa se cumpla |
| **Promise.race()** | Resuelve o rechaza con la primera promesa que termine |
| **Promise.allSettled()** | Espera a todas y devuelve el estado individual de cada una |
| **Call Stack** | Pila LIFO donde se ejecuta el código JavaScript línea por línea |
| **Microtask Queue** | Cola de alta prioridad para callbacks de promesas y `await` |
| **Task Queue** | Cola estándar para callbacks de `setTimeout` y eventos de interfaz |
| **Event Loop** | Mecanismo que mueve callbacks de las colas al Call Stack cuando este queda vacío |
| **I/O-bound** | Tarea limitada por la espera de red, disco o base de datos; ideal para el Event Loop |
| **CPU-bound** | Tarea limitada por cálculo intensivo del procesador; bloquea el hilo principal |
| **Concurrencia** | Intercalar múltiples tareas en un mismo hilo aprovechando tiempos de espera |
| **Paralelismo** | Ejecutar múltiples tareas al mismo instante en distintos núcleos de la CPU |

##### **Guía de Decisión: ¿Cuándo usar qué?**

```typescript
// ¿Múltiples operaciones independientes?
const [a, b, c] = await Promise.all([fetchA(), fetchB(), fetchC()]);

// ¿Operaciones que dependen una de otra?
const user = await fetchUser();
const posts = await fetchPosts(user.id);

// ¿Necesitas timeout?
const data = await Promise.race([
  fetch(url),
  timeout(5000)
]);

// ¿Quieres código legible?
async function myFunction() {
  try {
    const data = await fetch(url);
    // ...
  } catch (error) {
    // ...
  }
}
```

---

### Parte Práctica

**Práctica:** [Torneo Pokémon Asíncrono](https://github.com/italovisconti/Guias-Practicas-Topicos/blob/main/Torneo%20Pokemon%20Asincrono/Practica%20-%20Torneo%20Pokemon%20Asincrono.md) · [Solución](https://github.com/italovisconti/Guias-Practicas-Topicos/blob/main/Torneo%20Pokemon%20Asincrono/Practica%20-%20Torneo%20Pokemon%20Asincrono%20-%20SOLUCION.ts)
