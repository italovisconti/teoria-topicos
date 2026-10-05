> [!NOTE] Referencias
> Riscutia, 2020 - Capítulos 5 y 7

Ya conocemos la POO, conocemos los tipos básicos y los nuevos tipos que podemos crear a partir de ellos. 
Ahora nos adentraremos en una nueva característica de los sistemas tipados, la habilitada de "tipar" funciones. Si podemos nombrar tipos de funciones y usar funciones en los mismos lugares que usamos valores de otros tipos —como variables, argumentos y valores de retorno de funciones— podemos simplificar la implementación de varias construcciones comunes y abstraer algoritmos comunes a funciones.

### La Base? Funciones como ciudadanos de primera clase
La base fundamental de esta unidad se basa en que TypeScript (y muchos otros lenguajes mas) trata a las funciones como "*ciudadanos de primera clase*", esto significa que podemos manipular las funciones tal cual como lo hacemos con otros tipos de datos como `string`, `number` y `boolean`

**Importante: Diferencias entre referenciar y ejecutar una función**

```ts
// Lo mas basico
function saludar() {
    console.log("¡Hola mundo!");
}
console.log(saludar); // Muestra la función como objeto -> [Function: saludar]
saludar(); // Ejecuta la función -> ¡Hola mundo!

// Asignando referencias vs resultados
function sumar(a: number, b: number): number {
    return a + b;
}
const referencia = sumar; // Asigna la funcion a una variable
const resultado = sunar(1, 1); // Asigna el resultado (2) a una variable

console.log(referencia); // Muestra la función como objeto -> [Function: suma]
console.log(resultado); // Muestra el resultado -> 2
console.log(referencia(1, 1)) // Ejecuta la función a través de la referencia y muestra el resultado -> 2
```

Un tipo funcional se ve así:
<img src="assets/Unidad%20III%20-%20Tipos%20Funcionales%20y%20Subtipos/image-28.png" width="545" alt="">

**Tipo o firma de una funcion:** El tipo de una función viene dado por el **tipo de sus argumentos** y su **tipo de retorno**. Si dos funciones toman los mismos argumentos y retornan el mismo tipo, tienen el mismo tipo. Al conjunto de argumentos más el tipo de retorno también se le conoce como la **firma** (signature) de una función.

Por lo tanto, podemos:
#### 1. Asignar funciones a variables

**Un ejemplo**:
```ts
// Creamos una funcion normal
function saludar(nombre: string): string {
  return `Hola, ${nombre}!`;
}

// El tipo 'saludoFunction' describe cómo debe ser la función.
type saludoFunction = (nombre: string) => string;

// asignamos la funcion a una variable.
const miSaludo: saludoFunction = saludar;

// Ahora podemos usar la variable como si fuera la función original.
console.log(miSaludo("Mundo")); // Salida: Hola, Mundo!

// Incluso podriamos asignarla a una nueva variable
const miSaludoCopia: saludoFunction = saludar;
console.log(miSaludoCopia("Mundo desde Copia")); // Salida: Hola, Mundo desde Copia!
```
En este **ejemplo**, `miSaludo` no contiene el resultado de saludar, sino que `miSaludo` es la función saludar. Esto nos permite, por ejemplo, cambiar dinámicamente qué función se ejecuta.
##### **Ejercicio**
Haremos una calculadora. Tendremos una única variable llamada `operacionActual`. Dependiendo de la función que le asignemos a esta variable, realizará una suma, una resta o una multiplicación.
```ts
type OperacionMatematica = (a: number, b: number) => number;

// Funciones que podemos usar
function sumar(a: number, b: number): number {
  return a + b;
}
function restar(a: number, b: number): number {
  return a - b;
}
// TAREA: Crea función 'multiplicar'.

// TAREA: Usa solo esta variable para realizar las operaciones.
let operacionActual: OperacionMatematica;

console.log("---Calculadora Dinamica---");
// TAREA: Realiza una suma
// TAREA: Realiza una resta
// TAREA: Realiza una multiplicacion
```

