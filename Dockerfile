# ============================================
# STAGE 1: Compilar con Maven
# ============================================
FROM eclipse-temurin:17-jdk-alpine AS builder

WORKDIR /app

# Copiar archivos de configuración Maven primero (caché de dependencias)
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./

# Dar permisos al wrapper de Maven
RUN chmod +x mvnw

# Descargar dependencias (se cachean si pom.xml no cambia)
RUN ./mvnw dependency:go-offline -B

# Copiar el código fuente
COPY src/ ./src/

# Compilar y empaquetar (saltando tests para agilizar el build)
RUN ./mvnw package -DskipTests -B

# ============================================
# STAGE 2: Imagen de producción (solo JRE)
# ============================================
FROM eclipse-temurin:17-jre-alpine AS production

WORKDIR /app

# Crear usuario no root (principio de mínimo privilegio)
RUN addgroup -g 1001 appgroup && \
    adduser -u 1001 -G appgroup -s /bin/sh -D appuser

# Copiar solo el JAR compilado desde el stage anterior
COPY --from=builder /app/target/*.jar app.jar

# Asignar permisos al usuario no root
RUN chown appuser:appgroup app.jar

# Usar usuario no root
USER appuser

# Puerto que expone el backend (definido en application.properties)
EXPOSE 8081

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD wget -qO- http://localhost:8081/actuator/health || exit 1

# Comando de inicio
ENTRYPOINT ["java", "-jar", "app.jar"]