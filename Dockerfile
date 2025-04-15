# Etapa de construcción
FROM maven:3.9.3-eclipse-temurin-21 AS build
WORKDIR /app
# Copia primero los archivos de configuración para aprovechar la caché (pom.xml, etc.)
COPY pom.xml .
# Descarga las dependencias (esto mejora el caching)
RUN mvn dependency:go-offline
# Copia el resto del código fuente
COPY src ./src
# Construye el proyecto y salta las pruebas para agilizar el build (puedes quitar -DskipTests si lo deseas)
RUN mvn clean package -DskipTests

# Etapa de ejecución
FROM openjdk:21-slim
WORKDIR /app
# Copia el jar generado en la etapa de build
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