#### ==Pero antes de seguir... Arrow Functions== 
Su símbolo central es una flecha (=>)

Podemos definir una función flecha de manera sencilla:
```ts
const saludo = (quien: string): string => {
    return `Hola, ${quien}!`;
};

saludo('Estefany'); // => 'Hola, Estefany!'
```
`saludo` es una función flecha. El símbolo "=>" delimita los parámetros y el cuerpo de la función.

Una función flecha también se puede ver como:
```ts
// Arrow sin bloque y tipo de retorno inferido
const saludo2 = (quien: string) => `Hola, ${quien}!`;

// Arrow sin bloque, tipo de retorno inferido y parámetro sin tipo (any)
const saludo3 = quien => `Hola, ${quien}!`;
```

Este tipo de funciones tiene características que veremos mas adelante.

#### 2. Pasar Funciones como Argumentos (Callbacks)
Permite que una función tome otra función como "instrucción" sobre qué hacer (pasándose como parámetro).

Supongamos que queremos una función que procese una lista de nombres y los muestre. Podríamos querer mostrarlos en mayúsculas, minúsculas o de alguna otra forma.
En lugar de crear una función para cada caso, creamos una función genérica que acepta otra función como argumento para realizar la transformación.

```ts
type Transformacion = (texto: string) => string;

// Procesa los nombres. Acepta un array y una función de transformación.
function procesarNombres(nombres: string[], transformar: Transformacion): void {
  for (const nombre of nombres) {
    console.log(transformar(nombre));
  }
}

// Ahora definimos las funciones específicas que queremos usar.
// Usa la sintaxis de función anónima.
const aMayusculas: Transformacion = function(texto) {
    return texto.toUpperCase();
} 
// Usa la sintaxis de función flecha.
const aMinusculas: Transformacion = (texto) => texto.toLowerCase();

const listaDeNombres = ["Ana", "Juan", "Pedro"];
procesarNombres(listaDeNombres, aMayusculas); // Salida: ANA JUAN PEDRO
procesarNombres(listaDeNombres, aMinusculas); // Salida: ana juan pedro
```

Vemos que `procesarNombres` es una función de biblioteca reutilizable. No le importa cómo se transforman los nombres, solo que recibe una función que sabe hacerlo. Esto simplifica enormemente el código, ya que evitamos duplicar el bucle for y la lógica de impresión en múltiples funciones.

**¿Tienen otra idea de función especifica que podamos crear?**

==**Como haríamos esto si las funciones no fueran tratadas como ciudadanos  de primera clase?**==
Seguro sea algo como:
```ts
function procesarNombresAMayusculas(nombres: string[]): void {
  for (const nombre of nombres) {
    console.log(nombre.toUpperCase());
  }
}
function procesarNombresAMinusculas(nombres: string[]): void {
  for (const nombre of nombres) {
    console.log(nombre.toLowerCase());
  }
}

procesarNombresAMayusculas(listaDeNombres); // Salida: ANA JUAN PEDRO
procesarNombresAMinusculas(listaDeNombres); // Salida: ana juan pedro
```
``
#### 3. Retornar Funciones desde otras Funciones (Closures)
Una función también puede "fabricar" y devolver otra función. Esto es muy útil para crear funciones preconfiguradas.
`Imagina que quieres crear funciones que multipliquen por un número específico. Podríamos tener duplicar, triplicar, etc.`

```ts
// Esta función no devuelve un número, devuelve otra funcion!
function crearMultiplicador(factor: number): (numero: number) => number {
  // La función que devolvemos "recuerda" el valor de 'factor'.
  // Esto se conoce como un 'closure'.
  return function(numero: number): number {
    return numero * factor;
  };
}

// Creamos funciones específicas usando nuestra "fábrica" de funciones.
const duplicar = crearMultiplicador(2);
const triplicar = crearMultiplicador(3);

// Ahora usamos las nuevas funciones que hemos creado.
console.log(duplicar(5));   // Imprime: 10
console.log(triplicar(5));  // Imprime: 15
console.log(duplicar(10));  // Imprime: 20
```

