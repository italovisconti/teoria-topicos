*Patrón estructural que te permite añadir funcionalidades a objetos colocando estos objetos dentro de objetos encapsuladores especiales que contienen estas funcionalidades.*
*Patrón estructural que permite agregar comportamientos adicionales a un objeto de forma dinámica, sin modificar su clase original ni afectar a otros objetos de la misma clase.*
*Permite extender la funcionalidad de un objeto "envolviéndolo" con otros objetos que agregan nuevas características, como capas que se van apilando una sobre otra.*

Café simple → Le agregas leche (decorador) → Le agregas azúcar (otro decorador)

<img src="../assets/Patrones/image-15%201.png" width="600" alt="">

Reexaminaremos el típico uso excesivo de la herencia y aprenderemos cómo "decorar" clases en tiempo de ejecución usando una forma de composición de objetos. ¿Por qué? Una vez que conozcamos las técnicas de decoración, serás capaz de dar a tus objetos (o a los de alguien más) nuevas responsabilidades sin hacer ningún cambio en el código de las clases subyacentes.

Ya no estamos hablando de cambiar comportamientos como en el caso de **Strategy**, ahora estamos hablando de **agregar o extender comportamientos**.

Páramo cafe ha crecido mucho en Venezuela, y como ya saben ha crecido de manera muy rápida, pero el equipo técnico esta sufriendo al actualizar su sistema de pedidos para que coincidan con su oferta de bebidas. 

Cuando recién comenzaron su negocio, diseñaron sus clases de esta manera...

<img src="../assets/Patrones/image-1%201.png" width="700" alt="">

| Ubicación del Comentario                   | Comentario Original (Inglés)                                                                                                                                                              | Traducción al Español                                                                                                                                                                                    |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Apuntando a la clase Beverage              | Beverage is an abstract class, subclassed by all beverages offered in the coffee shop.                                                                                                    | **Beverage (Bebida) es una clase abstracta, de la cual se crean subclases para todas las bebidas ofrecidas en la cafetería.**                                                                            |
| Apuntando a description y getDescription() | The description instance variable is set in each subclass and holds a description of the beverage, like "Most Excellent Dark Roast". The getDescription() method returns the description. | **La variable de instancia description se establece en cada subclase y contiene una descripción de la bebida, como "Tostado Oscuro Muy Excelente". El método getDescription() devuelve la descripción.** |
| Apuntando a cost()                         | The cost() method is abstract; subclasses need to define their own implementation.                                                                                                        | **El método cost() es abstracto; las subclases deben definir su propia implementación.**                                                                                                                 |
| Apuntando a las subclases                  | Each subclass implements cost() to return the cost of the beverage.                                                                                                                       | **Cada subclase implementa cost() para devolver el costo de la bebida.**                                                                                                                                 |

Aparte de tu café, también puedes pedir varios complementos o condimentos, como leche de vaca, leche de soya y chocolate, y rematarlo todo con crema batida. Como paramo cobra un extra por cada complemento, necesitan urgentemente integrarlos a su sistema de pedidos.

**Aquí está el primer intento**:

<img src="../assets/Patrones/image-2%201.png" width="700" alt="">
Cada método `cost` calcula el costo del café junto con los otros condimentos en el pedido.

Es bastante obvio que Páramo ha creado una pesadilla de mantenimiento para sí mismos. **¿Qué pasa cuando el precio de la leche sube?** **¿Qué hacen cuando añaden una nueva cobertura de caramelo?** 

🤔 😐

Esto es estúpido; ¿por qué necesitamos todas estas clases? ¿No podemos simplemente usar variables y herencia en la superclase para llevar un registro de los condimentos?

<img src="../assets/Patrones/image-3%201.png" width="700" alt="">

**Nuevos valores booleanos para cada condimento.**
**Estos obtienen y establecen los valores booleanos para los condimentos.** (Es decir, son los métodos getters y setters).
Ahora implementaremos `cost()` en Beverage (en lugar de mantenerlo abstracto), para que pueda calcular los costos asociados con los condimentos para una instancia de bebida en particular. Las subclases seguirán sobrescribiendo `cost()`, pero también invocarán la versión de la superclase para que puedan calcular el costo total de la bebida básica más los costos de los condimentos añadidos.

Ahora agregamos las subclases:

<img src="../assets/Patrones/image-4%201.png" width="700" alt="">

