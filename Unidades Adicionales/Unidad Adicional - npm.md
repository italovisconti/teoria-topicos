# Unidad Adicional: Node Package Manager (npm)

> [!NOTE] **Contexto**
> Esta unidad complementaria introduce npm como herramienta fundamental para el desarrollo moderno con TypeScript y JavaScript. npm no solo gestiona dependencias, sino que es el ecosistema que hace posible la programación modular y la reutilización de código a escala global.
> Mas info en https://www.freecodecamp.org/espanol/news/node-js-npm-tutorial/

---

## ¿Qué es npm?

**npm** (Node Package Manager) es el **gestor de paquetes** más grande del mundo para JavaScript/TypeScript. Piensa en npm como:

- **Un supermercado de código**: En lugar de escribir todo desde cero, puedes "comprar" (descargar) código que otros desarrolladores ya escribieron y probaron.
- **Una biblioteca universal**: Con más de 2 millones de paquetes disponibles.
- **Un asistente de proyecto**: Maneja dependencias, scripts, versiones y configuraciones.

### Analogía del Mundo Real

Imagina que estás construyendo una casa:

| Sin npm | Con npm |
|---------|---------|
| Fabricas tus propios ladrillos | Compras ladrillos pre-fabricados |
| Cortas y procesas tu propia madera | Compras madera lista para usar |
| Creas tus propias herramientas | Alquilas/compras herramientas especializadas |
| **Tiempo**: 5 años | **Tiempo**: 1 año |

**npm hace exactamente eso con el código**: te permite usar "ladrillos de código" (paquetes) que otros desarrolladores ya crearon, probaron y mantienen.

---

## Conceptos Fundamentales

### 1. **Paquete (Package)**

Un paquete es una carpeta con código reutilizable que incluye:
- Código JavaScript/TypeScript
- Un archivo `package.json` con metadatos
- Documentación (README.md)
- Tests (opcional)

**Ejemplo del mundo real**: El paquete `axios` es como un "asistente de peticiones HTTP" que hace 20+ millones de descargas semanales.

### 2. **Dependencias**

Son los paquetes que **tu proyecto necesita** para funcionar.

Existen 3 tipos:

#### a) **Dependencies** (Producción)
Paquetes que tu aplicación **necesita para funcionar** en el servidor/navegador del usuario final.

```json
"dependencies": {
  "express": "^4.18.2",      // Servidor web
  "axios": "^1.6.0"          // Cliente HTTP
}
```

#### b) **DevDependencies** (Desarrollo)
Paquetes que **solo necesitas mientras desarrollas**, no en producción.

```json
"devDependencies": {
  "typescript": "^5.3.0",    // Compilador TS
  "@types/node": "^20.10.0", // Tipos para Node.js
  "jest": "^29.7.0"          // Framework de testing
}
```

#### c) **PeerDependencies** (Pares)
Paquetes que tu librería **espera que el proyecto anfitrión ya tenga instalados**.

```json
"peerDependencies": {
  "react": ">=16.8.0"        // Tu librería necesita React, pero no lo incluye
}
```

### 3. **Versionado Semántico (SemVer)**

npm usa el sistema **MAJOR.MINOR.PATCH** (ej: `2.4.1`):

```
  2  .  4  .  1
  |     |     |
MAJOR MINOR PATCH
```

- **PATCH** (1): Corrección de bugs (cambios retrocompatibles)
- **MINOR** (4): Nuevas funcionalidades (retrocompatibles)
- **MAJOR** (2): Cambios que rompen compatibilidad

#### Símbolos de Versión

| Símbolo | Significado | Ejemplo | Permite |
|---------|-------------|---------|---------|
| `^` | Compatible con MINOR | `^2.4.1` | `2.4.1` hasta `2.x.x` |
| `~` | Compatible con PATCH | `~2.4.1` | `2.4.1` hasta `2.4.x` |
| `*` | Cualquier versión | `*` | Última versión |
| Sin símbolo | Versión exacta | `2.4.1` | Solo `2.4.1` |