No podemos olvidar que estamos definiendo un tipo funcional como retorno de la función `crearMultiplicador`
<img src="assets/Unidad%20III%20-%20Tipos%20Funcionales%20y%20Subtipos/image-27.png" width="700" alt="">

Internamente, si usamos esta "fabrica" de la siguiente forma:
`const duplicar = crearMultiplicador(2)`
es como si estuviéramos devolviendo:
```ts
function(numero: number): number {
	return numero * 2
}
```

### Patron Strategy ¿Otra vez?

Supongamos que tenemos un **auto-lavado** con dos tipos de servicios, **lavado standard** y **lavado premium** (cuesta mas). Les suena a **Strategy** ¿verdad?

<img src="assets/Unidad%20III%20-%20Tipos%20Funcionales%20y%20Subtipos/image-29.png" width="613" alt="">

```ts
class Car {
	/* ... */
}

interface IWashingStrategy {
	wash(car: Car): void;
}

class StandardWash implements IWashingStrategy {
	public wash(car: Car): void {
		/* Perform standard wash */
	}
}

class PremiumWash implements IWashingStrategy {
	public wash(car: Car): void {
		/* Perform premium wash */
	}
}

class CarWash {
	public service(car: Car, premium: boolean): void {
		let washingStrategy: IWashingStrategy;

		if (premium) {
		washingStrategy = new PremiumWash();
		} else {
		washingStrategy = new StandardWash();
		}
		washingStrategy.wash(car);
	}
}
```

Este código funciona, pero es **innecesariamente verboso**. Hemos introducido una interfaz y dos tipos que la implementan, cada uno proporcionando un único método `wash()`. Estos tipos no son realmente important`es; la parte valiosa de nuestro código es la lógica de lavado. Este código es solo una función, por lo que podemos simplificarlo mucho si pasamos de interfaces y clases a un tipo funcional y dos implementaciones concretas.

Podemos definir `WashingStrategy` como un tipo que representa una función que recibe un `Car` como argumento y devuelve `void` (no devuelve nada). Luego podemos implementar los dos tipos de lavados como dos funciones `standardWash()` y `premiumWash()`, ambas tomando un `Car` y devolviendo `void`. El CarWash puede seleccionar una de ellas para aplicarla a un auto determinado.

```ts
class Car {
	/* Represents a car */
}

type WashingStrategy = (car: Car) => void;

function standardWash(car: Car): void {
	/* Perform standard wash */
}

function premiumWash(car: Car): void {
	/* Perform premium wash */
}

class CarWash {
	public service(car: Car, premium: boolean): void {
		let washingStrategy: WashingStrategy;
		
		if (premium) {
			washingStrategy = premiumWash;
		} else {
			washingStrategy = standardWash;
		}
		washingStrategy(car);
	}
}
```

<img src="assets/Unidad%20III%20-%20Tipos%20Funcionales%20y%20Subtipos/image-30.png" width="675" alt="">

En esta implementacion tenemos menos partes. Pero las dos logran el mismo objetivo.

**¿Entienden por que esto funciona?**

Es importante tener en cuenta que el patrón es el mismo: todavía estamos encapsulando una familia de algoritmos y seleccionando en tiempo de ejecución cuál usar. La diferencia está en la implementación, que las capacidades modernas nos permiten expresar más fácilmente.

Estamos reemplazando una interfaz y dos clases concretas con una declaración de tipo y dos funciones.

En la mayoría de los casos, la implementación más sucinta es suficiente. Podríamos necesitar reconsiderar la implementación con interfaz y clases cuando los algoritmos no son representables como funciones simples. A veces, necesitamos múltiples funciones o necesitamos rastrear algún estado, en cuyo caso la primera implementación sería más adecuada, ya que agrupa las piezas relacionadas de una estrategia bajo un tipo común.
##### Preguntas

**1. ¿Cuál es el tipo de una función isEven() que toma un número como argumento y devuelve true si el número es par y false en caso contrario?**

a) [number, boolean]  
==b) (x: number) => boolean==  
c) (x: number, isEven: boolean)  
d) {x: number, isEven: boolean}

**2. ¿Cuál es el tipo de una función check() que toma un número y una función del mismo tipo que isEven() como argumentos, y devuelve el resultado de aplicar la función dada al valor dado?**

a) (x: number, func: number) => boolean  
b) (x: number) => (x: number) => boolean  
==c) (x: number, func: (x: number) => boolean) => boolean== 
d) (x: number, func: (x: number) => boolean) => void

**3. Implementa la función check() , la función isEven() y una función adicional con la misma firma que isEven()**

```ts
function check(x: number, func: (x: number) => boolean): boolean {
    return func(x);
}

