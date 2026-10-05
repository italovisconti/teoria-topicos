> [!NOTE] Referencias
> Riscutia, 2020 - Capítulos 1 y 2 
> Vanderkam, 2020 - Capítulos 2, 3 y 4 
> Freeman, 2021 - Capítulos 8, 9, 10 y 11
### Tema 1 — Tipos de paradigmas

Existen muchos tipos de paradigmas de programación, y es muy fácil confundir los paradigmas con los lenguajes de programación.

Por un lado, los ==lenguajes de programación== se utilizan para **“enseñar” a las computadoras a realizar diferentes tareas y acciones**, tal cual como los lenguajes que usamos para comunicarnos entre nosotros. Los lenguajes también tienen sus propios vocabularios y reglas gramaticales para desarrollar estas instrucciones.

Mientras que, los ==paradigmas== son **modelos de escritura de código que se pueden aplicar a varios lenguajes** (se podría decir que es un estilo de programar). Incluso es posible utilizar más de un paradigma para la misma solución en el mismo lenguaje. Los paradigmas pueden entenderse como **un estilo o metodología de programación, que apuntan a la mejor manera de resolver problemas**.

Pero algo a tener en cuenta es que los lenguajes de programación tienden a encajar en paradigmas específicos. Es decir, no hay un lenguaje que optimice todos los paradigmas a la vez. Muchos son multiparadigma (TypeScript, Python, C#), pero cada uno favorece ciertos estilos con menos fricción y mejores garantías.

La lógica detrás de los paradigmas de programación se parece mucho a la época en donde estudiábamos *"que es un algoritmo"* y la *"eficiencia"* de los mismos. Ahora sabemos que los algoritmos son **una secuencia finita de instrucciones, cada una de las cuales tiene un significado preciso y puede ejecutarse con una cantidad finita de esfuerzo en un tiempo finito.** Y podemos agregarle una capa mas de complejidad gracias a los paradigmas de programación.

**Antes**:
<img src="assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/Pasted%20image%2020250909171743.png" width="394" height="168" alt="">

**Ahora**:
<img src="assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/Pasted%20image%2020250909171905.png" width="522" height="176" alt="">

Aprender paradigmas te da **técnicas transferibles**. Lo que aprendes resolviendo problemas en un estilo, puedes “embeberlo” en tu stack principal cuando lo necesites. No tienes que escribir “todo” en Haskell para capturar valor. Paradigmas son, sobre todo, **lentes**: otra forma de mirar el mismo problema.

<img src="assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/Pasted%20image%2020250909184838.png" width="271" height="252" alt="">

Un paradigma viene definido por muchísimas cosas, como por ejemplo:

- **Modelo de ejecución del programa:** ¿Permite tener efectos colaterales o no? Es decir, si las funciones pueden modificar datos fuera de su propio ámbito (modificar un estado global o un argumento de entrada) además de devolver un resultado.
- **Sintaxis:** ¿Cómo se escribe el código? ¿Qué palabras clave, símbolos y reglas gramaticales se utilizan para construir programas? Por ejemplo, la sintaxis de Python, que usa indentación, es muy diferente a la de Java o C++, que usan llaves `{}`.
- **Manejo del Estado:** ¿Cómo se gestiona el estado de la aplicación? ¿Los datos son **inmutables** (no pueden cambiar una vez creados), como se prefiere en la programación funcional, o **mutables** (pueden cambiar en cualquier momento), como es común en la programación imperativa?
- **Abstracción y Encapsulamiento:** ¿Qué herramientas ofrece el paradigma para ocultar la complejidad?
- **Sistema de Tipos (Typing):** ¿Cómo se manejan los tipos de datos?
    - **Estático vs. Dinámico:** ¿Se comprueban los tipos en tiempo de compilación (estático, como en Java o C#) o en tiempo de ejecución (dinámico, como en Python o JavaScript)?
    - **Fuerte vs. Débil:** ¿Cuán estricto es el sistema con las conversiones de tipo? Un tipado fuerte (como en Python) previene operaciones entre tipos incompatibles (ej. `"hola" + 5`), mientras que uno débil (como en JavaScript) intentará hacer una conversión (`"5" + 5` resulta en `"55"`).

### Tema 2 — Imperativo

**Definición**:
**Secuencia de instrucciones que se ejecutan en orden**. 
Es el **paradigma clásico**. Si te preguntan qué es un lenguaje de programación, es probable que la definición que des corresponda al paradigma imperativo.
**Ejemplos de lenguajes**: C, C++, Java, Python

Lo más importante del paradigma imperativo es el concepto de **estado**. Un programa imperativo tiene un estado (el conjunto de valores de todas sus variables en un momento dado) y consiste en una serie de comandos que **mutan ese estado** paso a paso para llegar al resultado final.

![](assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/imperativo.png)
##### **Paradigma Procedural (Variación del Imperativo)**
El lenguaje **procedural** es como una **variación o "hijo" del imperativo**.
- No solo son procesos uno tras otro, sino que estos bloques de procesos se pueden **englobar en funciones**, y estas funciones, a su vez, pueden **llamar a otras funciones**.
- Los subprocesos pasan de ser elementos básicos (como una suma terminal) a ser funciones que llaman a otras funciones, combinando sus resultados para dar un resultado final en pantalla.
### Tema 4 — Declarativo

**Definición**:
El programador **no define cómo se hacen las cosas** (como en los lenguajes imperativos), sino que **define qué se hace**. Le dices al chef lo que quieres, y el se encarga de prepararlo.
Expresiones en ves de sentencias.
- Una **sentencia** es una acción que se ejecuta. No devuelve un valor. En imperativo, un programa es una secuencia de sentencias que cambian el estado global.    
    - Ej: `for`, `if`, `let x = 5;` (en muchos contextos, la asignación es una sentencia).
- Una **expresión** es una pieza de código que se evalúa y **produce un valor**. En el mundo declarativo, los programas se construyen componiendo expresiones.
    - Ej: `2 + 3` (se evalúa a `5`), `miFuncion(x)` (se evalúa al valor que retorna la función), `x > 5` (se evalúa a `true` o `false`).
    
	![](assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/Declarativo.png)

El mejor **ejemplo**, SQL.
- Tú no defines cómo se accede a la tabla ni el orden en que se deben hacer los cálculos para obtener un resultado.
- Tú defines **qué quieres obtener** (por ejemplo, "quiero obtener estas columnas de esta tabla").
- El motor de bases de datos interpreta lo que quieres hacer y ejecuta los procesos necesarios.
### Tema 3 — Funcional

**Definición**:
**Ninguna función puede modificar el estado de la aplicación**, por lo tanto, el programa es un **conjunto de funciones que al final devuelven un cálculo o un resultado**. 
Este paradigma es considerado como **declarativo**.

En los paradigmas puramente funcionales, las funciones se conocen como **funciones puras**, y se caracterizan por:
1. No modifican el estado del programa.
2. Siempre devuelven el mismo valor dada la misma entrada.

*?Que les hace pensar esto?*

Estas características hacen que el paradigma funcional se base fuertemente en la **recursion**. Ademas de esto, es **fácil de debuggear**.

**Ejemplo de Función Pura vs. No Pura**:
- La función `random` **no sería una función pura** porque, dada la misma entrada, puede devolver un número diferente cada vez.
- La función `suma(a, b)` **sería una función pura** (siempre que no modifique variables estáticas o globales) porque, dados los mismos `a` y `b`, siempre devolverá el mismo resultado.

Hoy en día, muchos lenguajes modernos (que seguro usan diariamente) como **Python o JavaScript** están incorporan **muchos elementos de programación funcional**.
Un **ejemplo** claro es la función `map`, que es una versión de una función de alto nivel que se encuentra en Haskell o en otros lenguajes funcionales, y que básicamente aplica una función a los elementos de una lista.

Aquí es donde podemos ver claramente las **características propias del paradigma funcional**:
- **Función de Orden Superior**: `map` es una función de orden superior porque toma otra función como argumento.
- **Inmutabilidad**: Cuando se usa correctamente en un contexto funcional, `map` no modifica la estructura de datos original. En su lugar, aplica una función dada a cada elemento de una colección y devuelve una **nueva colección** con los elementos transformados.
- **Ausencia de Efectos Colaterales**: Una implementación pura de `map`, cuando se le proporciona una función pura como argumento, no producirá ningún efecto colateral. Solo transforma datos y devuelve un nuevo valor, sin alterar ningún estado externo.
- **Estilo Declarativo**: `map` promueve un estilo de programación declarativo. En lugar de instruir explícitamente al programa "cómo" iterar y transformar elementos (como en un bucle tradicional), tú declaras "qué" transformación debe ocurrir para cada elemento.

**Lambdas (funciones anónimas / arrow functions)**

- **¿Qué son?**:  
    Las lambdas son funciones que normalmente se definen “en línea” sin nombre. En JS/TS se usan mucho como callbacks y como argumento de funciones de orden superior (por ejemplo map, filter, reduce).

- **Sintaxis básica (TypeScript)**:
    - Parámetro simple y retorno implícito: `(x: number) => x * 2`
    - Múltiples parámetros: `(a: number, b: number) => a + b`
    - Cuerpo con varias líneas: `(x: number) => { const r = x * 2; return r; }`
    - Con tipos: `(s: string): number => s.length`

- **Propiedades importantes**:    
    - Son concisas y se usan inline.
    - Las arrow functions no tienen su propio this/arguments (útil para evitar rebinds).
    - Pueden ser puras o impuras, dependiendo de si usan o modifican estado externo.
    - Permiten crear closures: funciones que “recuerdan” variables del contexto donde se crearon.

Se dan cuenta? Estoy seguro que esta no es la primera vez que ven este tipo de funciones.

Mientras que en la programación imperativa tienes:
```java
var array= [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

 for(let i= 0; i < array.length; i++) {
     array[i]=Math.pow(array[i], 2);
  }
  
array; //-> [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
```

En la programación funcional tienes:
```ts
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map((i)=>i*i)
```

(Tenemos una composicion de funciones)

**Ejercicios**: 
- Crear el Map desde cero en TS.
### Tema 5 — Reactivo

**Definición**:
Es un paradigma de programación asíncrona que gira alrededor de los flujos de datos y la propagación de cambios

**El manifiesto de Sistemas Reactivos**: Queremos sistemas responsivos, Elásticos y Orientados a Mensajes.

**Un ejemplo** de esto son las celdas de excel que se calculan en base a otras, notas cómo cuando actualizamos el dato de una celda, el de la otra se actualiza automáticamente, luego por supuesto de ejecutar las operaciones deseadas, ese es el concepto abstracto de programación reactiva.

Como podemos ver, hay algunos tipos de datos que representan un dato a través del tiempo, esto quiere decir que esta referencia se mantiene actualizada, por lo tanto, “reacciona”.

**Otro ejemplo** que se muestra mucho es:

```
x = <mouse-x>;
y = <mouse-y>;
```

En este caso, las referencias mouse-x y mouse-y son una representación de las coordenadas del mouse a través del tiempo, lo que quiere decir que estos datos se mantienen actualizados sin que nosotros lo hagamos, siempre mantendrán el valor que se emita del mouse.

**Programación Tradicional vs Programación Reactiva**

Ahora tenemos `a = x + y`

que pasaría 

En un paradigma tradicional, `a` es la suma de `x + y`, en el momento en el que se realiza la operación, si posteriormente modificamos x o modificamos y. A no se vería afectado. **En programación reactiva**, en cambio, las modificaciones hacia `x` o `y`, pudieran significar que `a` debe **recalcular** su valor, como las celdas de Excel que si modificamos un valor con el que están sincronizadas, la celda se **recalcula**.

**Y saben en que casos esto es muy util? Cuando debemos reaccionar a distintas interacciones.**
Por eso este paradigma resulta especialmente útil en interfaces de usuario y sistemas en tiempo real: por ejemplo:
- UIs (React, Vue).
- Dashboards que muestran datos en vivo.
- Chats.
- Telemetría/IoT. 

**En React**, por ejemplo, cuando actualizas el estado de un componente `(useState / setState)` la interfaz se re-renderiza automáticamente para reflejar ese nuevo estado; ahí ves la idea reactiva aplicada: declaras cómo debe lucir la UI en función del estado y el framework se encarga de propagar los cambios.

Pero con cuidado, que esto se puede complicar...
### Tema 6 — Orientado a objetos

**Definición**:
La orientación a objetos concibe el sistema como un conjunto de entidades (los objetos) que modelan elementos del mundo real; cada objeto encapsula su información y su comportamiento, y cooperan entre sí enviándose mensajes para conseguir un objetivo común.

**Esto pretende**:
- Construir componentes de software que sean re utilizables.
- Diseñar soluciones de manera que puedan ser extendidas y modificadas con el mínimo impacto en el resto de su estructura.

**Todo objeto tiene, dispone o conoce**:
1. **Un estado interno**, conformado por atributos o variables de instancia que describen como es la entidad y que contienen los valores que representan su información.
2. **El comportamiento** (es el que), que consiste en el conjunto de mensajes que puede recibir, lo que se corresponde con las acciones o funcionalidades que puede realizar la entidad. 
3. **Métodos** (es el como). Los métodos corresponden a las implementaciones de los comportamientos de los objetos. Los métodos se ejecutan en respuesta a un mensaje 
4. Todo objeto posee una **identidad**.

**Ejemplo**: 
	Imaginemos un **carro** que tiene funciones como `acelerar`, `frenar` y `girar`.
	Estas funciones modifican su propio estado: su velocidad, su ángulo de giro, su posición. Pero, el carro no puede modificar cosas como por ejemplo, el **clima**. El clima, a su vez, puede tener la función `llover`, que causa rayos, truenos y agua que inunda una carretera, lo cual afectaría al objeto `carro`, pero el `carro` no tiene poder sobre el clima.

**Definiciones**:
- Atributos: Son los datos que un objeto guarda sobre sí mismo. Son las características que lo describen y lo hacen único, como el nombre de una persona, el saldo de una cuenta o el color de un auto. El objeto usa estos datos para poder hacer su trabajo cuando le pedimos algo.
- Métodos: Son las acciones o habilidades que un objeto sabe realizar. Son las instrucciones (el código) que se ejecutan cuando el objeto recibe un mensaje. Si los atributos son 'lo que el objeto _es_', los métodos son 'lo que el objeto _sabe hacer_'.
- Clase: Es el **molde** que usamos para crear objetos. Define la estructura común que todos los objetos de un mismo tipo compartirán: qué **atributos** tendrán y qué **métodos** podrán hacer. Cada objeto creado a partir de esa clase es una **instancia** única de la misma.

**Diagrama de Clases en UML:
<img src="assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/POO-U1-Diagramaa1.svg" width="379" height="241" alt="">

![](assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/POO-U1-Diagrama3.png)

**Relaciones:**
- **Herencia:** La relación "es un". Una `Subclase` hereda todo lo público y protegido de su `Superclase`. La flecha (un triángulo) apunta siempre hacia la clase más general (el padre).
 - **Realización:** La relación "implementa un". Una clase concreta provee el código para los métodos definidos en una `Interfaz`. La flecha es como la de herencia, pero con línea punteada.
 - **Asociación:** La relación "usa un" o "tiene un" de forma más general. Indica que los objetos de dos clases se relacionan entre sí. Puede ser unidireccional (una clase conoce a la otra) o bidireccional (ambas se conocen). Aquí es donde se especifica la **cardinalidad** (`1`, `*`, `0..1`).
- **Agregación:** Un tipo especial de asociación que representa una relación "todo/parte". El "todo" _tiene_ "partes", pero las partes pueden existir sin el todo. (Ej: Un `Equipo` tiene `Jugadores`, pero si el equipo se disuelve, los jugadores siguen existiendo). Se representa con un rombo blanco.
- **Composición:** Una agregación más fuerte. El "todo" _es dueño_ de las "partes". Si el "todo" se destruye, las partes también. (Ej: Una `Factura` se compone de `LineasDeFactura`. Si borras la factura, las líneas no tienen sentido por sí solas). Se representa con un rombo negro.
- **Dependencia:** La relación más débil. Una clase "depende" de otra si la usa, por ejemplo, como un parámetro en un método. Un cambio en la clase de la que se depende puede requerir un cambio en la que depende. Se representa con una flecha punteada.

**Herencia**:
<img src="assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/POO-U1-Diagrama2.png" width="223" height="250" alt="">

La **herencia** es uno de los pilares de la **POO**, nos permite crear una jerarquía de clases, donde una clase más específica (la **subclase**) hereda características de una clase más general (la **superclase**).

**Ventajas**:
1. **Reutilización de Código**.
2. **Organización Lógica**. Modelando el mundo real de una forma muy natural.
3. **Polimorfismo**. Permitiendo tratar a objetos de las subclases como si fueran objetos de la superclase.

Una subclase puede agregar nuevos metodos. Pero tambien la subclase puede sobreescribir un metodo de la superclase

**Sobreescritura y Sobrecarga de Metodos**:

![](assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/POO-U1-Diagrama4.png)

![](assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/POO-U1-Diagrama5.png)

**Clases Abstractas**:
<img src="assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/POO-U1-Diagrama6.png" width="422" height="223" alt="">

**Interfaces**:
<img src="assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/POO-U1-Diagrama7.png" width="426" height="276" alt="">

**Clases Abstractas vs Interfaces:**

| Característica         | Clase Abstracta                                                                                       | Interfaz                                                                                                                                    |
| ---------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| **Intención**          | Define la **identidad** de un objeto. Modela una relación **"es un/a"**.                              | Define una **capacidad** o habilidad del objeto. Modela una relación **"puede hacer"**.                                                     |
| **Herencia**           | Una clase solo puede **extender (heredar de) UNA** clase abstracta.                                   | Una clase puede **implementar MÚLTIPLES** interfaces.                                                                                       |
| **Contenido**          | Puede tener **métodos abstractos** (sin implementación) y **métodos concretos** (con implementación). | Tradicionalmente, solo firmas de métodos (contratos puros). Lenguajes modernos (Java 8+, C#) permiten `default methods` con implementación. |
| **Estado (Atributos)** | Puede tener **variables de instancia** (atributos) que definen el estado del objeto.                  | No puede tener variables de instancia. Solo puede definir **constantes** (`public static final`).                                           |
| **Constructor**        | **Tiene un constructor**, que es invocado por las subclases (usando `super()`).                       | **No tiene constructor**. No se puede instanciar.                                                                                           |




---

- ### Tema 7 — Sistemas de Tipos

**El Problema: El Idioma de la Computadora es Demasiado Simple**
Imagina que la memoria de la computadora es una larguísima fila de `0` y `1`
Cuando escribimos código, como `edad = 25;`, la computadora traduce eso a una secuencia de unos y ceros, por ejemplo: `00011001`.

Pero si luego ves `00011001` escrito en la memoria, ¿cómo sabes lo que significa?
- ¿Es el número `25`? ¿Es el carácter salto de línea (`LF`) en la tabla ASCII? ¿Es una instrucción para el procesador?

*Es imposible saberlo, por lo tanto tenemos un programa inestable*.

**2. La Solución: Los Tipos**

Para evitar este caos, los lenguajes de programación nos obligan a ponerle "etiquetas" a nuestros datos. A estas etiquetas las llamamos **tipos**.

Cuando declaras `let edad: number = 25;` lo que estas diciendo es:

Trata a esta caja de memoria que llamo `edad` como un `numero`

Un **tipo** es una etiqueta que le dice a la computadora 3 cosas muy importantes:
- **¿Qué puedo guardar aquí?**
- **¿Qué puedo hacer con esto?**
- **¿Cómo lo entiendo?** (La interpretación de los bits).

Esta comprobación de tipos la realiza el compilador en tiempo de compilación o tiempo de ejecución. Si la comprobación de tipos falla acabamos con un fallo de compilación o con un error en tiempo de ejecución.

Pero muchas veces el sistema de tipos es para **proteger a la computadora de nosotros**. 
Y por eso ofrece mecanismos para **transformar errores de ejecución en errores de compilación**. Esto podría sonar raro porque convertimos un **error** en otro **error**, pero todo radica en cual es el tipo de error mas peligroso, y este es sin duda un error de ejecución.

- **Correctitud:**
	
	<img src="assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/Correctitud-2.png" width="429" height="213" alt="">

	1. **Podemos tener problemas con el Contrato Implícito**, cuando se usa un tipo permisivo como `any` (o en lenguajes no tipados), el contrato (o la firma) de una función es implícito. El código `scriptAt(s: any)` es sintácticamente válido, pero semánticamente asume que `s` tendrá un método `.indexOf()`. Esta suposición no se verifica hasta el tiempo de ejecución, lo que introduce una latencia para el descubrimiento de errores. Si se pasa un `number`, **el programa falla en producción, no durante el desarrollo**.
    
	2. **Y lo solucionamos con el Contrato Explícito**, al especificar `scriptAt(s: string)`, el contrato se vuelve explícito y verificable estáticamente. El compilador o _type checker_ puede ahora validar todas las llamadas a la función contra este contrato. Cualquier violación, como `scriptAt(42)`, se convierte en un error de compilación, impidiendo que el código incorrecto sea desplegado. Se traslada el fallo de un entorno impredecible (producción) a uno controlado (desarrollo).

	3. **Reducimos el Espacio de Estados**, el "espacio de estados" de un programa es el producto cartesiano de los dominios de todas sus variables activas. Un estado "malo" o inválido es una combinación de valores que conduce a un comportamiento indefinido o a un error.
	    - Un tipo como `any` tiene un dominio casi infinito, permitiendo un espacio de estados enorme y, por tanto, un gran número de posibles estados inválidos.
	    - Al aplicar un tipo estricto como `string`, se **restringe drásticamente el dominio** de la variable. 
	    
		![](assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/image%201.png)

- **Inmutabilidad:**
	Una vez que le das un valor a algo, no se puede cambiar jamás.

	<img src="assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/Inmutabilidad.png" width="443" height="344" alt="">

	1. **Simplificamos la concurrencia**, evitando que multiples proceso o hilos puedan modificar un dato.
	2. **Aumentamos la predictibilidad**, porque las funciones que reciben datos inmutables, solo pueden producir nuevos datos, y no se modifican los originales.
	
	De esta forma también reducimos el espacio de estados de un programa.

- **Encapsulación:**
	Protegemos el estado interno de los objetos.
	
	Se controla **dónde** pueden ocurrir mutaciones necesarias y **bajo qué reglas**. Si algo debe poder cambiar, lo encapsulamos para que solo sea modificable a través de funciones que preservan invariantes (condiciones que no pueden cambiar).
	
	Podemos tomar como **ejemplo** a una **máquina expendedora**: tú solo puedes pulsar botones (interfaz pública). No puedes abrirla y meter la mano para cambiar la lógica interna (estado privado). El fabricante garantiza “nunca entrega producto sin pago” porque nadie externo puede manipular directamente los engranajes.
	
	<img src="assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/Encapsulacion.png" width="450" height="318" alt="">

- **Componibilidad:**
	De esta manera aislamos el **Que** del **Como**
	![](assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/Componibilidad1.png)
	El truco es darse cuenta de que la **condición** (`n < 0` o `s.length === 1`) es un "trozo de lógica" que podemos pasar como si fuera un dato más. En JavaScript/TypeScript, las funciones son **ciudadanos de primera clase**, así que podemos hacer exactamente eso.
	![](assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/Componibilidad2.png)

	**Aislamos el Algoritmo, Parametrizamos el Comportamiento, facilitamos la Reutilizacion y Composición**
	
- **Legibilidad:**
	**El código se lee mucho más de lo que se escribe**. Los tipos son la forma más eficaz de hacer que el código se autodocumente, porque a diferencia de un comentario, el compilador los verifica.

	![](assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/Legibilidad.png)

	**Un tipo bien definido es un comentario que el compilador te obliga a mantener actualizado**

- ### Tema 8 — Sistemas de Tipos

#### Sistemas de Tipos Nominales

- Se basan en el **nombre/declaración explícita** del tipo.
- Dos tipos son compatibles **solo si tienen el mismo nombre** o están explícitamente relacionados (herencia, interfaces implementadas).
- Lenguajes: Java, C#, C++, Rust.

**Desventajas:**
- Demasiada rigidez
- Necesitas adaptadores para conectar tipos idénticos
- **Más código repetitivo (boilerplate)**
- **Dificulta la reutilización de código**

#### Sistemas de Tipos Estructurales

- Se basan en la **forma/estructura** del tipo.
- Dos tipos son compatibles si tienen **la misma estructura**, independientemente de su nombre.
- Lenguajes: TypeScript, Go.

**Desventajas:**
- Duck Typing Accidental: si camina como pato y habla como pato, es un pato
- Errores menos descriptivos
- Puede crear confusión cuando tipos diferentes tienen la misma estructura por casualidad
- Menos control explícito sobre las relaciones entre tipos

![](assets/Unidad%20I%20-%20Paradigmas%20de%20Programaci%C3%B3n/DuckTyping.png)
### **Analogía Simple:**
- **Nominal**: "¿Tienes el certificado correcto?"
- **Estructural**: "¿Sabes hacer el trabajo?"

### **Ejemplo Rápido:**
```typescript
// Estructural (TypeScript)
type Persona = { nombre: string; edad: number }
type Usuario = { nombre: string; edad: number }
// ✅ Son compatibles porque tienen la misma estructura
```

```java
// Nominal (Java)
class Persona { String nombre; int edad; }
class Usuario { String nombre; int edad; }
// ❌ NO son compatibles aunque tengan la misma estructura
```


### Tipos Básicos

...