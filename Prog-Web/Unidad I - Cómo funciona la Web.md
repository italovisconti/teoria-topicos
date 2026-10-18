# Unidad I — Cómo funciona la Web

> [!NOTE] Fundamento central
> La Web es un **sistema de recursos identificados por URLs y transferidos mediante HTTP** sobre la infraestructura de Internet. Antes de escribir una línea de HTML conviene tener un modelo mental de qué ocurre entre el momento en que se escribe una dirección y el momento en que aparece una página.

> [!TIP] Pregunta conductora
> ¿Qué tiene que ocurrir para que al escribir `https://ejemplo.com` aparezca una página en el navegador?

## 1. Internet no es la Web

Es frecuente usar ambos términos como sinónimos, pero designan cosas distintas.

| Concepto | Qué es |
|---|---|
| **Internet** | La infraestructura: una red de redes que se comunican mediante protocolos, principalmente TCP/IP. |
| **Web** | Un servicio que funciona sobre Internet: documentos y recursos identificados por URL, transferidos con HTTP y escritos, entre otros formatos, en HTML. |

Sobre Internet también funcionan el correo electrónico, el DNS, SSH, las videollamadas, los videojuegos en línea y las actualizaciones del sistema operativo. La Web es **uno** de esos servicios.

Una analogía útil:

- **Internet** es la red de carreteras.
- **La Web** es uno de los servicios de transporte que circula por ellas.
- **El navegador** es el vehículo con el que se recorre ese servicio.

> [!WARNING] Error frecuente
> Decir “la página está en Internet” cuando en realidad está publicada en un servidor conectado a Internet y es accesible a través de la Web. La distinción importa cuando se diagnostican problemas: puede haber conectividad sin que un sitio web responda, o un sitio web disponible aunque el correo no funcione.

## 2. El modelo cliente-servidor

La Web se organiza alrededor de dos roles:

- **Cliente:** inicia la comunicación. El navegador es el cliente más común, pero también lo son `curl`, una aplicación móvil o un script.
- **Servidor:** escucha peticiones y devuelve respuestas. Es un **programa** que corre en una máquina, no la máquina en sí.

```mermaid
flowchart LR
    C["Cliente<br/>Navegador, app, curl"] -->|"1. Petición"| S["Servidor<br/>Programa que escucha"]
    S -->|"2. Respuesta"| C
```

El cliente **siempre inicia** la conversación. El servidor no “empuja” datos por iniciativa propia en el modelo básico; espera a que se los pidan. Esto explica por qué una página no se actualiza sola salvo que use mecanismos adicionales, como polling, eventos del servidor o WebSockets.

Los roles no son absolutos: un servidor web puede actuar como cliente de una base de datos o de otro servicio. Lo que define el rol es **quién inicia la comunicación en ese intercambio**.

> [!NOTE] Caso especial: peer-to-peer
> En una red P2P los nodos pueden actuar como clientes y servidores a la vez. Es una excepción al modelo clásico, no la regla general de la Web.

## 3. Anatomía de una URL

Una URL no es solo “la dirección”. Es una estructura con partes que el navegador interpreta.

```text
https://usuario:clave@www.ejemplo.com:443/curso/web?unidad=1#temario
└─┬─┘   └──────┬──────┘└──────┬──────┘└┬┘└─────┬─────┘└────┬────┘└──┬──┘
  │            │              │         │       │           │        │
esquema    credenciales      host     puerto   ruta       query   fragmento
```

| Parte | Función |
|---|---|
| **Esquema** | Protocolo o forma de acceso: `http`, `https`, `mailto`, `ftp`. |
| **Credenciales** | Usuario y contraseña embebidos. Hoy se consideran una práctica insegura y casi nunca se usan. |
| **Host** | Nombre de dominio o dirección IP del servidor. |
| **Puerto** | Puerto de red. Si se omite, se usa el predeterminado del esquema: `80` para HTTP y `443` para HTTPS. |
| **Ruta** | Identifica un recurso dentro del servidor. |
| **Query** | Parámetros `clave=valor` separados por `&`. No forman parte de la ruta. |
| **Fragmento** | Apunta a una sección dentro del recurso. **No se envía al servidor**; lo usa el navegador. |

Dos consecuencias prácticas:

- `/curso/web`, `/curso/web/` y `/curso/web?unidad=1` pueden ser recursos distintos para el servidor.
- El fragmento (`#temario`) no llega al backend. Si se necesita ese dato en el servidor, hay que enviarlo de otra forma.

### URLs absolutas y relativas

Una URL absoluta incluye el esquema y el host. Una relativa se resuelve contra la URL del documento actual.

```html
<a href="https://ejemplo.com/curso">Absoluta</a>
<a href="/curso">Relativa a la raíz del sitio</a>
<a href="unidad-02.html">Relativa al documento actual</a>
<a href="../recursos/">Relativa al directorio padre</a>
```

Entender la resolución de URLs evita una gran cantidad de errores en HTML, CSS, JavaScript y llamadas a una API.

## 4. DNS: el sistema de nombres

Los humanos usamos nombres; las máquinas se comunican con direcciones IP. **DNS** (Domain Name System) traduce nombres de dominio a direcciones IP.

```mermaid
sequenceDiagram
    autonumber
    participant N as Navegador
    participant R as Resolver DNS
    participant Root as Servidor raíz
    participant TLD as Servidor .com
    participant Auth as Servidor autoritativo
    N->>R: ¿Cuál es la IP de ejemplo.com?
    R->>Root: Consulta
    Root-->>R: Deriva a los servidores .com
    R->>TLD: Consulta
    TLD-->>R: Deriva al servidor autoritativo
    R->>Auth: Consulta
    Auth-->>R: 192.0.2.10
    R-->>N: 192.0.2.10 (y la guarda en caché)
```

Puntos importantes:

- La resolución es **jerárquica**: raíz, dominio de nivel superior (`.com`, `.org`, `.ve`), dominio y subdominios.
- Existen **cachés** en el navegador, el sistema operativo, el resolver y los servidores. Por eso un cambio de DNS no se propaga instantáneamente.
- Cada registro tiene un **TTL** (time to live): el tiempo que puede conservarse en caché.
- DNS no transporta la página; solo resuelve el nombre. Una vez obtenida la IP, la conexión se establece con el servidor correspondiente.

Herramientas para observarlo:

```bash
dig ejemplo.com +short
nslookup ejemplo.com
```

> [!NOTE] DNS también es un sistema distribuido
> No hay una única base de datos central con todos los dominios. La información está repartida y delegada jerárquicamente, con cachés intermedias. Esa descentralización es parte de por qué Internet escala.

## 5. El viaje completo de una petición

```mermaid
sequenceDiagram
    autonumber
    actor U as Persona
    participant N as Navegador
    participant DNS as DNS
    participant S as Servidor
    U->>N: Escribe https://ejemplo.com
    N->>DNS: Resuelve el nombre
    DNS-->>N: Dirección IP
    N->>S: Conexión TCP + TLS
    N->>S: GET / HTTP/1.1
    S-->>N: 200 OK + HTML
    N->>N: Parsea HTML y descubre CSS, JS, imágenes
    N->>S: Nuevas peticiones para cada recurso
    S-->>N: Respuestas
    N->>U: Página renderizada
```

1. **Interpretación de la URL.** El navegador identifica esquema, host, ruta y demás partes.
2. **Resolución DNS.** Si no tiene la IP en caché, consulta el sistema de nombres.
3. **Conexión de transporte.** Se establece una conexión TCP (handshake de tres pasos) con el servidor.
4. **Seguridad.** Si el esquema es `https`, se negocia TLS sobre esa conexión.
5. **Petición HTTP.** El navegador envía un método, una ruta, cabeceras y, a veces, un cuerpo.
6. **Procesamiento en el servidor.** El servidor decide qué responder: un archivo, una página generada, datos de una API, un error.
7. **Respuesta HTTP.** Vuelve un código de estado, cabeceras y un cuerpo.
8. **Subrecursos.** El navegador parsea el HTML y descubre CSS, JavaScript, imágenes y fuentes. Cada uno genera nuevas peticiones.
9. **Renderizado.** Construye el DOM, aplica estilos, calcula el layout y pinta.
10. **Ejecución de JavaScript.** El código puede modificar el DOM, hacer nuevas peticiones o responder a eventos.