**Ejemplo práctico**:
```json
{
  "dependencies": {
    "lodash": "^4.17.21",    // Permite 4.17.21 hasta 4.x.x
    "moment": "~2.29.4",     // Permite 2.29.4 hasta 2.29.x
    "react": "18.2.0"        // Solo exactamente 18.2.0
  }
}
```

---

## Estructura del `package.json`

Este archivo es el **ADN de tu proyecto**. Veamos un ejemplo completo:

```json
{
  "name": "mi-proyecto-typescript",
  "version": "1.0.0",
  "description": "Sistema de gestión de torneos Pokemon",
  "main": "dist/index.js",
  "scripts": {
    "dev": "ts-node src/index.ts",
    "build": "tsc",
    "test": "jest",
    "start": "node dist/index.js"
  },
  "keywords": ["pokemon", "typescript", "async"],
  "author": "Tu Nombre <email@example.com>",
  "license": "MIT",
  "dependencies": {
    "axios": "^1.6.0",
    "express": "^4.18.2"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "@types/node": "^20.10.0",
    "jest": "^29.7.0",
    "ts-node": "^10.9.2",
    "typescript": "^5.3.0"
  }
}
```

### Campos Importantes

| Campo | Propósito | Ejemplo |
|-------|-----------|---------|
| `name` | Nombre único del paquete | `"pokemon-tournament"` |
| `version` | Versión actual | `"1.0.0"` |
| `main` | Punto de entrada | `"dist/index.js"` |
| `scripts` | Comandos personalizados | `"build": "tsc"` |
| `dependencies` | Dependencias de producción | `{ "express": "^4.18.2" }` |
| `devDependencies` | Dependencias de desarrollo | `{ "typescript": "^5.3.0" }` |

---

## Comandos Esenciales de npm

### Iniciando un Proyecto

```bash
# Crear package.json interactivamente
npm init

# Crear package.json con valores por defecto
npm init -y
```

### Instalando Paquetes

```bash
# Instalar dependencia de producción
npm install express
npm i express              # Forma corta

# Instalar dependencia de desarrollo
npm install --save-dev typescript
npm i -D typescript        # Forma corta

# Instalar versión específica
npm install lodash@4.17.21

# Instalar globalmente (disponible en todo el sistema)
npm install -g typescript
```

### Información de Paquetes

```bash
# Ver paquetes instalados
npm list
npm ls --depth=0          # Solo nivel superior

# Ver paquetes desactualizados
npm outdated

# Ver información de un paquete
npm info axios
```

### Actualizando Paquetes

```bash
# Actualizar un paquete específico
npm update axios

# Actualizar todos los paquetes (respetando SemVer)
npm update

# Actualizar a versión específica
npm install axios@latest
```

### Desinstalando Paquetes

```bash
# Desinstalar dependencia
npm uninstall express
npm un express            # Forma corta
```

### Ejecutando Scripts

```bash
# Ejecutar script definido en package.json
npm run build
npm run test

# Scripts especiales (sin "run")
npm start
npm test
```

---

## Casos de Uso Reales

### Caso 1: Proyecto Pequeño para Estudiantes

**Contexto**: Crear una aplicación CLI (Command Line Interface) que consulte datos de Pokémon.

#### Paso 1: Inicializar el proyecto

```bash
mkdir pokemon-cli
cd pokemon-cli
npm init -y
```

#### Paso 2: Instalar dependencias

```bash
# Dependencias de producción
npm install axios              # Para hacer peticiones HTTP

# Dependencias de desarrollo
npm install -D typescript @types/node ts-node
```

#### Paso 3: Configurar `package.json`

```json
{
  "name": "pokemon-cli",
  "version": "1.0.0",
  "scripts": {
    "start": "ts-node src/index.ts",
    "build": "tsc"
  },
  "dependencies": {
    "axios": "^1.6.0"
  },
  "devDependencies": {
    "@types/node": "^20.10.0",
    "ts-node": "^10.9.2",
    "typescript": "^5.3.0"
  }
}
```

