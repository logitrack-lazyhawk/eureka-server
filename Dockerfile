# ==========================================
# ETAPA 1: BUILD (Compilación con Maven)
# ==========================================
FROM maven:3.9.11-eclipse-temurin-25 AS build
WORKDIR /app

# Copiamos el pom.xml y descargamos dependencias (caché)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copiamos el código fuente y compilamos
COPY src ./src
RUN mvn clean package -DskipTests

# ==========================================
# ETAPA 2: RUN (Ejecución ligera)
# ==========================================
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app

# Copiamos el JAR generado en la etapa anterior
COPY --from=build /app/target/*.jar app.jar

# Puerto que expone Eureka
EXPOSE 8065

# Comando de ejecución
ENTRYPOINT ["java", "-jar", "app.jar"]