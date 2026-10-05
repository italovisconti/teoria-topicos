*Patrón de diseño creacional que nos permite asegurarnos de que una clase tenga una única instancia, a la vez que proporciona un punto de acceso global a dicha instancia.*
#### Problema:
- **Garantizar que una clase tenga una única instancia.**
	¿Por qué querría alguien controlar cuántas instancias tiene una clase? El motivo más habitual es controlar el acceso a algún recurso compartido, por ejemplo, una base de datos o un archivo.

	Funciona así: imagina que has creado un objeto y al cabo de un tiempo decides crear otro nuevo. En lugar de recibir un objeto nuevo, obtendrás el que ya habías creado.

	Ten en cuenta que este comportamiento es imposible de implementar con un constructor normal, ya que una llamada al constructor siempre **debe** devolver un nuevo objeto por diseño.

- **Proporcionar un punto de acceso global a dicha instancia.**
	¿Recuerdas esas variables globales que utilizaste (bueno, sí, fui yo) para almacenar objetos esenciales? Aunque son muy útiles, también son poco seguras, ya que cualquier código podría sobrescribir el contenido de esas variables y descomponer la aplicación.
	
	Al igual que una variable global, el patrón Singleton nos permite acceder a un objeto desde cualquier parte del programa. No obstante, también evita que otro código sobreescriba esa instancia.
	
	Este problema tiene otra cara: no queremos que el código que resuelve el primer problema se encuentre disperso por todo el programa. Es mucho más conveniente tenerlo dentro de una clase, sobre todo si el resto del código ya depende de ella.
#### Solución:
Todas las implementaciones del patrón Singleton tienen estos dos pasos en común:

- Hacer privado el constructor por defecto para evitar que otros objetos utilicen el operador `new` con la clase Singleton.
- Crear un método de creación estático que actúe como constructor. Tras bambalinas, este método invoca al constructor privado para crear un objeto y lo guarda en un campo estático. Las siguientes llamadas a este método devuelven el objeto almacenado en caché.

Si tu código tiene acceso a la clase Singleton, podrá invocar su método estático. De esta manera, cada vez que se invoque este método, siempre se devolverá el mismo objeto.

#### Analogía en el mundo real
*La torre de control de un aeropuerto*

En cada aeropuerto hay una única torre de control que coordina despegues y aterrizajes. Y si existieran dos torres independientes, podrían dar órdenes contradictorias y provocar accidentes.

Mapeo al patrón:
- Única instancia (Singleton): una sola torre por aeropuerto.
- Punto de acceso global (getInstance): todos los aviones usan la misma frecuencia para comunicarse con esa torre.
- Estado compartido: la torre mantiene un estado único (qué pista está libre, clima, prioridades).
- Constructor privado (implícito en la analogía): no “levantas” otra torre a mitad de la operación.

Qué pasa si hubiera dos “instancias”?: Un avión recibe “autorizado a aterrizar” de una torre y “espere en patrón” de la otra, teniendo como resultado: **caos**. 

#### Estructura
![](../assets/Patrones/image-1%201.png)
La clase **Singleton** declara el método estático `obtenerInstancia` que devuelve la misma instancia de su propia clase.
El constructor del Singleton debe ocultarse del código cliente. La llamada al método `obtenerInstancia` debe ser la única manera de obtener el objeto de Singleton.
#### Ejemplo: Chocolate Boiler
Todo el mundo sabe que las fábricas modernas de chocolate tienen calderas controladas por computadora. El trabajo de la caldera es recibir chocolate y leche, llevarlos a ebullición y luego enviarlos a la siguiente fase de fabricación de tabletas. Aquí está la clase controladora de la caldera de Chocolate de *Choc-O-Holic, Inc.*, de nivel industrial. 
##### Planteamiento:
```ts
class ChocolateBoiler {
  private empty: boolean;
  private boiled: boolean;

  constructor() {
    this.empty = true;
    this.boiled = false;
  }

  fill(): void {
    if (this.isEmpty()) {
      this.empty = false;
      this.boiled = false;
      // llenar con mezcla de leche/chocolate
    }
  }

  drain(): void {
    if (!this.isEmpty() && this.isBoiled()) {
      // drenar mezcla hervida
      this.empty = true;
    }
  }

  boil(): void {
    if (!this.isEmpty() && !this.isBoiled()) {
      // hervir contenido
      this.boiled = true;
    }
  }

  isEmpty(): boolean {
    return this.empty;
  }

  isBoiled(): boolean {
    return this.boiled;
  }
}
```
##### Resuelto:
%% La idea es “asegurar una sola caldera” en toda la app. Dos instancias permitirían estados contradictorios (una cree que está vacía mientras la otra hierve), así que centralizamos el estado en un único objeto global controlado.

```ts
class ChocolateBoiler {
  private static instance: ChocolateBoiler | null = null;

  private empty: boolean;
  private boiled: boolean;

  // Constructor privado: evita nuevas instancias desde fuera
  private constructor() {
    this.empty = true;
    this.boiled = false;
  }

  // Punto de acceso global a la única instancia
  static getInstance(): ChocolateBoiler {
    if (!this.instance) {
      this.instance = new ChocolateBoiler();
    }
    return this.instance;
  }

  fill(): void {
    if (this.isEmpty()) {
      this.empty = false;
      this.boiled = false;
      // llenar con mezcla de leche/chocolate
    }
  }
  // resto del codigo...
}
``` 
%%