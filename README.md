# ⚙️ Backend Despachos — Innovatech Chile

API REST para gestión de despachos de Innovatech Chile, desarrollada con Spring Boot 3 + Java 17 y MySQL, desplegada en AWS EC2.

## 🛠️ Tecnologías
- Java 17 + Spring Boot 3.4.4
- Spring Data JPA + MySQL 8.0
- Maven (gestión de dependencias)
- Docker con multi-stage build
- GitHub Actions (CI/CD)
- Amazon ECR

## 🚀 Ejecutar localmente

### Con Docker (recomendado)
```bash
docker compose up --build
# API disponible en http://localhost:8081
```

## 🔌 Endpoints API
| Método | Ruta | Descripción |
|--------|------|---|
| GET | `/api/v1/despachos` | Listar todos los despachos |
| POST | `/api/v1/despachos` | Crear despacho |
| PUT | `/api/v1/despachos/{id}` | Actualizar despacho |
| DELETE | `/api/v1/despachos/{id}` | Eliminar despacho |
| GET | `/swagger-ui/index.html` | Documentación OpenAPI |

## 🐳 Dockerfile — Multi-stage build

**Stage 1 (builder):** `eclipse-temurin:17-jdk-alpine` — compila el proyecto con Maven (`./mvnw package`)
**Stage 2 (production):** `eclipse-temurin:17-jre-alpine` — imagen mínima con solo el JRE y el JAR

Usuario **no root** (appuser, UID 1001) para seguridad.

## 🗄️ Persistencia de datos

Se usa **named volume** (`mysql_data`) para la base de datos MySQL. Los datos persisten aunque el contenedor se detenga o elimine.

**Named volume vs Bind mount:**
- Named volume: gestionado por Docker, portable, no depende de la ruta del host → ✅ producción
- Bind mount: montaje directo del sistema de archivos del host → desarrollo local

## 📁 Variables de entorno
| Variable | Descripción |
|---|---|
| `DB_ENDPOINT` | Host de MySQL (dentro de Docker: `db`) |
| `DB_PORT` | Puerto MySQL (3306) |
| `DB_NAME` | Nombre de la base de datos |
| `DB_USERNAME` | Usuario MySQL |
| `DB_PASSWORD` | Contraseña MySQL |