El `cost()` de la superclase calculará los costos de todos los condimentos, mientras que el `cost()` sobrescrito en las subclases extenderá esa funcionalidad para incluir los costos de ese tipo de bebida específica.
Cada método `cost()` necesita calcular el costo de la bebida y luego sumar los condimentos llamando a la implementación de `cost()` de la superclase.


#### Ejercicio
Define los métodos `cost()`

```ts
abstract class Beverage {
  cost(): number {
    // ... //
  }
}

class DarkRoast extends Beverage {
  constructor() {
    super();
    this.description = "Tostado Oscuro de Calidad";
  }

  cost(): number {
    // ... //
  }
}
```

**Solución**:

```ts
class Beverage {
  // Variables de costos
  public milkCost: number = 0.10;
  public soyCost: number = 0.15;
  // mas...
  
  // Variables booleanas...
  // getters y setters...

  // Método que calcula el costo total de los condimentos
  public cost(): number {
    let condimentCost: number = 0.0;
    
    if (this.hasMilk()) {
      condimentCost += this.milkCost;
    }
    if (this.hasSoy()) {
      condimentCost += this.soyCost;
    }
    if (this.hasMocha()) {
      condimentCost += this.mochaCost;
    }
    if (this.hasWhip()) {
      condimentCost += this.whipCost;
    }
    return condimentCost;
  }
}

class DarkRoast extends Beverage {
  public DarkRoast() {
    this.description = "Tostado Oscuro de Calidad";
  }

  // Sobrescribe el método cost
  public cost(): number {
    // El costo base se suma al costo de los condimentos calculado por la superclase
    return 1.99 + super.cost();
  }
}
```

*Seguro ya lo sabias...*
Esta implementacion nos puede traer muchos problemas a futuro:

- Los cambios de precio en los condimentos nos obligarán a modificar código existente.
- Los nuevos condimentos nos obligarán a agregar nuevos métodos y a modificar el método `cost()` en la superclase.
- Podemos tener nuevas bebidas. Para algunas de estas bebidas (¿té helado?), los condimentos pueden no ser apropiados, sin embargo, la subclase `Tea` seguirá heredando métodos como `hasWhip()`.
- ¿Qué pasa si un cliente quiere un doble moca?

**Alguna otra?**

---
#### **El guru y el estudiante:**
**Gurú:** Ha pasado algún tiempo desde nuestro último encuentro. ¿Has estado en profunda meditación sobre la herencia?

**Estudiante:** Sí, Gurú. Si bien la herencia es poderosa, he aprendido que no siempre conduce a los diseños más flexibles o fáciles de mantener.

**Gurú:** Ah, sí, has progresado. Entonces, dime, mi estudiante, ¿cómo lograrás la reutilización si no es a través de la herencia?

**Estudiante:** Gurú, he aprendido que hay maneras de "heredar" comportamiento en tiempo de ejecución a través de la **composición** y la **delegación**.

**Gurú:** Por favor, continúa...

**Estudiante:** Cuando heredo comportamiento mediante la creación de subclases, ese comportamiento se establece estáticamente en tiempo de compilación. Además, todas las subclases deben heredar el mismo comportamiento. Sin embargo, si puedo extender el comportamiento de un objeto mediante la composición, puedo hacerlo dinámicamente en tiempo de ejecución.

**Gurú:** Muy bien; estás empezando a ver el poder de la composición.

**Estudiante:** Sí, es posible para mí añadir múltiples nuevas responsabilidades a los objetos a través de esta técnica, incluidas responsabilidades en las que ni siquiera pensó el diseñador de la superclase. ¡Y no tengo que tocar su código!

**Gurú:** ¿Qué has aprendido sobre el efecto de la composición en el mantenimiento de tu código?

**Estudiante:** Bueno, a eso me refería. Al componer objetos dinámicamente, puedo añadir nueva funcionalidad escribiendo código nuevo en lugar de modificar código existente. Debido a que no estoy cambiando el código ya existente, las posibilidades de introducir errores o causar efectos secundarios no deseados en código preexistente se reducen considerablemente.

**Gurú:** Muy bien. Suficiente por hoy. Quiero que vayas y medites más sobre este tema... Recuerda, **el código debe estar cerrado (a la modificación) como la flor de loto por la tarde, pero abierto (a la extensión) como la flor de loto por la mañana.**