#### Paso 4: Crear `tsconfig.json`

```bash
npx tsc --init
```

#### Paso 5: Código de ejemplo (`src/index.ts`)

```typescript
import axios from 'axios';

interface Pokemon {
  name: string;
  height: number;
  weight: number;
}

async function getPokemon(name: string): Promise<Pokemon> {
  const response = await axios.get(`https://pokeapi.co/api/v2/pokemon/${name}`);
  return {
    name: response.data.name,
    height: response.data.height,
    weight: response.data.weight
  };
}

// Usar la función
getPokemon('pikachu').then(pokemon => {
  console.log(`${pokemon.name}: altura=${pokemon.height}, peso=${pokemon.weight}`);
});
```

#### Paso 6: Ejecutar

```bash
npm start
# Output: pikachu: altura=4, peso=60
```

---

### Caso 2: Proyecto Mediano (API REST)

**Contexto**: Sistema de gestión de usuarios con Express y TypeScript.

#### Estructura del proyecto

```
user-management-api/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts
│   ├── routes/
│   │   └── users.ts
│   ├── models/
│   │   └── User.ts
│   └── controllers/
│       └── UserController.ts
└── dist/            # Código compilado
```

#### `package.json` completo

```json
{
  "name": "user-management-api",
  "version": "1.0.0",
  "description": "API REST para gestión de usuarios",
  "main": "dist/index.js",
  "scripts": {
    "dev": "ts-node-dev --respawn src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "jest",
    "lint": "eslint src/**/*.ts",
    "format": "prettier --write src/**/*.ts"
  },
  "dependencies": {
    "express": "^4.18.2",
    "dotenv": "^16.3.1",
    "cors": "^2.8.5"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "@types/node": "^20.10.0",
    "@types/cors": "^2.8.17",
    "typescript": "^5.3.0",
    "ts-node-dev": "^2.0.0",
    "jest": "^29.7.0",
    "@types/jest": "^29.5.11",
    "eslint": "^8.56.0",
    "prettier": "^3.1.1"
  }
}
```

#### Ejemplo de código (`src/index.ts`)

```typescript
import express, { Application, Request, Response } from 'express';
import cors from 'cors';

const app: Application = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Ruta de ejemplo
app.get('/api/users', (req: Request, res: Response) => {
  res.json({ users: ['Alice', 'Bob', 'Charlie'] });
});

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
```

#### Flujo de trabajo

```bash
# Desarrollo (recarga automática)
npm run dev

# Testing
npm test

# Formatear código
npm run format

# Compilar para producción
npm run build