> [!IMPORTANT] Una página no es una sola petición
> El documento HTML es solo el punto de partida. Una página típica genera decenas de peticiones. Por eso el rendimiento se analiza sobre el **conjunto** de recursos y su orden, no solo sobre el tamaño del HTML.

## 6. HTTP: el contrato de la comunicación

HTTP (HyperText Transfer Protocol) define **cómo se piden y se devuelven recursos**. Es un protocolo de texto, fácil de leer y de inspeccionar.

### Estructura de una petición

```http
GET /curso/web HTTP/1.1
Host: ejemplo.com
Accept: text/html
User-Agent: Mozilla/5.0
```

### Estructura de una respuesta

```http
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 1256
Cache-Control: max-age=3600

<!DOCTYPE html>
<html lang="es">...</html>
```

### Métodos

| Método | Uso habitual | Seguro | Idempotente |
|---|---|---|---|
| `GET` | Obtener un recurso | Sí | Sí |
| `HEAD` | Obtener solo las cabeceras | Sí | Sí |
| `POST` | Crear un recurso o ejecutar una acción | No | No |
| `PUT` | Reemplazar un recurso | No | Sí |
| `PATCH` | Modificar parcialmente un recurso | No | No necesariamente |
| `DELETE` | Eliminar un recurso | No | Sí |

- **Seguro** significa que no debería modificar el estado del servidor.
- **Idempotente** significa que repetir la misma operación produce el mismo efecto final que ejecutarla una vez.

Estas propiedades no son Decoración: permiten que navegadores, cachés y proxies reintenten peticiones con seguridad.

### Códigos de estado

| Familia | Significado | Ejemplos |
|---|---|---|
| `1xx` | Informativo | `101 Switching Protocols` |
| `2xx` | Éxito | `200 OK`, `201 Created`, `204 No Content` |
| `3xx` | Redirección | `301 Moved Permanently`, `304 Not Modified` |
| `4xx` | Error del cliente | `400 Bad Request`, `401 Unauthorized`, `403 Forbidden`, `404 Not Found` |
| `5xx` | Error del servidor | `500 Internal Server Error`, `502 Bad Gateway`, `503 Service Unavailable` |

> [!WARNING] `401` no es lo mismo que `403`
> `401 Unauthorized` significa “no sé quién eres o no has presentado credenciales válidas”. `403 Forbidden` significa “sé quién eres, pero no tienes permiso”. La distinción importa al diseñar una API y al depurar.

### Cabeceras

Las cabeceras aportan contexto: formato del cuerpo, idioma, caché, cookies, credenciales, origen de la petición.

| Cabecera | Para qué sirve |
|---|---|
| `Host` | Indica el dominio solicitado. Permite que un mismo servidor aloje varios sitios. |
| `Content-Type` | Declara el formato del cuerpo: `text/html`, `application/json`, `image/png`. |
| `Accept` | Qué formatos acepta el cliente. |
| `Authorization` | Credenciales, por ejemplo un token. |
| `Cookie` | Cookies enviadas al servidor. |
| `Cache-Control` | Reglas de almacenamiento en caché. |
| `Access-Control-Allow-Origin` | Origen permitido en una respuesta CORS. |

### HTTP es sin estado

Cada petición es independiente: el servidor no recuerda automáticamente la anterior. Esa característica simplifica el diseño y permite escalar, pero obliga a introducir mecanismos explícitos para mantener la sesión: **cookies**, tokens o almacenamiento del lado del cliente.

> [!NOTE] Sin estado no significa sin memoria
> Significa que el protocolo no conserva el contexto entre peticiones. La aplicación puede guardar estado en una base de datos, en una sesión o en el cliente. Lo que no existe es una conversación implícita que el servidor recuerde por sí solo.

## 7. HTTPS: qué protege y qué no

HTTPS es HTTP sobre **TLS**. Aporta tres propiedades:

- **Confidencialidad:** el contenido no puede leerse en tránsito.
- **Integridad:** no puede modificarse sin que se detecte.
- **Autenticación del servidor:** el certificado permite verificar que se está hablando con el servidor esperado.

```mermaid
flowchart LR
    N["Navegador"] -->|"TLS: canal cifrado"| S["Servidor"]
    N -.->|"Certificado válido"| S
```

> [!WARNING] HTTPS no significa “sitio confiable”
> Un sitio malicioso también puede tener un certificado válido. HTTPS protege el **canal**, no garantiza que el contenido sea legítimo ni que el servidor cumpla lo que promete.