// Función isEven del ejemplo
function isEven(x: number): boolean {
    return x % 2 === 0;
}

// Función adicional, vemos que es flexibilidad
function isPositive(x: number): boolean {
    return x > 0;
}

// Usando la función check
console.log(check(4, isEven));      // true (4 es par)
console.log(check(5, isEven));      // false (5 no es par)
console.log(check(10, isPositive)); // true (10 es positivo)
console.log(check(-3, isPositive)); // false (-3 no es positivo)
```
##### Ejercicio``
Convierte el ejercicio de **Duck en un Strategy Funcional**. 
Agrega un nuevo comportamiento "**comer**" el cual debe recibir **siempre** alguna comida (solo existen 3 tipos de comida: **grano, pan, semilla**). 
Implementa 3 algoritmos de comer, sabiendo que:
- Algunos patos pueden comer todo tipo de comida.
- El pato mallard es alérgico, por lo tanto solo puede comer granos. 
- Existe patos de goma que no pueden comer.
El comportamiento comer también debe recibir una "cantidad", esta debe ser **opcional**. 
##### Planteamiento
```ts
// Comportamiento de Vuelo
interface FlyBehavior {
  fly(): void;
}

class FlyWithWings implements FlyBehavior {
  public fly(): void {
    console.log("¡Estoy volando con alas!");
  }
}

class FlyNoWay implements FlyBehavior {
  public fly(): void {
    console.log("No puedo volar.");
  }
}

// Comportamiento de Graznido
interface QuackBehavior {
  quack(): void;
}

class Quack implements QuackBehavior {
  public quack(): void {
    console.log("¡Quack, quack!");
  }
}

class Squeak implements QuackBehavior {
  public quack(): void {
    console.log("Squeak, squeak!");
  }
}

class MuteQuack implements QuackBehavior {
  public quack(): void {
    console.log("<< Silencio >>");
  }
}

// Clase Abstracta Duck
abstract class Duck {
  // Las subclases inicializan estas propiedades en sus constructores
  protected flyBehavior: FlyBehavior;
  protected quackBehavior: QuackBehavior;

  constructor(flyBehavior: FlyBehavior, quackBehavior: QuackBehavior) {
    this.flyBehavior = flyBehavior;
    this.quackBehavior = quackBehavior;
  }

  // Método abstracto que las subclases deben implementar
  public abstract display(): void;

  public performFly(): void {
    this.flyBehavior.fly();
  }

  public performQuack(): void {
    this.quackBehavior.quack();
  }

  // Métodos para cambiar el comportamiento dinámicamente
  public setFlyBehavior(fb: FlyBehavior): void {
    console.log("Cambiando el comportamiento de vuelo...");
    this.flyBehavior = fb;
  }

  public setQuackBehavior(qb: QuackBehavior): void {
     console.log("Cambiando el comportamiento de graznido...");
    this.quackBehavior = qb;
  }

  public swim(): void {
    console.log("Todos los patos flotan, ¡incluso los señuelos!");
  }
}

// Clases Concretas de Duck
class MallardDuck extends Duck {
  constructor() {
    super(new FlyWithWings(), new Quack());
  }
  public display(): void {
    console.log("Soy un verdadero pato Mallard.");
  }
}

class RubberDuck extends Duck {
    constructor() {
        // Un pato de goma no vuela y hace "squeak"
        super(new FlyNoWay(), new Squeak());
    }
    public display(): void {
        console.log("Soy un pato de goma.");
    }
}