# Ejecutar en producción
npm start
```

---

### 🏗️ Caso 3: Proyecto Grande (Aplicación Empresarial)

**Contexto**: Sistema de e-commerce con microservicios, monorepo y CI/CD.

#### Estructura del monorepo

```
ecommerce-platform/
├── package.json                 # Raíz del monorepo
├── packages/
│   ├── frontend/               # App React
│   │   └── package.json
│   ├── backend-api/            # API Gateway
│   │   └── package.json
│   ├── auth-service/           # Microservicio de autenticación
│   │   └── package.json
│   ├── payment-service/        # Microservicio de pagos
│   │   └── package.json
│   └── shared-types/           # Tipos compartidos
│       └── package.json
└── node_modules/
```

#### `package.json` raíz (usando workspaces)

```json
{
  "name": "ecommerce-platform",
  "version": "1.0.0",
  "private": true,
  "workspaces": [
    "packages/*"
  ],
  "scripts": {
    "dev": "npm run dev --workspaces --if-present",
    "build": "npm run build --workspaces --if-present",
    "test": "npm run test --workspaces --if-present",
    "lint": "eslint packages/*/src/**/*.ts",
    "format": "prettier --write packages/*/src/**/*.ts",
    "typecheck": "tsc --noEmit --project tsconfig.json"
  },
  "devDependencies": {
    "@typescript-eslint/eslint-plugin": "^6.15.0",
    "@typescript-eslint/parser": "^6.15.0",
    "eslint": "^8.56.0",
    "prettier": "^3.1.1",
    "typescript": "^5.3.0",
    "husky": "^8.0.3",
    "lint-staged": "^15.2.0"
  }
}
```

#### `packages/backend-api/package.json`

```json
{
  "name": "@ecommerce/backend-api",
  "version": "1.0.0",
  "scripts": {
    "dev": "ts-node-dev src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "jest --coverage",
    "docker:build": "docker build -t ecommerce-api .",
    "docker:run": "docker run -p 3000:3000 ecommerce-api"
  },
  "dependencies": {
    "express": "^4.18.2",
    "jsonwebtoken": "^9.0.2",
    "helmet": "^7.1.0",
    "morgan": "^1.10.0",
    "redis": "^4.6.11",
    "prisma": "^5.7.1",
    "@ecommerce/shared-types": "^1.0.0"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "@types/jsonwebtoken": "^9.0.5",
    "ts-node-dev": "^2.0.0",
    "jest": "^29.7.0",
    "supertest": "^6.3.3"
  }
}
```

#### Características avanzadas

**1. npm Workspaces** (para monorepos)

```bash
# Instalar dependencias en todos los workspaces
npm install

# Agregar paquete a workspace específico
npm install axios --workspace=packages/backend-api

# Ejecutar script en todos los workspaces
npm run test --workspaces
```

**2. Scripts de Pre/Post**

```json
{
  "scripts": {
    "prebuild": "npm run lint",      // Se ejecuta ANTES de build
    "build": "tsc",
    "postbuild": "npm run copy-assets", // Se ejecuta DESPUÉS de build
    "copy-assets": "cp -r assets dist/"
  }
}
```

**3. Variables de Entorno**

```json
{
  "scripts": {
    "dev": "NODE_ENV=development ts-node src/index.ts",
    "prod": "NODE_ENV=production node dist/index.js"
  }
}
```

**4. Hooks con Husky**

```json
{
  "scripts": {
    "prepare": "husky install"
  },
  "lint-staged": {
    "*.ts": [
      "eslint --fix",
      "prettier --write",
      "git add"
    ]
  }
}
```

---

## 🛡️ Buenas Prácticas

### ✅ Para Proyectos Pequeños/Estudiantes

1. **Usa `npm init -y`** para comenzar rápidamente
2. **Instala solo lo necesario**: No agregues paquetes "por si acaso"
3. **Versiona `package.json`** en Git (pero NO `node_modules/`)
4. **Documenta scripts** con comentarios en README

```json
{
  "scripts": {
    "start": "ts-node src/index.ts",  // Inicia la app en desarrollo
    "build": "tsc"                     // Compila TypeScript
  }
}
```

### ✅ Para Proyectos Grandes/Empresariales

1. **Usa `package-lock.json`**: Garantiza versiones exactas en todos los entornos
2. **Define versiones exactas** para dependencias críticas:
   ```json
   {
     "dependencies": {
       "critical-lib": "2.4.1"  // Sin ^ ni ~
     }
   }
   ```

3. **Separa dependencias** correctamente:
   - `dependencies`: Lo que va a producción
   - `devDependencies`: Herramientas de desarrollo
   - `peerDependencies`: Para librerías compartidas

4. **Audita seguridad** regularmente:
   ```bash
   npm audit
   npm audit fix
   ```

5. **Usa scoped packages** para organizar:
   ```json
   {
     "dependencies": {
       "@tuempresa/auth": "^1.0.0",
       "@tuempresa/utils": "^2.1.0"
     }
   }
   ```

6. **Configura `.npmrc`** para políticas de equipo:
   ```
   save-exact=true
   engine-strict=true
   ```

---

## 🔒 Archivos Importantes

### `.gitignore`

**Siempre** excluye `node_modules/` de Git:

```gitignore
# Dependencias
node_modules/

