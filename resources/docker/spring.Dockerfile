FROM eclipse-temurin:25-jdk AS builder

WORKDIR /app

COPY build.gradle settings.gradle ./
COPY gradle ./gradle
COPY --chmod=755 gradlew ./gradlew

RUN ./gradlew dependencies --no-daemon

COPY src ./src

RUN ./gradlew clean build -x test --no-daemon


FROM eclipse-temurin:25-jre-ubi10-minimal

WORKDIR /app

RUN mkdir -p /app/images

COPY --from=builder /app/build/libs/app.jar ./app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]