class DecoyDuck extends Duck {
    constructor() {
        // Un pato señuelo no hace nada
        super(new FlyNoWay(), new MuteQuack());
    }
    public display(): void {
        console.log("Soy un pato señuelo (decoy).");
    }
}
```
##### Resolución
```ts
// Sets de comportamientos usando tipos funcionales
// Volar
type FlyBehavior = () => void;
const flyWithWings: FlyBehavior = () => {
	console.log("¡Estoy volando con alas!");
};
const flyNoWay: FlyBehavior = () => {
	console.log("No puedo volar.");
};

// Quack
type QuackBehavior = () => void;
const quack: QuackBehavior = () => {
	console.log("¡Quack, quack!");
};
const squeak: QuackBehavior = () => {
	console.log("Squeak, squeak!");
};
const muteQuack: QuackBehavior = () => {
	console.log("<< Silencio >>");
};

// Comidas Enum
enum Food {
	GRAIN = "grano",
	BREAD = "pan",
	SEED = "semilla"
}

// Comer
type EatBehavior = (food: Food, quantity?: number) => void;
const eatAnything: EatBehavior = (food, quantity = 1) => {
	console.log(`Estoy comiendo ${quantity} porción(es) de ${food}.`);
};
const pickyEater: EatBehavior = (food, quantity = 1) => {
	if (food === Food.GRAIN) {
		console.log(`Estoy comiendo ${quantity} porción(es) de ${food}.`);
	} else {
		console.log(`No me gusta comer ${food}.`);
	}
};
const noEat: EatBehavior = (food, quantity = 0) => {
	console.log("No estoy comiendo nada.");
}

abstract class Duck {
	protected flyBehavior: FlyBehavior;
	protected quackBehavior: QuackBehavior;
	protected eatBehavior: EatBehavior;

	constructor(flyBehavior: FlyBehavior, quackBehavior: QuackBehavior, eatBehavior: EatBehavior) {
		this.flyBehavior = flyBehavior;
		this.quackBehavior = quackBehavior;
		this.eatBehavior = eatBehavior;
	}

	public abstract display(): void;

	public performFly(): void {
		this.flyBehavior();
	}

	public performQuack(): void {
		this.quackBehavior();
	}

	public performEat(food: Food, quantity?: number): void {
		this.eatBehavior(food, quantity);
	}

	public setFlyBehavior(fb: FlyBehavior): void {
		console.log("Cambiando el comportamiento de vuelo...");
		this.flyBehavior = fb;
	}

	public setQuackBehavior(qb: QuackBehavior): void {
		console.log("Cambiando el comportamiento de graznido...");
		this.quackBehavior = qb;
	}

	public setEatBehavior(eb: EatBehavior): void {
		console.log("Cambiando el comportamiento de alimentación...");
		this.eatBehavior = eb;
	}

	public swim(): void {
		console.log("Todos los patos flotan, ¡incluso los señuelos!");
	}
}

// Clases Concretas de Duck
class MallardDuck extends Duck {
	// El pato Mallard es un comedor quisquilloso
	constructor() {
		super(flyWithWings, quack, pickyEater);
	}

	public display(): void {
		console.log("Soy un verdadero pato Mallard.");
	}
}

class RubberDuck extends Duck {
	constructor() {
		super(flyNoWay, squeak, noEat);
	}

	public display(): void {
		console.log("Soy un pato de goma.");
	}
}

class DecoyDuck extends Duck {
	constructor() {
		super(flyNoWay, muteQuack, noEat);
	}

	public display(): void {
		console.log("Soy un pato señuelo (decoy).");
	}
}

const mallardDuck = new MallardDuck();
mallardDuck.display();
mallardDuck.performFly();
mallardDuck.performQuack();
mallardDuck.performEat(Food.GRAIN, 3);
mallardDuck.performEat(Food.BREAD);

