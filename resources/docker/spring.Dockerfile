# --- Build Stage ---
ARG GRADLE_VERSION=7.6
# Use the JDK 17 version of the Gradle image so it can compile Java 17 code!
FROM gradle:${GRADLE_VERSION}-jdk17 AS builder
WORKDIR /app

# Copy everything into the container
COPY . .

# Build the application (using the Gradle wrapper if you have it, otherwise fallback to gradle)
# If you don't have a wrapper (gradlew), just leave it as 'gradle build -x test'
RUN chmod +x ./gradlew
RUN gradle build -x test

# --- Runtime Stage ---
FROM eclipse-temurin:17-jre 
ARG PORT=8080
ENV PORT=${PORT}
WORKDIR /app

COPY --from=builder /app/build/libs/*[!plain].jar app.jar

VOLUME [ "/app/filestorage/images" ]
EXPOSE ${PORT}

ENTRYPOINT ["sh", "-c", "java -jar app.jar --server.port=${PORT}"]