<img src="../assets/Patrones/image-5%201.png" width="499" alt="">

**Nuestro objetivo es permitir que las clases sean fácilmente extensibles para incorporar nuevo comportamiento sin necesidad de modificar el código existente.**
**¿Qué obtenemos si logramos esto? Diseños que son resistentes al cambio y lo suficientemente flexibles como para incorporar nueva funcionalidad para satisfacer requisitos cambiantes.**

Si bien puede parecer una contradicción, existen técnicas que permiten que el código sea extendido sin modificarlo directamente.
Sin embargo, debes ser cauteloso al elegir las áreas del código que necesitan ser extendidas; aplicar el Principio Abierto/Cerrado en **TODAS PARTES** es ineficiente e innecesario, y puede conducir a un código complejo y difícil de entender.


Y así es que presentamos a nuestro patron, **el patron decorador**.
#### Patron decorador en acción

Así que, aquí está lo que haremos en su lugar: comenzaremos con una bebida y la "*decoraremos*" con los condimentos en tiempo de ejecución. **Por ejemplo**, si el cliente quiere un **Tostado Oscuro con Moca** y **Crema Batida**, entonces haremos lo siguiente:

1. Comenzar con un objeto **DarkRoast** (Tostado Oscuro).
2. Decorarlo con un objeto **Mocha** (Moca).
3. Decorarlo con un objeto **Whip** (Crema Batida).
4. Llamar al método `cost()` y depender de la delegación para sumar los costos de los condimentos.

Bien, pero ¿cómo se "*decora*" un objeto y cómo entra en juego la **delegación**? Una pista: piensa en los **objetos decoradores** como "*envoltorios*" (**wrappers**). Veamos cómo funciona esto...

1. Comenzamos con nuestro objeto **DarkRoast**.

<img src="../assets/Patrones/image-6%201.png" width="629" alt="">
Recuerda que DarkRoast hereda de Beverage y tiene un método cost() que calcula el costo de la bebida.

2. El cliente quiere **Moca**, así que creamos un objeto **Mocha** y lo envolvemos alrededor del **DarkRoast**.

<img src="../assets/Patrones/image-7%201.png" width="700" alt="">
El objeto Mocha es un decorador. Su tipo imita (refleja) al objeto que está decorando; en este caso, una Beverage (Bebida). (Con "imita", nos referimos a que es del mismo tipo.)
Entonces, Mocha también tiene un método cost(), y a través del polimorfismo podemos tratar cualquier Beverage envuelta en Mocha como si fuera una Beverage también (porque Mocha es un subtipo de Beverage).

3. El cliente también quiere **Crema Batida**, así que creamos un decorador **Whip** (Crema Batida) y envolvemos el **Mocha** con él.

<img src="../assets/Patrones/image-8%201.png" width="700" alt="">
Whip (Crema Batida) es un decorador, por lo que también imita (refleja) el tipo de DarkRoast e incluye un método cost().
Por lo tanto, un DarkRoast envuelto en Mocha y Whip sigue siendo una Beverage (Bebida) y podemos hacer cualquier cosa con él que haríamos con un DarkRoast, incluyendo llamar a su método cost().

4. Ahora es el momento de calcular el costo para el cliente. Hacemos esto llamando al método `cost()` en el decorador más externo, que es **Whip**. Whip va a delegar el cálculo del costo al objeto que decora. Y así sucesivamente.

<img src="../assets/Patrones/image-9%201.png" width="700" alt="">

| Paso      | Comentario Original (Inglés)                                                                   | Traducción al Español                                                                                    |
| --------- | ---------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| **Pista** | (You’ll see how in a few pages.)                                                               | **(Verás cómo funciona en unas pocas páginas.)**                                                         |
| **1**     | First, we call cost() on the outermost decorator, Whip.                                        | **Primero, llamamos a cost() en el decorador más externo, Whip (Crema Batida).**                         |
| **2**     | Whip calls cost() on Mocha.                                                                    | **Whip llama a cost() en Mocha.**                                                                        |
| **3**     | Mocha calls cost() on DarkRoast.                                                               | **Mocha llama a cost() en DarkRoast (Tostado Oscuro).**                                                  |
| **4**     | DarkRoast returns its cost, 99 cents.                                                          | **DarkRoast devuelve su costo, 99 centavos.**                                                            |
| **5**     | Mocha adds its cost, 20 cents, to the result from DarkRoast, and returns the new total, $1.19. | **Mocha añade su costo, 20 centavos, al resultado de DarkRoast, y devuelve el nuevo total, $1.19.**      |
| **6**     | Whip adds its total, 10 cents, to the result from Mocha, and returns the final result, $1.29.  | **Whip añade su costo total, 10 centavos, al resultado de Mocha, y devuelve el resultado final, $1.29.** |