const rubberDuck = new RubberDuck();
rubberDuck.display();
rubberDuck.performFly();
rubberDuck.performQuack();
rubberDuck.performEat(Food.SEED);
```

Acá existe un detalle, y es que como TypeScript usa un **sistema de tipos estructural**, podríamos hacer algo como `mallardDuck.setFlyBehavior(muteQuack)` es decir, podemos usar un comportamiento de **quack** en donde se espera un comportamiento de **vuelo**, esto es porque tienen la **misma estructura/firma**.

==**Idea para taller: Hacer una maquina de estados con funciones**==

##### ==Ejercicios==
1. ==Modela una conexión simple que puede estar abierta o cerrada como una máquina de estados. Una conexión se abre con connect y se cierra con disconnect.==
2. ==Implementa la conexión anterior como una máquina de estados funcional con una función process(). En una conexión cerrada, process() abre la conexión. En una conexión abierta, process() llama a una función read() que devuelve un string. Si el string está vacío, la conexión se cierra; de lo contrario, el string leído se imprime (loggea) en la consola. La función read() se proporciona de la siguiente manera: declare function read(): string;.==

### **Evitar cálculos costosos con Lazy Values**

La **evaluación perezosa** o **evaluación tardía** es una técnica de optimización que consiste en **retrasar un cálculo costoso** hasta el momento exacto en que se necesita su resultado, porque no siempre sera necesario realizar este calculo.

En lugar de calcular un valor inmediatamente (lo que se conoce como evaluación "ansiosa" o "eager"), envolvemos ese cálculo en una función. Luego, pasamos esa función en lugar del valor. La función solo se ejecutará si el resultado es **realmente necesario**.

Esto evita desperdiciar recursos en operaciones pesadas que quizás nunca se lleguen a utilizar.

Tenemos un **ejemplo**:
```ts
class Bike {
    // Logica de Bicicleta
}
class Car {
    // Logica de Carro
}

function isItRaining(): boolean {
    return Math.random() < 0.5; // Simula lluvia aleatoria
}

function chooseMyRide(bike: Bike, car: Car): Bike | Car {
    if (isItRaining()) {
        return car;
    } else {
        return bike;
    }
}

chooseMyRide(new Bike(), new Car());
```
Esto se conoce como *eager evaluation* o evaluación ansiosa.

Para llamar a `chooseMyRide()`, necesitamos suministrar un objeto `Car`, por lo que ya estamos pagando el costo de construir un `Car`. Si el clima es bueno y decido usar mi bicicleta, la instancia del `Car` fue creada para nada.

Hagamos esto de una forma **Lazy** 💤

```ts
class Bike { /* Logica de Bicicleta */ }
class Car { /* Logica de Carro */ }

function isItRaining(): boolean {
	return Math.random() < 0.5; // Simula lluvia aleatoria
}

function chooseMyRide(bike: Bike, car: () => Car): Bike | Car {
	if (isItRaining()) {
		return car();
	} else {
		return bike;
	}
}

