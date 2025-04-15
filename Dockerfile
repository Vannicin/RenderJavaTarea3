# Etapa de construcción: Usamos una imagen base con Java 21 e instalamos Maven manualmente.
FROM eclipse-temurin:21 as build

# Actualizamos e instalamos Maven.
RUN apt-get update && apt-get install -y maven

WORKDIR /app
# Copia el archivo pom.xml y descarga las dependencias para aprovechar la caché.
COPY pom.xml .
RUN mvn dependency:go-offline

# Copia el resto del código fuente.
COPY src ./src
# Compila el proyecto y genera el JAR; si prefieres correr las pruebas, elimina -DskipTests.
RUN mvn clean package -DskipTests

# Etapa de ejecución: Usamos una imagen ligera con Java 21 para ejecutar la aplicación.
FROM openjdk:21-slim
WORKDIR /app
# Copia el JAR generado en la etapa anterior.
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
