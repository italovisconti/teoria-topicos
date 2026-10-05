> [!NOTE] Referencias
> [Jansen, 2019] Capítulo 9

### Capítulo 9: Programación Reactiva Funcional

#### 1. Diferencias de Paradigmas

- **Programación Funcional (FP):** Se centra en funciones matemáticas puras, sin estado (stateless) y sin efectos secundarios.
- **Programación Reactiva (RP):** Se centra en la propagación de cambios a través de **flujos de eventos** (streams).
- **Programación Reactiva Funcional (FRP):** Es un superconjunto que une ambos mundos. Utiliza flujos de eventos que pueden componerse, evitando la mutación de estados externos y aplicando principios funcionales.

#### 2. Beneficios

La FRP facilita el razonamiento del código al evitar mutaciones de estado y promover un estilo declarativo. Es ideal para:

- Arquitecturas basadas en eventos.
- Sistemas concurrentes.    
- Escalabilidad (gracias al principio de composibilidad).

#### 3. Trabajando con Observables (Streams)

La programación reactiva cambia la mentalidad: **todo es un flujo de valores**.

- _Ejemplo:_ Un clic del mouse no es un evento aislado, sino un nuevo valor en un flujo continuo de datos (_stream_) que podemos consultar y manipular.
- **Herramienta:** Se utilizará la librería **RxJS** (Reactive Extensions for JavaScript), la cual implementa el patrón Observable y ofrece operadores para manipular estos flujos.

#### 4. La "Ecuación" del Patrón Observable

El texto define el patrón Observable (u Observable Sequence Pattern) como la suma de dos patrones de diseño clásicos:

> **Observable = Patrón Observer + Patrón Iterator**

A continuación, se desglosan ambos componentes:

- **A. El Patrón Observer (El Observador):**

    - Se basa en una relación de productor-consumidor (Push).
    - Existe un **Productor** que gestiona una lista de suscriptores (**Listeners**).
    - Cuando el Productor genera un mensaje, invoca el método `notify`, el cual recorre la lista y ejecuta el método `update` de cada Listener. 
    - _En resumen:_ El productor "empuja" (push) los datos a los oyentes.

- **B. El Patrón Iterator (El Iterador):**
    
    - Es necesario para entender cómo funcionan las secuencias.
    - Se basa en extraer datos bajo demanda (Pull).
    - El código muestra el uso de **Generadores** (`function*`) para crear un iterador.
    - El iterador devuelve un objeto con `{ value, done }`.
    - Se puede consumir manualmente llamando a `.next()` o automáticamente usando un bucle `for...of`.


## El patron observador

"Hola Jerry, les estoy notificando a todos que la reunión del Grupo de Patrones se movió al sábado por la noche. Vamos a hablar sobre el Patrón Observador. ¡Ese patrón es el mejor! Es el MEJOR, Jerry."

"No quieres perderte cuando sucede algo interesante, ¿verdad? Tenemos un patrón que mantiene a tus objetos informados cuando ocurre algo que les importa. Es el Patrón Observador. Es uno de los patrones de diseño más utilizados y es increíblemente útil. Vamos a analizar todo tipo de aspectos interesantes del Observador, como sus relaciones uno a muchos y su bajo acoplamiento. Y, con esos conceptos en mente, ¿cómo puedes no ser el alma de la Fiesta de Patrones?"

### **Declaración de Trabajo**

Tu equipo acaba de ganar el contrato para construir la Estación de Monitoreo Climático de próxima generación basada en internet para Weather-O-Rama, Inc. ¡Felicidades!

Necesitamos que desarrollen una aplicación basada en nuestro objeto `WeatherData` (temperatura, humedad y presión) que incluya tres pantallas actualizadas en tiempo real: condiciones actuales, estadísticas y pronóstico.

Es **crucial** que el diseño sea expandible. La arquitectura debe permitir que desarrolladores externos conecten fácilmente nuevas visualizaciones en el futuro, ya que nuestro modelo de negocio se basa en cobrar por estos módulos adicionales.

El pago se realizará mediante opciones sobre acciones. Esperamos su diseño y la versión alfa.

Atentamente,

**Weather-O-Rama, Inc.**

### Visión General de la Aplicación de Monitoreo Climático

Echemos un vistazo a la aplicación de Monitoreo Climático que necesitamos entregar: tanto lo que Weather-O-Rama nos está entregando, como lo que necesitaremos construir o extender. El sistema tiene tres componentes:

1. **La estación meteorológica:** El dispositivo físico que adquiere los datos climáticos reales.
2. **El objeto WeatherData:** El que rastrea los datos provenientes de la Estación Meteorológica y actualiza las pantallas.
3. **La pantalla (display):** Lo que muestra a los usuarios las condiciones climáticas actuales.

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-2.png" width="700" alt="">

> **El objeto `WeatherData` fue escrito por Weather-O-Rama y sabe cómo comunicarse con la Estación Meteorológica física para obtener datos actualizados del clima.**

Necesitaremos adaptar el objeto `WeatherData` para que sepa cómo actualizar la pantalla. Con suerte, Weather-O-Rama nos ha dado pistas en el código fuente sobre cómo hacer esto.

Recuerda, somos responsables de implementar tres elementos de visualización diferentes:

1. **Condiciones Actuales** (muestra temperatura, humedad y presión).
2. **Estadísticas del Clima**.
3. **Un Pronóstico simple**.

**Entonces, nuestro trabajo, si decidimos aceptarlo, es crear una aplicación que utilice el objeto `WeatherData` para actualizar tres pantallas: condiciones actuales, estadísticas climáticas y un pronóstico.**

### Analizando la Clase `WeatherData`

Vamos a revisar los archivos adjuntos con el código fuente que envió Johnny Hurricane, el CEO. Empezaremos con la clase `WeatherData`:

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-3.png" width="304" alt="">

Estos tres métodos devuelven las mediciones climáticas más recientes para temperatura, humedad y presión barométrica, respectivamente.

No nos importa ahora CÓMO obtiene estos datos, solo sabemos que el objeto `WeatherData` recibe información actualizada de la Estación Meteorológica.

**Ten en cuenta que cada vez que `WeatherData` tiene valores actualizados, se llama al método `measurementsChanged()`.**

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-4.png" width="440" alt="">

Echemos un vistazo al método `measurementsChanged()`, el cual, repetimos, se llama cada vez que el objeto `WeatherData` obtiene nuevos valores para temperatura, humedad y presión.

Parece que Weather-O-Rama dejó una nota en los comentarios para **agregar nuestro código aquí**. Así que quizás es aquí donde necesitamos actualizar la pantalla (una vez que la hayamos implementado).

Entonces, nuestro trabajo es modificar el método `measurementsChanged()` para que **actualice las tres visualizaciones**: la de condiciones actuales, la de estadísticas climáticas y la de pronóstico.

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-5.png" width="200" alt="">

### Nuestro Objetivo

Sabemos que necesitamos implementar una visualización y luego lograr que el objeto `WeatherData` actualice esa visualización cada vez que tenga nuevos valores, o, en otras palabras, cada vez que se llame al método `measurementsChanged()`. Pero, ¿cómo? Pensemos en lo que intentamos lograr:

- Sabemos que la clase `WeatherData` tiene métodos _getter_ para los tres valores de medición: temperatura, humedad y presión barométrica.
    
- Sabemos que el método `measurementsChanged()` se llama cada vez que hay nuevos datos de medición del clima disponibles. (Repetimos, no sabemos ni nos importa cómo se llama a este método; simplemente sabemos que se llama).
    
- Necesitaremos implementar **tres elementos de visualización** que utilicen los datos climáticos: una pantalla de condiciones actuales, una pantalla de estadísticas y una pantalla de pronóstico. Estas pantallas deben actualizarse con tanta frecuencia como `WeatherData` tenga nuevas mediciones.
    
- Para actualizar las pantallas, **agregaremos código al método `measurementsChanged()`**.

## Meta Adicional (Stretch Goal)

Pero pensemos también en el futuro. ¿Recuerdas la constante en el desarrollo de _software_? **El cambio**.

Esperamos que, si la Estación Meteorológica tiene éxito, habrá más de tres visualizaciones en el futuro, así que, ¿por qué no crear un mercado (marketplace) para pantallas adicionales? Por lo tanto, ¿qué tal si incorporamos:

> **Extensibilidad:** Otros desarrolladores podrían querer crear nuevas visualizaciones personalizadas. ¿Por qué no permitir a los usuarios agregar (o eliminar) tantos elementos de visualización como deseen a la aplicación? Actualmente, conocemos los tres tipos de visualización iniciales (condiciones actuales, estadísticas y pronóstico), pero esperamos un vibrante mercado para nuevas pantallas en el futuro.

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-6.png" width="403" alt="">

### Adoptando una Primera Implementación Errónea de la Estación Meteorológica

