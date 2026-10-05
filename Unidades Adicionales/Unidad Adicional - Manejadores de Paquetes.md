## ¿Qué es un manejador de paquetes?

Un **paquete** (package) es código que alguien más escribió y que pueden reutilizar en sus aplicaciones —básicamente, una librería empaquetada y lista para usar.

Cuando descargan un paquete y lo usan en su proyecto, este se convierte en una **dependencia**: su proyecto *depende* de él para funcionar.

Un **gestor de paquetes** (package manager) es una herramienta que:
- Se conecta a un repositorio de paquetes en internet
- Descarga paquetes por nombre y los instala en su máquina
- Maneja actualizaciones y diferentes versiones
- Automatiza todo el proceso de forma reproducible

Las dependencias pueden volverse complicadas rápidamente, así que tener una herramienta que gestione ese caos es esencial.

> [!INFO] npm y Yarn
> **npm** y **Yarn** son los gestores de paquetes más usados para JavaScript/Node.js. Hacen esencialmente lo mismo —pueden usar cualquiera de los dos. En este curso usaremos **npm** porque viene incluido con Node.js.

---

## Metáfora: Sets de LEGO
Hace poco visité a un amigo al que le encantan los LEGO. Toda su casa parece una sala de exposiciones con sets coloridos exhibidos en los lugares más sorprendentes. Hay una flor en la repisa del espejo del baño, un dragón custodiando las escaleras, un set de una serie de televisión cerca de la mesa de la cocina y una escuela de magia cerca de su mueble de TV. Noté que, en la mayoría de los casos, una gran creación era, de hecho, una colección de sets más pequeños.

Imaginen que el enorme castillo de la escuela de magia es su aplicación y, para que esté completa, necesitan agregar un montón de extras como una estación de tren, un árbol mágico o un fénix. Cada uno de ellos es una entidad separada que pueden mover como deseen.

### Módulos de Node y paquetes
Si el castillo de la escuela de magia es su aplicación, entonces cada uno de los extras sería un **módulo de Node** o un **paquete**.

Digamos que el castillo necesita un árbol mágico. Podrían diseñarlo ustedes mismos, pero es mucho más fácil conseguir el set completo, diseñado y empaquetado en una caja con instrucciones. En esta analogía, un set listo para armar es un "paquete" y las instrucciones son el archivo "**package.json**".