## 8. Capas: por qué conviene pensar en abstracciones

La comunicación se organiza en capas. Cada una ofrece un servicio a la capa superior y oculta los detalles de la inferior.

| Capa | Ejemplos | Responsabilidad |
|---|---|---|
| Aplicación | HTTP, DNS, TLS | Reglas del servicio: peticiones, nombres, cifrado. |
| Transporte | TCP, UDP | Entrega de datos entre procesos; orden y confiabilidad en TCP. |
| Red | IP | Direccionamiento y enrutamiento entre redes. |
| Enlace | Ethernet, Wi-Fi | Comunicación en el medio físico local. |

Esta separación permite cambiar una capa sin reescribir las demás. También explica por qué “la página no carga” puede deberse a causas muy distintas: DNS, red, TLS, servidor, aplicación o cliente.

## 9. Actividad de observación

El objetivo es **ver** el modelo, no memorizarlo.

1. Abrir las herramientas de desarrollo del navegador y ir a la pestaña **Network**.
2. Activar “Disable cache” y recargar una página conocida.
3. Identificar:
	- La petición del documento principal.
	- Al menos una hoja de estilos, un script y una imagen.
	- El código de estado, el `Content-Type` y el tiempo de cada una.
4. Abrir una petición y revisar:
	- Cabeceras de la petición.
	- Cabeceras de la respuesta.
	- Cuerpo de la respuesta, si es texto.
5. Comparar el waterfall: ¿qué se descarga primero? ¿Qué depende de qué?
6. Ejecutar en una terminal:

```bash
curl -I https://example.com
curl -s https://example.com | head
```

7. Resolver un dominio:

```bash
dig example.com +short
```

> [!TIP] Preguntas para la puesta en común
> - ¿Cuántas peticiones genera una página “simple”?
> - ¿Qué diferencia hay entre el código de estado y el contenido de la respuesta?
> - ¿Por qué el HTML puede aparecer antes que las imágenes?
> - ¿Qué pasaría si el DNS devolviera otra IP?

## 10. Avance del proyecto

1. Crear la carpeta del proyecto y un `index.html` mínimo:

```html
<!DOCTYPE html>
<html lang="es">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Actividades</title>
</head>
<body>
	<h1>Actividades</h1>
	<p>Primera página del proyecto.</p>
</body>
</html>
```

2. Servirla con un servidor local:

```bash
python3 -m http.server 8000
```

3. Abrir `http://localhost:8000` y observar la petición en Network.

> [!IMPORTANT] `file://` no es HTTP
> Abrir el archivo con doble clic usa el esquema `file://`. No hay servidor, no hay petición HTTP y muchas APIs del navegador se comportan distinto. Para el resto del curso se trabaja con un servidor local.

## 11. Comprobación de comprensión

Responder sin mirar los apuntes:

1. ¿Cuál es la diferencia entre Internet y la Web?
2. ¿Quién inicia una petición HTTP: el cliente o el servidor?
3. ¿Qué hace DNS y qué no hace?
4. ¿Qué parte de una URL no se envía al servidor?
5. ¿Por qué se dice que HTTP es sin estado? ¿Cómo se mantiene una sesión?
6. ¿Qué diferencia hay entre `401` y `403`?
7. ¿Qué protege HTTPS y qué no protege?
8. Si una página no carga, ¿qué capas habría que revisar antes de concluir que “el servidor está caído”?

> [!NOTE] Criterio de evaluación
> No alcanza con definir los términos. Se espera poder **aplicarlos a un caso**: explicar qué ocurre en una petición concreta, identificar en qué capa está un fallo y justificar qué información falta para diagnosticarlo.

## Referencias

- MDN. [How the web works](https://developer.mozilla.org/en-US/docs/Learn_web_development/Getting_started/Web_standards/How_the_web_works).
- MDN. [An overview of HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview).
- MDN. [What is a URL?](https://developer.mozilla.org/en-US/docs/Learn_web_development/Howto/Web_mechanics/What_is_a_URL).
- MDN. [What is a domain name?](https://developer.mozilla.org/en-US/docs/Learn_web_development/Howto/Web_mechanics/What_is_a_domain_name).