# Archivos compilados
dist/
build/

# Variables de entorno
.env
.env.local

# Logs
npm-debug.log*
```

### `package-lock.json`

- **SÍ versionarlo** en Git
- Garantiza que todos instalen las mismas versiones exactas
- Se genera automáticamente con `npm install`

**Diferencia con `package.json`**:

| `package.json` | `package-lock.json` |
|----------------|---------------------|
| Versiones flexibles (`^`, `~`) | Versiones exactas |
| Escrito manualmente | Generado automáticamente |
| Define dependencias directas | Define TODO el árbol de dependencias |

---

## 🎓 Ejercicios Prácticos

### 🎯 Ejercicio 1: Proyecto CLI Básico

**Objetivo**: Crear una CLI que muestre el clima de una ciudad usando una API pública.

**Pasos**:
1. Inicializar proyecto con npm
2. Instalar `axios` y `dotenv`
3. Crear script que consulte [OpenWeather API](https://openweathermap.org/api)
4. Compilar y ejecutar

<details>
<summary>💡 Ver solución</summary>

```bash
# 1. Inicializar proyecto
mkdir weather-cli && cd weather-cli
npm init -y

# 2. Instalar dependencias
npm install axios dotenv
npm install -D typescript @types/node ts-node

# 3. Crear tsconfig.json
npx tsc --init
```

**`src/index.ts`**:
```typescript
import axios from 'axios';
import * as dotenv from 'dotenv';

dotenv.config();

interface WeatherData {
  main: {
    temp: number;
    humidity: number;
  };
  weather: Array<{ description: string }>;
}

async function getWeather(city: string): Promise<void> {
  const API_KEY = process.env.OPENWEATHER_API_KEY;
  const url = `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${API_KEY}&units=metric`;
  
  try {
    const response = await axios.get<WeatherData>(url);
    const { temp, humidity } = response.data.main;
    const description = response.data.weather[0].description;
    
    console.log(`🌤️ Clima en ${city}:`);
    console.log(`   Temperatura: ${temp}°C`);
    console.log(`   Humedad: ${humidity}%`);
    console.log(`   Condición: ${description}`);
  } catch (error) {
    console.error('❌ Error al obtener el clima');
  }
}

const city = process.argv[2] || 'Caracas';
getWeather(city);
```

**`package.json`**:
```json
{
  "scripts": {
    "start": "ts-node src/index.ts"
  }
}
```

**Ejecutar**:
```bash
npm start Caracas
```

</details>

---

### 🎯 Ejercicio 2: API REST con Express

**Objetivo**: Crear una API de gestión de tareas (TODO app) con persistencia en memoria.

**Requisitos**:
- Endpoints: GET, POST, PUT, DELETE
- TypeScript con tipado completo
- Validación de datos

<details>
<summary>💡 Ver solución</summary>

```bash
# Inicializar
mkdir todo-api && cd todo-api
npm init -y

# Instalar dependencias
npm install express cors
npm install -D typescript @types/express @types/node @types/cors ts-node-dev
```

**`src/index.ts`**:
```typescript
import express, { Application, Request, Response } from 'express';
import cors from 'cors';

const app: Application = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Modelo
interface Todo {
  id: number;
  title: string;
  completed: boolean;
}

let todos: Todo[] = [];
let nextId = 1;

// Rutas
app.get('/api/todos', (req: Request, res: Response) => {
  res.json(todos);
});

app.post('/api/todos', (req: Request, res: Response) => {
  const { title } = req.body;
  
  if (!title) {
    return res.status(400).json({ error: 'Title is required' });
  }
  
  const newTodo: Todo = {
    id: nextId++,
    title,
    completed: false
  };
  
  todos.push(newTodo);
  res.status(201).json(newTodo);
});