Un módulo de Node, o un paquete, es un fragmento de código que ayuda a agregar alguna funcionalidad a una aplicación. El archivo `package.json` nos dice quién creó el paquete, cuándo se creó, qué otras "dependencias" necesita para funcionar, y así sucesivamente. Más adelante veremos un [ejemplo completo de package.json](#ejemplo-de-packagejson).

> [!NOTE] Módulos vs Paquetes
> La documentación oficial de npm hace una distinción técnica entre "módulos de Node" y "paquetes". Sin embargo, en la práctica se usan indistintamente.

### Gestores de paquetes
Ahora, si solo tienen uno o dos sets de LEGO en su casa, gestionar un inventario no sería tan difícil. Pero, ¿qué pasa si son coleccionistas de toda la vida, las piezas se rompen a menudo, salen nuevos sets constantemente y el esquema de colores disponible cambia más rápido de lo que la compañía logra anunciar? Idealmente encontrarían un sistema para llevar el registro de todas las piezas que poseen, las que necesitan reemplazar, las que ya no necesitan y las que tienen que comprar.

Es por esto que en el software existe la necesidad de los llamados "**gestores de paquetes**" (*package managers*). Un gestor de paquetes es una herramienta que te ayuda a llevar el registro de todas las dependencias de tu aplicación de una manera consistente.

Y algo super importante: automatiza las tareas de instalación, actualización, configuración y eliminación de dependencias. Se asegura de que todos los paquetes que tu aplicación necesita estén instalados, en la versión correcta o actualizados.

## Ejemplo de package.json

```json
{
  "name": "topicos-especiales",
  "version": "1.0.0",
  "description": "Ejercicios y ejemplos de Tópicos Especiales de Programación (TypeScript)",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc -p tsconfig.json",
    "dev": "ts-node src/index.ts",
    "start": "node dist/index.js",
    "lint": "eslint \"src/**/*.ts\"",
    "test": "jest",
    "format": "prettier --write \"src/**/*.{ts,md}\""
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/usuario/topicos-especiales.git"
  },
  "keywords": ["typescript", "educacion", "programacion"],
  "author": "Prof. Italo Visconti",
  "license": "MIT",
  "bugs": {
    "url": "https://github.com/usuario/topicos-especiales/issues"
  },
  "homepage": "https://github.com/usuario/topicos-especiales#readme",
  "engines": {
    "node": ">=18.0.0"
  },
  "dependencies": {
    "axios": "^1.4.0"
  },
  "devDependencies": {
    "typescript": "^5.1.3",
    "@types/node": "^18.16.0",
    "ts-node": "^10.9.1",
    "eslint": "^8.50.0",
    "jest": "^29.6.4",
    "ts-jest": "^29.1.0",
    "prettier": "^2.8.8"
  }
}
```

---

## ¿Por qué necesitamos gestores de paquetes?

### 1. Dependencias transitivas (el árbol de dependencias)
Cuando armamos un proyecto, solemos usar muchos paquetes, y **cada paquete puede tener sus propias dependencias**. Por ejemplo, si usamos `axios` para hacer solicitudes HTTP, este paquete podría depender internamente de otros paquetes para funcionar. El gestor de paquetes se encarga de descargar e instalar todas estas *dependencias transitivas* automáticamente.

```
su-proyecto
├── axios (ustedes lo instalaron)
│   ├── follow-redirects (axios lo necesita)
│   └── form-data (axios lo necesita)
│       └── mime-types (form-data lo necesita)
└── ...
```

Sin un gestor de paquetes, tendrían que rastrear e instalar cada una de estas dependencias manualmente.

> [!TIP] ¿Se han dado cuenta?
> Cuando instalan un paquete y luego revisan `node_modules`, aparecen un montón de carpetas nuevas que no esperaban. Esas son las dependencias transitivas.

<img src="../assets/Unidad%20Adicional%20-%20Manejadores%20de%20Paquetes/deps-transitivas.gif" width="700" alt="">

*Instalaste 1 paquete (axios)… y entraron 47. Eso son las dependencias transitivas.*

### 2. Control de versiones (para evitar el caos)
El gestor de paquetes mantiene un registro de las **versiones específicas** de cada paquete. Esto es crucial para evitar conflictos entre versiones incompatibles.

Los gestores **no simplemente instalan la versión más nueva**; respetan las versiones especificadas en los archivos de configuración (`package.json`, `package-lock.json`, `yarn.lock`).

#### ¿Qué son los "breaking changes"?
Un *breaking change* es cuando una actualización de un paquete introduce cambios incompatibles con versiones anteriores. Por ejemplo:
- Una función cambia de nombre o parámetros
- Se elimina una funcionalidad
- Cambia el formato de los datos de retorno

Si su proyecto depende de una versión específica, el gestor se asegurará de instalar esa versión —y no la más reciente— evitando errores inesperados.

#### Conflictos entre dependencias
Algo que van a experimentar (si no lo han hecho ya): dos librerías que ustedes usan dependen de **versiones diferentes** de una misma dependencia interna.

```
su-proyecto
├── axios → necesita follow-redirects@1.15.0
└── otra-libreria → necesita follow-redirects@1.14.0  ❌ Conflicto
```

Resolver esto manualmente sería un dolor de cabeza. El gestor de paquetes maneja estas situaciones automáticamente, ya sea instalando versiones compatibles o aislando dependencias cuando es necesario.

### 3. Actualizaciones seguras
Si quieren actualizar un paquete a una versión más reciente, el gestor puede hacerlo de manera **segura**, verificando compatibilidad con las demás dependencias.

```bash
# Ver qué paquetes tienen actualizaciones disponibles
npm outdated

# Actualizar un paquete específico
npm update axios

# Actualizar todo (con cuidado)
npm update
```

> [!WARNING] 
> Siempre revisa el changelog de un paquete antes de actualizar a una versión major (ej: de 1.x a 2.x). Los breaking changes suelen ocurrir ahí.

### 4. Scripts y automatización
Los gestores de paquetes permiten definir **scripts personalizados** para automatizar tareas comunes:

```json
"scripts": {
  "dev": "ts-node src/index.ts",
  "build": "tsc",
  "test": "jest",
  "lint": "eslint src/",
  "format": "prettier --write src/"
}
```

Ejecutas con `npm run dev`, `npm run test`, etc. Esto estandariza cómo se trabaja en el proyecto —cualquier persona nueva puede ejecutar los mismos comandos.

### 5. Separación dev vs producción
Pueden distinguir entre:
- **dependencies**: paquetes necesarios para que tu app funcione en producción
- **devDependencies**: paquetes solo para desarrollo (TypeScript, linters, test runners)

```bash
# Instalar en dependencies (producción)
npm install axios

# Instalar en devDependencies (solo desarrollo)
npm install -D typescript eslint jest
```

En producción, puedes instalar solo lo necesario con `npm install --production`, reduciendo el tamaño del deploy.

### 6. Reproducibilidad del entorno
Uno de los problemas más comunes en desarrollo es el clásico: *"en mi máquina funciona"*. 🤷

Esto ocurre cuando dos desarrolladores tienen versiones ligeramente diferentes de las dependencias. El gestor de paquetes resuelve esto mediante:

1. **Archivo de lock** (`package-lock.json`, `yarn.lock`): registra las versiones *exactas* de todo lo instalado
2. **Comando determinista**: `npm ci` instala exactamente lo que dice el lock file, sin modificarlo
3. **Entornos consistentes**: CI/CD, producción y desarrollo usan las mismas versiones

```bash
# En desarrollo (puede actualizar lock file)
npm install
# o simplemente
npm i

# En CI/CD o producción (respeta lock file estrictamente)
npm ci
```

---

## Archivos de lock: `package-lock.json` y `yarn.lock`

Además del `package.json`, los gestores generan un archivo de "lock" que registra las **versiones exactas** de todas las dependencias instaladas (incluyendo las transitivas).

| Archivo | Gestor |
|---------|--------|
| `package-lock.json` | npm |
| `yarn.lock` | yarn |
| `pnpm-lock.yaml` | pnpm |

> [!NOTE]
> **Siempre incluye el archivo lock en tu repositorio git.** Esto garantiza que todos los desarrolladores (y el servidor de producción) instalen exactamente las mismas versiones.

---

## Comandos esenciales

| Acción | npm | yarn |
|--------|-----|------|
| Inicializar proyecto | `npm init -y` | `yarn init -y` |
| Instalar dependencias | `npm install` | `yarn` |
| Agregar paquete | `npm install axios` | `yarn add axios` |
| Agregar paquete dev | `npm install -D typescript` | `yarn add -D typescript` |
| Eliminar paquete | `npm uninstall axios` | `yarn remove axios` |
| Ejecutar script | `npm run dev` | `yarn dev` |
| Ver paquetes desactualizados | `npm outdated` | `yarn outdated` |
| Actualizar paquete | `npm update axios` | `yarn upgrade axios` |
| Instalar paquete de forma global | `npm install -g typescript` | `yarn global add typescript` |
| Ejecutar paquete sin instalar | `npx create-react-app mi-app` | `yarn dlx create-react-app mi-app` |

---

## Más allá de Node.js

> [!TIP]
> Los conceptos que aprendiste aquí aplican a **cualquier ecosistema**:

| Lenguaje/Sistema | Gestor de paquetes | Archivo de config |
|------------------|-------------------|-------------------|
| JavaScript/Node | npm, yarn, pnpm | `package.json` |
| Python | pip, poetry, conda | `requirements.txt`, `pyproject.toml` |
| Ruby | gem, bundler | `Gemfile` |
| PHP | composer | `composer.json` |
| Rust | cargo | `Cargo.toml` |
| Go | go modules | `go.mod` |
| Linux (Debian) | apt | — |
| Linux (Arch) | pacman | — |
| macOS | brew | — |
| Windows | choco, winget | — |

La idea es siempre la misma: automatizar la gestión de dependencias, controlar versiones y facilitar la reproducibilidad del entorno.

---

## ¿Y dónde se alojan todos estos paquetes?

Cada ecosistema tiene su **registro de paquetes** (package registry): un servidor centralizado donde los desarrolladores publican sus paquetes y desde donde tú los descargas.

### npm Registry (para JavaScript/Node)
El registro más grande del mundo es [npmjs.com](https://www.npmjs.com/), con más de **2 millones de paquetes**. Cuando ejecutas `npm install axios`, npm consulta este registro, descarga el paquete y lo coloca en tu carpeta `node_modules`.


```
npm install axios
       │
       ▼
┌─────────────────┐
│  npmjs.com      │  ← Registro público
│  (registry)     │
└────────┬────────┘
         │ descarga
         ▼
┌─────────────────┐
│  node_modules/  │  ← Tu máquina local
│    axios/       │
└─────────────────┘
```

Otro detalle importante es que en los registros pueden ver datos como: cantidad de descargas, versiones disponibles, documentación, el código fuente, issues reportados, etc.

### Otros registros populares

| Ecosistema | Registro | URL |
|------------|----------|-----|
| JavaScript | npm | [npmjs.com](https://www.npmjs.com/) |
| Python | PyPI | [pypi.org](https://pypi.org/) |
| Ruby | RubyGems | [rubygems.org](https://rubygems.org/) |
| PHP | Packagist | [packagist.org](https://packagist.org/) |
| Rust | crates.io | [crates.io](https://crates.io/) |
| Go | Go Modules | [pkg.go.dev](https://pkg.go.dev/) |

### Registros privados
Las empresas grandes suelen tener **registros privados** para paquetes internos que no quieren hacer públicos. Herramientas como **Verdaccio**, **GitHub Packages**, **GitLab Package Registry** o **Artifactory** permiten hospedar tus propios paquetes.

```bash
# Configurar npm para usar un registro privado
npm config set registry https://npm.mi-empresa.com/
```

#### ¿Qué quiere decir esto?

Que ustedes pueden crear un repositorio público de GitHub con su propio paquete, y luego usar npm para instalar ese paquete directamente desde GitHub. 

---

## Pero... ¿por qué hay tantos gestores de paquetes para JavaScript?

En otros lenguajes suele haber **un solo gestor** dominante (pip en Python, cargo en Rust, composer en PHP). Pero en JavaScript tenemos npm, yarn, pnpm, bun... ¿por qué?

### Un poco de historia

**2010 - npm nace** 📦
- npm (Node Package Manager) fue creado junto con Node.js
- Era lento, no tenía lock files, y `node_modules` podía volverse gigantesco
- Pero funcionaba y se convirtió en el estándar

**2016 - Yarn aparece** 🧶
- Facebook, Google y otros crearon Yarn para resolver los problemas de npm
- Introdujo `yarn.lock` (instalaciones deterministas)
- Era **mucho más rápido** que npm en ese momento
- Instalación en paralelo, mejor caché

**2017 - npm reacciona** ⚡
- npm 5 agregó `package-lock.json`
- Mejoró drásticamente la velocidad
- Cerró la brecha con Yarn

**2020 - pnpm gana tracción** 🔗
- Usa *hard links* y *symlinks* para evitar duplicar paquetes
- `node_modules` ocupa **mucho menos espacio**
- Más rápido que npm y yarn en muchos casos
- Estructura más estricta (evita acceder a dependencias no declaradas)

**2022 - Bun entra al juego** 🍞
- Runtime de JavaScript escrito en Zig (no en JS)
- Incluye gestor de paquetes integrado
- Extremadamente rápido (instalaciones en segundos)
- Aún en desarrollo activo

---

## Tu primer proyecto con npm

Ahora que entienden la teoría, vamos a crear un proyecto desde cero.

### Ejercicio: Crear un proyecto TypeScript con axios

**Objetivo**: Inicializar un proyecto, instalar dependencias y ejecutar un script.

#### Paso 1: Crear la carpeta del proyecto
```bash
mkdir mi-primer-proyecto
cd mi-primer-proyecto
```

#### Paso 2: Inicializar el proyecto
```bash
npm init -y
```

Esto crea un `package.json` básico. Ábranlo y verán algo así:
```json
{
  "name": "mi-primer-proyecto",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  }
}
```

#### Paso 3: Instalar TypeScript y ts-node como dependencias de desarrollo
```bash
npm install -D typescript ts-node @types/node
```

> [!NOTE] ¿Qué es `-D`?
> El flag `-D` (o `--save-dev`) instala el paquete en `devDependencies` —solo se usa en desarrollo, no en producción.

#### Paso 4: Instalar axios como dependencia de producción
```bash
npm install axios
```

#### Paso 5: Crear el archivo de configuración de TypeScript
```bash
npx tsc --init
```

#### Paso 6: Crear el código fuente

Creen una carpeta `src` y dentro un archivo `index.ts`:

```typescript
// src/index.ts
import axios from 'axios';

async function obtenerPokemon(nombre: string) {
  try {
    const response = await axios.get(`https://pokeapi.co/api/v2/pokemon/${nombre}`);
    console.log(`🎮 ${response.data.name.toUpperCase()}`);
    console.log(`   Altura: ${response.data.height / 10}m`);
    console.log(`   Peso: ${response.data.weight / 10}kg`);
    console.log(`   Tipos: ${response.data.types.map((t: any) => t.type.name).join(', ')}`);
  } catch (error) {
    console.error('❌ No se encontró el Pokémon');
  }
}

obtenerPokemon('pikachu');
```

#### Paso 7: Agregar script de desarrollo

Editen el `package.json` y agreguen un script:
```json
"scripts": {
  "dev": "ts-node src/index.ts"
}
```

#### Paso 8: Ejecutar
```bash
npm run dev
```

<details>
<summary>💡 Resultado esperado</summary>

```
🎮 PIKACHU
   Altura: 0.4m
   Peso: 6kg
   Tipos: electric
```

</details>

---

### 🧪 Retos adicionales

#### ⭐ Nivel 1
Modifiquen el código para que reciba el nombre del Pokémon como argumento de línea de comandos (`process.argv[2]`).

#### ⭐⭐ Nivel 2
Agreguen el paquete `chalk` para colorear la salida en la terminal. Instálenlo con `npm install chalk` y úsenlo para mostrar el nombre del Pokémon en amarillo.

#### ⭐⭐⭐ Nivel 3
Creen un script `build` que compile el TypeScript a JavaScript, y un script `start` que ejecute el código compilado. Configuren correctamente `tsconfig.json` para que compile a la carpeta `dist/`.

<details>
<summary>💡 Pistas para los retos</summary>

**Nivel 1:**
```typescript
const nombre = process.argv[2] || 'pikachu';
obtenerPokemon(nombre);
```
Ejecuten con: `npm run dev -- charizard`

**Nivel 2:**
```bash
npm install chalk
```
```typescript
import chalk from 'chalk';
console.log(chalk.yellow.bold(`🎮 ${response.data.name.toUpperCase()}`));
```

**Nivel 3:**
En `tsconfig.json`:
```json
{
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src"
  }
}
```
En `package.json`:
```json
"scripts": {
  "build": "tsc",
  "start": "node dist/index.js",
  "dev": "ts-node src/index.ts"
}
```

</details>

---

## 📚 Recursos adicionales

- [Documentación oficial de npm](https://docs.npmjs.com/)
- [npm trends](https://npmtrends.com/) — Comparar popularidad de paquetes
- [Bundlephobia](https://bundlephobia.com/) — Ver el tamaño de un paquete antes de instalarlo
- [Socket.dev](https://socket.dev/) — Verificar seguridad de paquetes
