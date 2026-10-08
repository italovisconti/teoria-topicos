
Estás en **UCABILIA**, un juego de rol por turnos. Cada personaje puede *usar habilidades*: un golpe de espada, una bola de fuego, una curación, etc. 

Lamentablemente, a día de hoy la clase `Personaje` decide la habilidad con un `switch`, y cada habilidad nueva obliga a modificar esa misma clase:

```ts
class Personaje {
  usarHabilidad(id: string, objetivo: Personaje): void {
    switch (id) {
      case "espada":
        objetivo.recibirDanio(10);
        break;
      case "fuego":
        objetivo.recibirDanio(25);
        break;
      case "curacion":
        this.curar(20);
        break;
      // ...cada habilidad nueva obliga a tocar ESTA clase
    }
  }
}
```

Al principio esto nos servía: el comportamiento de cada habilidad vivía dentro de `Personaje` y era fácil de leer. Pero el juego creció y ahora cada habilidad nueva como empuje, veneno, robo de vida, flecha de hielo… nos obliga a volver a abrir `Personaje` y agregar otro `case`. Y lo que es peor: queremos que un enemigo pueda usar las mismas habilidades que el héroe, y que ciertos eventos del mapa desbloqueen habilidades nuevas **en caliente**, sin volver a compilar.

Nos dimos cuenta de que el problema no es *cuántas* habilidades existan, sino que `Personaje` sabe **demasiado**: no solo elige cuál usar, también conoce cómo funciona cada una. Cada requisito nuevo nos hace tocar la misma clase una y otra vez.

**Esto es lo que necesitamos:**

* Que el "cómo funciona" de cada habilidad viva **en su propio lugar**, aislado del resto. Agregar, quitar o reemplazar una habilidad no debería obligarnos a tocar a `Personaje` ni a las demás habilidades.
* Que un personaje pueda **usar cualquier habilidad sin conocer su implementación**: solo la pide por un identificador.
* Que exista **un único lugar en todo el juego** que sepa qué habilidades están disponibles, que las entregue y que las liste. Ese lugar debe ser el **mismo** para todos: dos catálogos desincronizados serían un dolor de cabeza.
* Que podamos **sumar habilidades nuevas en tiempo de ejecución** (por ejemplo, al desbloquearlas) sin modificar ni a `Personaje` ni a ese catálogo.

### Requisitos

1. Separa el comportamiento de cada habilidad de `Personaje`: cada habilidad debe ser una pieza independiente que sepa ejecutarse sobre un origen y un objetivo, y que se identifique con un `id` y un `nombre`.
2. Define un **contrato común** que todas las habilidades cumplan, de modo que `Personaje` pueda usar cualquiera sin conocer su tipo concreto.
3. Crea un **catálogo central** que conozca todas las habilidades disponibles, las entregue a partir de su `id`, permita listarlas, y garantice que haya **una sola instancia** en todo el programa con un punto de acceso claro a ella.
4. `Personaje` no debe contener ningún `switch`/`if` sobre habilidades concretas: solo debe pedirle la habilidad al catálogo y **delegar** el trabajo.
5. Diseña el sistema para poder **registrar una habilidad nueva en tiempo de ejecución**, sin modificar `Personaje` ni el catálogo.
6. Demuestra que dos pedidos del catálogo obtienen **la misma instancia** (no se crean copias).

> [!NOTE] Tu solución no tiene que ser idéntica a la propuesta
> En la resolución se muestra *una* forma de lograrlo. Lo importante es que cumplas los requisitos y puedas justificar cada decisión.

### Preguntas de reflexión

1. ¿Qué patrones de diseño, de los vistos en clase, aparecen (o podrían aparecer) en tu solución? Justifica qué rol cumple cada uno.
2. Un `Map` global `const habilidades = new Map(...)` también guardaría las habilidades. ¿Por qué no es suficiente? ¿Qué te da el hecho de que exista una sola instancia del catálogo?
3. ¿Qué problemas concretos aparecerían si existieran **dos** catálogos vivos al mismo tiempo? Relaciónalo con la analogía de la *torre de control*.
4. ¿Este catálogo es una decisión de diseño legítima o un *Service Locator* disfrazado? ¿En qué momento se vuelve un antipatrón?
5. En este ejemplo las habilidades no tienen estado. ¿Conviene reutilizar las mismas instancias o crear una nueva en cada uso? ¿Y si una habilidad guardara estado por uso?
6. ¿Cómo agregarías una habilidad nueva sin tocar `Personaje` ni el catálogo? ¿Qué **principio SOLID** se está cumpliendo?
7. Compara este diseño con el de *UrbanRide* (guía práctica): ¿en qué se parece y en qué se diferencia la forma de elegir el comportamiento?


---

> [!TIP] Solución
> La resolución paso a paso está en [Resolución — Catálogo de Habilidades](Resoluci%C3%B3n%20-%20Cat%C3%A1logo%20de%20Habilidades.md).