app.put('/api/todos/:id', (req: Request, res: Response) => {
  const id = parseInt(req.params.id);
  const todo = todos.find(t => t.id === id);
  
  if (!todo) {
    return res.status(404).json({ error: 'Todo not found' });
  }
  
  todo.completed = !todo.completed;
  res.json(todo);
});

app.delete('/api/todos/:id', (req: Request, res: Response) => {
  const id = parseInt(req.params.id);
  const index = todos.findIndex(t => t.id === id);
  
  if (index === -1) {
    return res.status(404).json({ error: 'Todo not found' });
  }
  
  todos.splice(index, 1);
  res.status(204).send();
});

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
```

**`package.json`**:
```json
{
  "scripts": {
    "dev": "ts-node-dev --respawn src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"
  }
}
```

**Probar**:
```bash
npm run dev

# En otra terminal:
curl -X POST http://localhost:3000/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Estudiar npm"}'
```

</details>

---

## 🚨 Problemas Comunes y Soluciones

### ❌ "Cannot find module 'xxx'"

**Causa**: Paquete no instalado o `node_modules/` eliminado.

**Solución**:
```bash
npm install
```

---

### ❌ "EACCES: permission denied"

**Causa**: Intentando instalar globalmente sin permisos.

**Solución** (Linux/Mac):
```bash
# Opción 1: Usar npx (recomendado)
npx typescript --version

# Opción 2: Cambiar ubicación global de npm
npm config set prefix ~/.npm-global
export PATH=~/.npm-global/bin:$PATH
```

---

### ❌ Versiones incompatibles

**Causa**: Conflictos entre versiones de dependencias.

**Solución**:
```bash
# Limpiar caché
npm cache clean --force

# Eliminar node_modules y package-lock.json
rm -rf node_modules package-lock.json

# Reinstalar
npm install
```

---

## 📚 Recursos Adicionales

### Documentación Oficial
- [npmjs.com](https://www.npmjs.com/) - Búsqueda de paquetes
- [docs.npmjs.com](https://docs.npmjs.com/) - Documentación completa

### Alternativas a npm
- **Yarn**: Más rápido, con workspaces nativos
- **pnpm**: Ahorra espacio en disco (links simbólicos)

### Herramientas Útiles
- **npx**: Ejecuta paquetes sin instalarlos globalmente
  ```bash
  npx create-react-app mi-app
  npx typescript --version
  ```

- **npm-check-updates**: Actualiza todas las dependencias
  ```bash
  npx npm-check-updates -u
  npm install
  ```

---

## 🎯 Preguntas de Reflexión

1. ¿Por qué es importante usar `package-lock.json` en proyectos colaborativos?
2. ¿Cuándo usarías `dependencies` vs `devDependencies`?
3. ¿Qué significa el símbolo `^` en `"express": "^4.18.2"`?
4. ¿Por qué NO debes versionar `node_modules/` en Git?
5. ¿Cuál es la diferencia entre `npm install` y `npm install --save-dev`?

---

## 📝 Resumen Ejecutivo

| Concepto | Descripción | Comando Clave |
|----------|-------------|---------------|
| **Inicializar** | Crear `package.json` | `npm init -y` |
| **Instalar** | Agregar dependencia | `npm install <paquete>` |
| **Ejecutar** | Correr script | `npm run <script>` |
| **Actualizar** | Actualizar paquetes | `npm update` |
| **Auditar** | Revisar seguridad | `npm audit` |
| **Desinstalar** | Remover paquete | `npm uninstall <paquete>` |

**🎓 Takeaway**: npm es el ecosistema que hace posible el desarrollo moderno. Dominar npm significa entender cómo construir, mantener y escalar aplicaciones profesionales usando código de la comunidad global de desarrolladores.

---

**Última actualización**: Octubre 2025 | **Prof. Italo Visconti**
https://www.freecodecamp.org/espanol/news/node-js-npm-tutorial/