Aquí hay una primera posibilidad de implementación — como hemos discutido, vamos a añadir nuestro código al método `measurementsChanged()` en la clase `WeatherData`:

```Java
public class WeatherData {

    // instance variable declarations
    // Declaraciones de variables de instancia (las pantallas)

    // Aquí están las adiciones a nuestro código...
    public void measurementsChanged() {

        // Primero, obtenemos las mediciones más recientes
        // llamando a los métodos getter de WeatherData.
        // Asignamos cada valor a una variable con un nombre apropiado.
        float temp = getTemperature();
        float humidity = getHumidity();
        float pressure = getPressure();

        // A continuación, vamos a actualizar cada pantalla...
        currentConditionsDisplay.update(temp, humidity, pressure);
        statisticsDisplay.update(temp, humidity, pressure);
        forecastDisplay.update(temp, humidity, pressure);
        // ...llamando a su método update y pasándole las mediciones más recientes.
    }

    // otros métodos de WeatherData aquí
}
```

### **¿Qué tiene de malo nuestra implementación, de todos modos?**

Piensa en todos esos conceptos y principios del Capítulo 1: ¿cuáles estamos violando y cuáles no? Piensa en particular en los efectos del cambio en este código. Analicemos nuestro razonamiento mientras miramos el código:

| **Comentario Original (Inglés)**                                                                                                                                              | **Traducción al Español**                                                                                                                                                                                     |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Let's take another look...**                                                                                                                                                | Echemos otro vistazo...                                                                                                                                                                                       |
| **Looks like an area of change. We need to encapsulate this.**                                                                                                                | Parece un **área de cambio**. Necesitamos encapsular esto.                                                                                                                                                    |
| **At least we seem to be using a common interface to talk to the display elements... they all have an `update()` method that takes the temp, humidity, and pressure values.** | Al menos parece que estamos usando una **interfaz común** para comunicarnos con los elementos de visualización... todos tienen un método `update()` que recibe los valores de temperatura, humedad y presión. |
| **By coding to concrete implementations, we have no way to add or remove other display elements without making changes to the code.**                                         | Al programar sobre implementaciones concretas, **no tenemos forma de agregar o eliminar otros elementos de visualización** sin hacer cambios en el código.                                                    |
| **What if we want to add or remove displays at runtime? This looks hardcoded.**                                                                                               | ¿Qué pasa si queremos agregar o eliminar pantallas en tiempo de ejecución? Esto parece **codificado rígidamente (hardcoded)**.                                                                                |

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-7.png" width="700" alt="">

### Conoce el Patrón Observador

Sabes cómo funcionan las suscripciones a periódicos o revistas:

- Un editor de periódicos inicia un negocio y comienza a publicar periódicos.
- Tú te **suscribes** a un editor en particular y, cada vez que hay una nueva edición, te la entregan. Mientras sigas siendo suscriptor, recibes nuevos periódicos.
- Te **desuscribes** cuando ya no quieres más periódicos y dejan de ser entregados.
- Mientras el editor se mantenga en el negocio, personas, hoteles, aerolíneas y otros negocios constantemente se suscriben y se desuscriben al periódico.

**Publishers + Subscribers = Patron Observador**

La ventaja de este patron es si conoces alguno de estos conceptos del mundo real, ya sabes como funciona el patron observador. Llamamos al editor el **SUJETO** y a los suscriptores, los **OBSERVADORES**.

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-8.png" width="700" alt="">

| **Texto Original en Inglés**                                                                                       | **Traducción al Español**                                                                                                    |
| ------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| **Subject Object**                                                                                                 | **Objeto Sujeto**                                                                                                            |
| The Subject object manages some important data.                                                                    | El Objeto Sujeto gestiona datos importantes.                                                                                 |
| When data in the Subject changes, the observers are notified.                                                      | Cuando los datos en el Sujeto cambian, los observadores son notificados.                                                     |
| New data values are communicated to the observers in some form when they change.                                   | Los nuevos valores de datos se comunican a los observadores de alguna forma cuando cambian.                                  |
| The observers have subscribed to (registered with) the Subject to receive updates when the Subject's data changes. | Los observadores se han suscrito (registrado en) el Sujeto para recibir actualizaciones cuando cambian los datos del Sujeto. |
| **Observer Objects**                                                                                               | **Objetos Observadores**                                                                                                     |
| **Dog Object**                                                                                                     | **Objeto Perro**                                                                                                             |
| **Cat Object**                                                                                                     | **Objeto Gato**                                                                                                              |
| **Mouse Object**                                                                                                   | **Objeto Ratón**                                                                                                             |
| **Duck Object**                                                                                                    | **Objeto Pato**                                                                                                              |
| This object isn't an observer, so it doesn't get notified when the Subject's data changes.                         | Este objeto no es un observador, por lo que no es notificado cuando cambian los datos del Sujeto.                            |

