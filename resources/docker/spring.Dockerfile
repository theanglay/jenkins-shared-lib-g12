# syntax=docker/dockerfile:1

# ---------- Build Stage ----------
FROM gradle:jdk25-ubi10 AS builder

WORKDIR /app

# Copy Gradle wrapper/config first for dependency caching
COPY build.gradle settings.gradle ./
COPY gradle ./gradle
COPY --chmod=755 gradlew ./gradlew

# Download dependencies
RUN ./gradlew dependencies --no-daemon

# Copy application source
COPY src ./src

# If your application needs config during build:
# COPY config ./config

# Build application
RUN ./gradlew clean build -x test --no-daemon


# ---------- Runtime Stage ----------
FROM eclipse-temurin:25-jre-ubi10-minimal

WORKDIR /app

RUN mkdir -p /app/images

COPY --from=builder /app/build/libs/*.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]