**Esto es lo que sabemos hasta ahora sobre los decoradores**

- Los Decoradores tienen el mismo supertipo que los objetos que decoran.
- Puedes usar uno o más decoradores para envolver un objeto.
- Dado que el decorador tiene el mismo supertipo que el objeto que decora, podemos pasar un objeto decorado en lugar del objeto original.
- **El decorador añade su propio comportamiento antes y/o después de delegar al objeto que decora para que realice el resto del trabajo.**
- Los objetos pueden ser decorados en cualquier momento, por lo que podemos decorarlos dinámicamente en tiempo de ejecución con tantos decoradores como queramos.

#### Definición
El **Patrón Decorador** asigna responsabilidades adicionales a un objeto de forma dinámica.
Los Decoradores proporcionan una alternativa flexible a la creación de subclases para extender la funcionalidad.

#### Diagrama de Clases

<img src="../assets/Patrones/image-10%201.png" width="700" alt="">
(Se parece un poco al **patron Composite**)

| Ubicación del Comentario             | Comentario Original                                                                                                                                | Traducción al Español                                                                                                                                                                    |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Sobre ConcreteComponent              | The ConcreteComponent is the object we’re going to dynamically add new behavior to. It extends Component.                                          | **El ConcreteComponent es el objeto al que vamos a añadirle nuevo comportamiento dinámicamente. Extiende a Component.**                                                                  |
| Sobre la clase Component             | Each component can be used on its own or wrapped by a decorator.                                                                                   | **Cada componente puede usarse por sí mismo o envuelto por un decorador.**                                                                                                               |
| Apuntando al Decorator               | Each decorator HAS-A (wraps) a component, which means the decorator has an instance variable that holds a reference to a component.                | **Cada decorador TIENE UN (HAS-A) componente (lo envuelve), lo que significa que el decorador tiene una variable de instancia que mantiene una referencia a un componente.**             |
| Apuntando a la herencia de Decorator | Decorators implement the same interface or abstract class as the component they are going to decorate.                                             | **Los decoradores implementan la misma interfaz o clase abstracta que el componente que van a decorar.**                                                                                 |
| Apuntando al ConcreteDecoratorA      | The ConcreteDecorator inherits (from the Decorator class) an instance variable for the thing it decorates (the Component the Decorator wraps).     | **El ConcreteDecorator hereda (de la clase Decorator) una variable de instancia para el elemento que decora (el Componente que el Decorador envuelve).**                                 |
| Apuntando a ConcreteDB               | Decorators can extend the state of the component.                                                                                                  | **Los decoradores pueden extender el estado del componente.**                                                                                                                            |
| Apuntando a ConcrDA y ConcrDB        | Decorators can add new methods; however, new behavior is typically added by doing computation before or after an existing method in the component. | **Los decoradores pueden añadir nuevos métodos; sin embargo, el nuevo comportamiento se añade típicamente realizando cálculos antes o después de un método existente en el componente.** |

#### Decorando Páramo...

<img src="../assets/Patrones/image-11%201.png" width="700" alt="">

| Ubicación del Comentario                                      | Comentario Original (Inglés)                                                                                                                 | Traducción al Español                                                                                                                                                |
| ------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Apuntando a la clase Beverage                                 | Beverage acts as our abstract component class.                                                                                               | **Beverage (Bebida) actúa como nuestra clase de componente abstracta.**                                                                                              |
| Apuntando a HouseBlend, DarkRoast, etc.                       | The four concrete components, one per coffee type.                                                                                           | **Los cuatro componentes concretos, uno por cada tipo de café.**                                                                                                     |
| Apuntando a la variable beverage dentro de CondimentDecorator | Here’s the reference to the Beverage that the Decorators will be wrapping.                                                                   | **Aquí está la referencia a la Beverage (Bebida) que los Decoradores van a envolver.**                                                                               |
| Apuntando a los condimentos                                   | And here are our condiment decorators; notice they need to implement not only cost() but also getDescription(). We’ll see why in a moment... | **Y aquí están nuestros decoradores de condimentos; noten que necesitan implementar no solo cost() sino también getDescription(). Veremos por qué en un momento...** |