| **Un objeto Pato aparece y le dice al Sujeto que quiere convertirse en un observador.**                                                                     |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Pato realmente quiere participar en la acción; esos valores `int` que el Sujeto está enviando cada vez que su estado cambia se ven bastante interesantes... |
| **El objeto Pato es ahora un observador oficial.**                                                                                                          |
| Pato está entusiasmado... está en la lista y espera con gran anticipación la siguiente notificación para poder obtener un valor `int`.                      |
| **¡El Sujeto obtiene un nuevo valor de dato!**                                                                                                              |
| Ahora Pato y todos los demás observadores reciben una notificación de que el Sujeto ha cambiado.                                                            |

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-9.png" width="594" alt="">

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-10.png" width="482" alt="">

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-11.png" width="469" alt="">

| **El objeto Ratón pide ser eliminado como observador.**                                                                                                                                                                           |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| El objeto Ratón ha estado recibiendo valores `int` por mucho tiempo y está cansado de ello, por lo que decide que es hora de dejar de ser un observador.                                                                          |
| **¡Ratón está fuera!**                                                                                                                                                                                                            |
| El Sujeto reconoce la solicitud del Ratón y lo elimina del conjunto de observadores.                                                                                                                                              |
| **El Sujeto tiene otro nuevo valor `int`.**                                                                                                                                                                                       |
| Todos los observadores reciben otra notificación, excepto el Ratón, que ya no está incluido. Que no se lo digas a nadie, pero el Ratón extraña en secreto esos valores `int`... quizás pida ser un observador de nuevo algún día. |

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-12.png" width="489" alt="">

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-13.png" width="497" alt="">

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-14.png" width="488" alt="">

### Definiendo el Patron Observador

El Patrón Observador define una **dependencia uno-a-muchos** entre objetos, de modo que cuando un objeto cambia de estado, **todos sus dependientes son notificados y actualizados automáticamente.**

El Patrón Observador define una **relación uno-a-muchos** entre un conjunto de objetos. Cuando el estado de un objeto cambia, **todos sus dependientes son notificados**.

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-15.png" width="700" alt="">

| **Texto Original en Inglés**                                                                                                                                                                                                                           | **Traducción al Español**                                                                                                                                                                                                                                          |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Let's take a look at the structure of the Observer Pattern, complete with its Subject and Observer classes. Here's the class diagram:**                                                                                                              | Echemos un vistazo a la estructura del Patrón Observador, completo con sus clases Sujeto (_Subject_) y Observador (_Observer_). Aquí está el diagrama de clases:                                                                                                   |
| **All potential observers need to implement the Observer interface. This interface has just one method, `update()`, that is called when the Subject's state changes.**                                                                                 | Todos los observadores potenciales necesitan implementar la interfaz Observador. Esta interfaz tiene solo un método, `update()`, que se llama cuando el estado del Sujeto cambia.                                                                                  |
| **Here's the Subject interface. Objects use this interface to register as observers and also to remove themselves from being observers.**                                                                                                              | Aquí está la interfaz Sujeto. Los objetos usan esta interfaz para registrarse como observadores y también para eliminarse de la lista de observadores.                                                                                                             |
| **Each subject can have many observers.**                                                                                                                                                                                                              | Cada Sujeto puede tener muchos observadores.                                                                                                                                                                                                                       |
| **A concrete subject always implements the Subject interface. In addition to the register and remove methods, the concrete subject implements a `notifyObservers()` method that is used to update all the current observers whenever state cha1nges.** | Un Sujeto Concreto siempre implementa la interfaz Sujeto. Además de los métodos de registro y eliminación, el Sujeto Concreto implementa un método `notifyObservers()` que se usa para actualizar a todos los observadores actuales cada vez que el estado cambia. |
| **The concrete subject may also have methods for setting and getting its state (more about this later).**                                                                                                                                              | El Sujeto Concreto también puede tener métodos para establecer y obtener su estado (más sobre esto más adelante).                                                                                                                                                  |
| **Concrete observers can be _any class_ that implements the Observer interface. Each observer registers with a concrete subject to receive updates.**                                                                                                  | Los Observadores Concretos pueden ser _cualquier clase_ que implemente la interfaz Observador. Cada observador se registra con un Sujeto Concreto para recibir actualizaciones.                                                                                    |

