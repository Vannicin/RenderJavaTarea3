# Etapa de construcción
FROM maven:3.9.3-amazoncorretto-21 AS build
WORKDIR /app
# Copia primero el archivo pom.xml para aprovechar la caché y descargar dependencias
COPY pom.xml .
RUN mvn dependency:go-offline
# Copia el resto del código fuente
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa de ejecución
FROM openjdk:21-slim
WORKDIR /app
# Copia el jar generado en la etapa de build
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
