# --- Build Stage ---
ARG GRADLE_VERSION=7.6
FROM gradle:${GRADLE_VERSION} AS builder
WORKDIR /app

# 1. Copy only Gradle config first to leverage Docker caching for dependencies
COPY build.gradle settings.gradle ./
# If you have a gradle/ wrapper folder, copy that too: COPY gradle ./gradle

# 2. Copy source code and build
COPY src ./src
RUN gradle build -x test  

# --- Runtime Stage ---
# 3. Use JRE instead of JDK for a smaller, more secure runtime image
FROM eclipse-temurin:17-jre 
ARG PORT=8080
ENV PORT=${PORT}
WORKDIR /app

# 4. Copy the executable JAR. 
# Note: If this is Spring Boot, it prevents copying the "-plain.jar" alongside the main jar.
# If your jar naming is different, adjust the wildcard accordingly.
COPY --from=builder /app/build/libs/*[!plain].jar app.jar

VOLUME [ "/app/filestorage/images" ]
EXPOSE ${PORT}

# 5. Run via 'sh -c' so the ${PORT} environment variable actually resolves
ENTRYPOINT ["sh", "-c", "java -jar app.jar --server.port=${PORT}"]