### **El Poder del Acoplamiento Débil (Loose Coupling)**

Cuando dos objetos tienen un "acoplamiento débil", pueden interactuar entre sí a pesar de tener muy poco conocimiento el uno del otro. Los diseños con acoplamiento débil nos dan mucha flexibilidad, y el Patrón Observador es un excelente ejemplo de esto. Veamos cómo logra este patrón el acoplamiento débil:

- **El sujeto solo sabe que el observador implementa una interfaz específica** (la interfaz _Observer_). No necesita conocer la clase concreta del observador, qué hace, ni ningún otro detalle sobre él.
- **Podemos añadir observadores en cualquier momento.** Dado que el sujeto solo depende de una lista de objetos que implementan la interfaz _Observer_, podemos agregar, reemplazar o eliminar observadores en tiempo de ejecución sin que el sujeto se vea afectado; este seguirá funcionando sin problemas.
- **Nunca necesitamos modificar el sujeto para añadir nuevos tipos de observadores.** Si tenemos una nueva clase concreta que necesita ser observador, no tocamos el código del sujeto. Solo necesitamos que la nueva clase implemente la interfaz y se registre. Al sujeto no le importa el tipo de clase, solo le importa la interfaz.
- **Podemos reutilizar sujetos u observadores de forma independiente.** Si necesitamos usar uno de los dos en otro contexto, podemos hacerlo fácilmente porque no están fuertemente atados el uno al otro.
- **Los cambios en el sujeto o en el observador no afectan a la contraparte.** Gracias al acoplamiento débil, somos libres de modificar el código de cualquiera de los dos, siempre y cuando sigan cumpliendo con sus obligaciones de implementar las interfaces de Sujeto (_Subject_) u Observador (_Observer_).

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-16.png" width="465" alt="">

Esfuérzate por conseguir diseños de acoplamiento débil entre objetos que interactúan.

**Ejercicio:**
Antes de continuar, intenta esbozar las clases que necesitarás para implementar la Estación Meteorológica, incluyendo la clase `WeatherData` y sus elementos de visualización. Asegúrate de que tu diagrama muestre cómo encajan todas las piezas y también cómo otro desarrollador podría implementar su propio elemento de visualización.

<img src="assets/Unidad%20IX%20-%20Programacion%20Reactiva/image-17.png" width="700" alt="">

| **Texto Original en Inglés**                                                                                                                                      | **Traducción al Español**                                                                                                                                                                              |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Here's our Subject interface. This should look familiar.**                                                                                                      | Aquí está nuestra interfaz **Sujeto**. Esto debería resultarte familiar.                                                                                                                               |
| **All our weather components implement the Observer interface. This gives the Subject a common interface to talk to when it comes time to update the observers.** | Todos nuestros componentes del clima implementan la interfaz **Observador**. Esto le da al Sujeto una interfaz común con la cual comunicarse cuando llega el momento de actualizar a los observadores. |
| **Let's also create an interface for all display elements to implement. The display elements just need to implement a display() method.**                         | Vamos a crear también una interfaz para que la implementen todos los elementos de visualización. Los elementos de visualización solo necesitan implementar un método `display()`.                      |
| **WeatherData now implements the Subject interface.**                                                                                                             | `WeatherData` ahora implementa la interfaz **Sujeto**.                                                                                                                                                 |
| **This display element shows the current measurements from the WeatherData object.**                                                                              | Este elemento de visualización muestra las mediciones actuales del objeto `WeatherData`.                                                                                                               |
| **This one keeps track of the min/avg/max measurements and displays them.**                                                                                       | Este realiza un seguimiento de las mediciones mínima/promedio/máxima y las muestra.                                                                                                                    |
| **Developers can implement the Observer and DisplayElement interfaces to create their own display element.**                                                      | Los desarrolladores pueden implementar las interfaces **Observador** y **ElementoDeVisualización** (`DisplayElement`) para crear su propio elemento de visualización.                                  |
### Implementando las clases

