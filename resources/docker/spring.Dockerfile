# --- Build Stage ---
ARG GRADLE_VERSION=7.6
FROM gradle:${GRADLE_VERSION}-jdk17 AS builder
WORKDIR /app

# Copy all project files into the container
COPY . .

# Build using the system Gradle installed in the base image
RUN gradle build -x test

# --- Runtime Stage ---
FROM eclipse-temurin:17-jre 
ARG PORT=8080
ENV PORT=${PORT}
WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /app/build/libs/*[!plain].jar app.jar

VOLUME [ "/app/filestorage/images" ]
EXPOSE ${PORT}

ENTRYPOINT ["sh", "-c", "java -jar app.jar --server.port=${PORT}"]