Es importante destacar que acá estamos usando la **herencia** para lograr la **coincidencia de tipos**, pero **no** estamos usando la **herencia** para obtener el **comportamiento**.

Cuando componemos un decorador con un componente, estamos añadiendo nuevo comportamiento. Estamos adquiriendo nuevo comportamiento **no por heredarlo de una superclase, sino por componer objetos entre sí.**

#### Ejercicio

Nos llega una orden de “*double mocha soy latte with whip*”, ve la lista de precios y dibuja ese objeto como lo hicimos anteriormente:

Precios:
<img src="../assets/Patrones/image-12%201.png" width="257" alt="">

<img src="../assets/Patrones/image-13%201.png" width="525" alt="">


#### Arreglemos Páramo

Empezamos por la clase `Beverage` y el decorador `CondimentDecorator`

```ts
abstract class Beverage {
  description: string = "Bebida Desconocida";

  //getDescription ya está implementado, falta implementar cost() en las subclases.
  public getDescription(): string {
    return this.description;
  }

  abstract cost(): number;
}

// Necesitamos que sea intercambiable con Beverage, por eso la extendemos
abstract class CondimentDecorator extends Beverage {
  // Beverage que cada Decorador va a envolver. El decorador puede envolver cualquier bebida.
  protected beverage!: Beverage;

  // Re-declaramos getDescription como abstracto para FORZAR a las subclases (los condimentos concretos) a implementar este método.
  public abstract getDescription(): string;

  // El método abstracto cost() se hereda de Beverage y no necesita ser re-declarado aquí.
}
```

Ahora, vamos con las bebidas.

```ts
// Extendemos la clase abstracta Beverage
class Espresso extends Beverage {
  constructor() {
    super();
    this.description = "Espresso";
  }

  // Sencillamente retornamos el costo
  public cost(): number {
    return 1.99;
  }
}

class HouseBlend extends Beverage {
  constructor() {
    this.description = "Café de la Casa";
  }

  public cost(): number {
    return 0.89;
  }
}
```

Y lo mas importante, los condimentos.

```ts
// Mocha es un decorador, asi que extendemos CondimentDecorator
class Mocha extends CondimentDecorator {

  // El constructor toma la bebida que se va a envolver.
  constructor(beverage: Beverage) {
    super();
    this.beverage = beverage;
  }

  public getDescription(): string {
    // Delega a la bebida envuelta y añade la descripción de este condimento.
    return this.beverage.getDescription() + ", Mocha";
  }

  public cost(): number {
    // Delega a la bebida envuelta para obtener su costo y luego añade el costo de este condimento.
    return this.beverage.cost() + 0.20;
  }
}
```

Queremos que nuestra descripción incluya no solo la bebida —digamos “Tostado Oscuro”— sino también cada elemento que la decora (por ejemplo, “Tostado Oscuro, Mocha”). Así que primero delegamos en el objeto que estamos decorando para obtener su descripción, y luego añadimos “, Mocha” a esa descripción.

Ahora necesitamos calcular el costo de nuestra bebida con Mocha. Primero, delegamos la llamada al objeto que estamos decorando para que pueda calcular su costo; luego, añadimos el costo del Mocha al resultado.`

```ts
// Espresso sin condimentos
let beverage1: Beverage = new Espresso();
console.log(`${beverage1.getDescription()} ${beverage1.cost()}$`);

// DarkRoast con doble moca y crema batida
let beverage2: Beverage = new DarkRoast();
beverage2 = new Mocha(beverage2);
beverage2 = new Mocha(beverage2);
beverage2 = new Whip(beverage2);
console.log(beverage2.getDescription()); 
console.log(beverage2.cost() + "$");

// HouseBlend con Soya, Moca y Crema Batida.
let beverage3: Beverage = new HouseBlend();
beverage3 = new Soy(beverage3);
beverage3 = new Mocha(beverage3);
beverage3 = new Whip(beverage3);
console.log(`${beverage3.getDescription()} ${beverage3.cost()}$`);
```

<img src="../assets/Patrones/image-14%201.png" width="638" alt="">