```ts
interface Subject {
    // Ambos métodos toman un Observer como argumento, es decir,
    // el Observer que se registrará o eliminará.
    registerObserver(o: Observer): void;
    removeObserver(o: Observer): void;

    // Este método se llama para notificar a todos los observadores
    // cuando el estado del Sujeto ha cambiado.
    notifyObservers(): void;
}

interface Observer {
    // Estos son los valores de estado que los Observadores obtienen del Sujeto
    // cuando cambia una medición del clima.
    // La interfaz Observer es implementada por todos los observadores,
    // por lo que todos deben implementar el método update().
    // Aquí seguimos el ejemplo de Mary y Sue y pasamos las mediciones a los observadores.
    update(temp: number, humidity: number, pressure: number): void;
}

interface DisplayElement {
    // La interfaz DisplayElement solo incluye un método, display(),
    // que llamaremos cuando el elemento de visualización necesite mostrarse.
    display(): void;
}
```

#### Implementamos las interfaces

```ts
export class WeatherData implements Subject {
    // Hemos añadido un Array para mantener a los Observadores,
    // y lo inicializamos en el constructor.
    private observers: Observer[];
    private temperature: number;
    private humidity: number;
    private pressure: number;

    constructor() {
        this.observers = [];
    }

    public registerObserver(o: Observer): void {
        // Cuando un observador se registra, simplemente lo añadimos al final de la lista.
        this.observers.push(o);
    }

    public removeObserver(o: Observer): void {
        // Igualmente, cuando un observador quiere darse de baja,
        // simplemente lo sacamos de la lista.
        const index = this.observers.indexOf(o);
        if (index >= 0) {
            this.observers.splice(index, 1);
        }
    }

    public notifyObservers(): void {
        // Aquí está la parte divertida; aquí es donde le contamos a todos los observadores sobre el estado.
        // Como todos son Observadores, sabemos que todos implementan update(),
        // así que sabemos cómo notificarlos.
        for (const observer of this.observers) {
            observer.update(this.temperature, this.humidity, this.pressure);
        }
    }

    // ----------------------------------------------

    public measurementsChanged(): void {
        // Notificamos a los Observadores cuando obtenemos mediciones actualizadas
        // de la Estación Meteorológica.
        this.notifyObservers();
    }

    public setMeasurements(temperature: number, humidity: number, pressure: number): void {
        this.temperature = temperature;
        this.humidity = humidity;
        this.pressure = pressure;
        this.measurementsChanged();
        
        // Vale, aunque queríamos enviar una pequeña y bonita estación meteorológica con cada libro,
        // la editorial no lo aceptó. Así que, en lugar de leer datos reales del clima de un dispositivo,
        // vamos a usar este método para probar nuestros elementos de visualización.
        // O, por diversión, podrías escribir código para obtener mediciones de la web.
    }

    // otros métodos de WeatherData aquí
}
```

#### Pasamos a los displays

```ts
export class CurrentConditionsDisplay implements Observer, DisplayElement {
    private temperature: number;
    private humidity: number;
    private weatherData: WeatherData;

    // Al constructor se le pasa el objeto weatherData (el Sujeto)
    // y lo usamos para registrar la pantalla como un observador.
    constructor(weatherData: WeatherData) {
        this.weatherData = weatherData;
        this.weatherData.registerObserver(this);
    }

    // Esta pantalla implementa la interfaz Observer para poder obtener cambios
    // del objeto WeatherData.
    // También implementa DisplayElement, porque nuestra API requerirá que todos
    // los elementos de visualización implementen esta interfaz.
    public update(temperature: number, humidity: number, pressure: number): void {
        // Cuando se llama a update(), guardamos la temperatura y la humedad
        // y llamamos a display().
        this.temperature = temperature;
        this.humidity = humidity;
        this.display();
    }

    public display(): void {
        console.log("Current conditions: " + this.temperature + "F degrees and " + this.humidity + "% humidity");
    }
}
```

### Weather Station esta lista!

```ts
// Primero, crea el objeto WeatherData.
const weatherData = new WeatherData();

// Crea las tres pantallas y pásales el objeto WeatherData.
const currentDisplay = new CurrentConditionsDisplay(weatherData);
const statisticsDisplay = new StatisticsDisplay(weatherData);
const forecastDisplay = new ForecastDisplay(weatherData);

// Simula nuevas mediciones del clima.
console.log("--- Enviando primera actualización ---");
weatherData.setMeasurements(80, 65, 30.4);

console.log("\n--- Enviando segunda actualización ---");
weatherData.setMeasurements(82, 70, 29.2);

console.log("\n--- Enviando tercera actualización ---");
weatherData.setMeasurements(78, 90, 29.2);
```

