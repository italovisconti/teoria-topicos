*Patrón de diseño creacional que proporciona una interfaz para crear objetos en una superclase, mientras permite a las subclases alterar el tipo de objetos que se crearán.*
#### Problema:
Imagina que trabajas en el mostrador de una pizzería. Cuando un cliente pide una pizza de pepperoni, tú mismo vas a la cocina, tomas la masa, le pones salsa, queso y pepperoni. Si luego piden una de champiñones, repites el proceso con los ingredientes correctos.

**El problema es que tú, en el mostrador, necesitas saber la receta exacta de cada pizza.** Si el dueño decide añadir una pizza "Hawaiana", tienes que aprenderte la nueva receta. Tu trabajo se vuelve más complicado con cada cambio en el menú.

En términos de código, esto significa que la parte de tu programa que recibe las peticiones (el "cliente") está fuertemente **acoplada** a la lógica de creación (`new PepperoniPizza()`, `new MushroomPizza()`). Cualquier cambio en los "productos" te obliga a modificar al "cliente".

#### Solución:
El patrón Factory propone contratar a un **Chef de Pizzas (una Fábrica)** que se queda en la cocina.

Ahora, cuando un cliente pide una de pepperoni, tú ya no vas a la cocina. Simplemente le gritas al chef: "¡Una de pepperoni!". El chef es el experto: él conoce la receta y te entrega la pizza lista.

**La gran ventaja es que tu única responsabilidad es tomar el pedido y pasárselo al chef.** Si mañana se añade la pizza hawaiana, el único que necesita aprender la nueva receta es el chef. Tu trabajo en el mostrador no cambia en absoluto.

> [!TIP] Principio de Diseño
> Identifica los aspectos de tu aplicación que varían y sepáralos de lo que se mantiene igual.

En otras palabras, toma las partes que varían y **encapsúlalas**, para que luego puedas modificarlas o extenderlas sin afectar aquellas que no cambian. Tan simple como es, este concepto forma la base de casi todos los patrones de diseño. Todos los patrones permiten que una parte de un sistema cambie de forma independiente a todas las demás partes.

En código, esto significa que creas una clase `SimplePizzaFactory` que centraliza la creación de objetos. El cliente solo necesita pedirle a la fábrica el objeto que quiere, sin saber cómo se construye. Esto **desacopla** al cliente de la creación de productos, haciendo el sistema más flexible y fácil de mantener.
##### Mapeo Técnico
- **Cliente (`Client`)**: Eres tú en el mostrador, tomando el pedido.
- **Fábrica (`SimplePizzaFactory`)**: Es el _pizzaiolo_. Es el único que conoce los detalles de creación. Tiene un método como `crearPizza(tipo)`.
- **Producto (`Product`)**: Es la interfaz o clase base `Pizza`. Tú en el mostrador solo sabes que vas a recibir "una pizza", no te importa el detalle interno de sus ingredientes.
- **Productos Concretos (`ConcreteProduct`)**: Son las clases `PepperoniPizza`, `MushroomPizza`, etc. El _pizzaiolo_ es quien las instancia (`new PepperoniPizza()`).

El objetivo principal es **encapsular la lógica de creación de objetos**. El cliente se desacopla de la instanciación de las clases concretas, delegando esa responsabilidad a la fábrica. Facilitamos el mantenimiento y la extensibilidad.
#### Estructura
<img src="../assets/Patrones/image-2%201.png" width="700" alt="">

<img src="../assets/Patrones/image-4%201.png" width="700" alt="">
#### Ejemplo: Pizzeria
##### Planteamiento:
**Paso 1**: orderPizza crea una Pizza concreta y la procesa.
```ts
class Pizza {
  prepare() { console.log("Preparing dough, sauce, toppings..."); }
  bake()    { console.log("Baking at 350°F for 25 minutes"); }
  cut()     { console.log("Cutting the pizza into slices"); }
  box()     { console.log("Boxing the pizza"); }
}

function orderPizza(): Pizza {
  const pizza = new Pizza();
  
  pizza.prepare();
  pizza.bake();
  pizza.cut();
  pizza.box();
  return pizza;
}

// Ejemplo
orderPizza();
```
*Pero queremos más tipos de pizza...*

Paso 2: Ahora pizza es una interfaz, añadimos tipos concretos y lógica condicional para instanciarlos. El cliente (orderPizza) queda acoplado a las clases concretas.
```ts
interface Pizza {
  prepare(): void;
  bake(): void;
  cut(): void;
  box(): void;
}

class CheesePizza implements Pizza { /* Implementaciones */ }
class GreekPizza implements Pizza { /* Implementaciones */ }
class PepperoniPizza implements Pizza { /* Implementaciones */ }

function orderPizza(type: String): Pizza {
  let pizza: Pizza;

  if (type === "cheese") {
    pizza = new CheesePizza();
  } else if (type === "greek") {
    pizza = new GreekPizza();
  } else if (type === "pepperoni") {
    pizza = new PepperoniPizza();
  } else {
    throw new Error("Unknown pizza type");
  }

  pizza.prepare();
  pizza.bake();
  pizza.cut();
  pizza.box();
  return pizza;
}

// Ejemplo
orderPizza("cheese");
```
*Pero ahora cambian las pizzas del menu*

**Paso 3**: `Crecen las variantes (clam, veggie) y se elimina greek. if-else escala mal: cada cambio de menú obliga a editar orderPizza.`
```ts
// Nuevas clases de pizzas...

function orderPizza(type: String): Pizza {
  let pizza: Pizza;

  if (type === "cheese") {
    pizza = new CheesePizza();
  } else if (type === "pepperoni") {
    pizza = new PepperoniPizza();
  } else if (type === "clam") {
    pizza = new ClamPizza();
  } else if (type === "veggie") {
    pizza = new VeggiePizza();
  } else {
    throw new Error("Unknown pizza type");
  }

  pizza.prepare();
  pizza.bake();
  pizza.cut();
  pizza.box();
  return pizza;
}

// Ejemplo
orderPizza("veggie");
```
*Tener que lidiar con que clase concreta instanciamos (que pizza) esta haciendo que orderPizza sufra muchos cambios y ya no esta "Cerrada para Modificacion". Pero sabemos que pieza del código es la culpable de estas modificaciones, y debemos encapsular!*
##### Resuelto:
Encapsulamos al culpable de estas modificaciones mediante una **Fabrica**.
La función de `orderPizza()` debe ser un método de una clase `PizzaStore`

%% 
```ts
// clases de pizzas...

class SimplePizzaFactory {
  createPizza(type: String): Pizza {
    switch (type) {
      case "cheese":    return new CheesePizza();
      case "pepperoni": return new PepperoniPizza();
      case "clam":      return new ClamPizza();
      case "veggie":    return new VeggiePizza();
      default:
        throw new Error(`Unknown pizza type: ${type}`);
    }
  }
}

class PizzaStore {
	let factory: SimplePizzaFactory
	
	constructor(SimplePizzaFactory factory) {
	  this.factory = factory
	}
	
	function orderPizza(type: String): Pizza {
	  let pizza: Pizza;
	  
	  pizza = factory.createPizza(type)
	  
	  pizza.prepare();
	  pizza.bake();
	  pizza.cut();
	  pizza.box();
	
	  return pizza;
	}
}
```
 %%