chooseMyRide(new Bike(), () => new Car());
```


### Funciones de orden superior.
Funciones que aceptan o retornan otras funciones. 

A una función "normal", es decir, una que solo trabaja con argumentos y valores de retorno que no son funciones (como números o strings), se le conoce como **función de primer orden**.

Cuando una función toma una función de primer orden como argumento o la devuelve como resultado, la llamamos **función de segundo orden**. Podríamos continuar esta lógica para definir funciones de "tercer orden" y así sucesivamente, pero en la práctica, agrupamos a todas las funciones que operan con otras funciones bajo un solo término: **funciones de orden superior** (higher-order functions).

Acabamos de hacer esto en el ultimo ejemplo: `function chooseMyRide(bike: Bike, car: () => Car): Bike | Car {`

Varios algoritmos útiles pueden ser implementados como funciones de orden superior, siendo los más fundamentales `map()`, `filter()` y `reduce()`. 

#### map()

La idea detrás de la función `map()` es que a partir de una colección/arreglo de valores, se aplica una función a cada uno de ellos y se devuelve una nueva colección con los resultados. Este es un tipo de operación que surge constantemente en la práctica, por lo que tiene mucho sentido crear una abstracción para reducir la duplicación de código.

Veamos dos escenarios como ejemplo. En el primero, tenemos un arreglo de números y queremos multiplicar por dos cada uno. En el segundo, queremos el cuadrado de cada uno.

Podríamos resolver ambos casos usando un bucle for, pero nos daremos cuenta de algo...

```ts
let numbers: number[] = [1, 2, 3, 4, 5];

let doubled: number[] = [];
// Multiplicar por 2 cada numero
for (const n of numbers) {
	doubled.push(n * 2);
}

let squared: number[] = [];
// Cuadrado de cada numero
for (const n of numbers) {
	squared.push(n * n);
}
```

<img src="assets/Unidad%20III%20-%20Tipos%20Funcionales%20y%20Subtipos/image-31.png" width="570" alt="">
*Este diagrama era para un ejemplo un tanto distinto*

Aunque multiplicar por dos y sacar el cuadrado son operaciones distintas, **la estructura subyacente del proceso es idéntica**: 
- Se toma un arreglo de entrada.
- se aplica una función a cada uno de sus elementos.
- Se genera un nuevo arreglo con los resultados.

==**Pueden crear una función map() que pueda encapsular este comportamiento? (solo recibe números y retorna números)**==

**Resolución**:
```ts
function mapNumbers(items: number[], func: (n: number) => number): number[] {
	const result: number[] = [];
	for (const item of items) {
		result.push(func(item));
	}
	return result;
}

const numbers: number[] = [1, 2, 3, 4, 5];
const doubled = mapNumbers(numbers, n => n * 2);
const squared = mapNumbers(numbers, n => n * n);

console.log('numbers:', numbers); // [1, 2, 3, 4, 5]
console.log('doubled:', doubled); // [2, 4, 6, 8, 10]
console.log('squared:', squared); // [1, 4, 9, 16, 25]
```

También podemos ver un ejemplo usando **tipos genéricos**:

```ts
function map<T, U>(items: T[], func: (item: T) => U): U[] {
	let result: U[] = [];
	for (const item of items) {
		result.push(func(item));
	}
	return result;
}

let numbers: number[] = [1, 2, 3, 4, 5];
let squares: number[] = map(numbers, (item) => item * item);
let strings: string[] = ["apple", "orange", "peach"];
let lengths: number[] = map(strings, (item) => item.length);
```

La función `map()` encapsula el proceso de aplicar la función que le pasamos como argumento. 
Nosotros solo tenemos que proporcionarle un arreglo de elementos y una función, y `map()` se encarga de devolvernos el nuevo arreglo con los resultados de dicha aplicación. 

Más adelante, veremos cómo podemos llevar esta idea un paso más allá para que funcione con cualquier tipo de estructura de datos, no únicamente con arreglos. Pero incluso con la implementación actual, ya tenemos una excelente abstracción para aplicar funciones a colecciones de elementos, lo que nos permite reutilizarla en una gran variedad de situaciones.

Algo similar pasa con `filter()` y `reduce()`

### Referencias
---
[![Covariance and Contravariance — Christopher Okhravi](https://i.ytimg.com/vi/FdFBYUQCuHQ/mqdefault.jpg)](https://www.youtube.com/watch?v=FdFBYUQCuHQ)

> 🎥 Covariance and Contravariance — Christopher Okhravi

**Contravarianza**: Yo soy bartender, y en la noche de hoy solo voy a ofrecer jugo de durazno. Por lo tanto quiero una licuadora que solo licue duraznos. Lamentablemente hubo una equivocacion en el pedido a la fabrica de licuadoras, y me entregaron una licuadora que licua todas las frutas. Esto es Correcto? Si! De esto se trata al contravarianza.
**Expectativa** (el tipo requerido): Una licuadora que **como mínimo** sepa licuar duraznos. 
`(licuar: (fruta: Durazno) => Jugo)`
**Realidad** (el tipo proporcionado): Una licuadora que sabe licuar **cualquier fruta**. 
`(licuar: (fruta: Fruta) => Jugo)`

