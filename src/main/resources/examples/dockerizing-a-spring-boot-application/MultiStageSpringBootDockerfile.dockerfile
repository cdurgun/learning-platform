# Stage 1: build the JAR with Maven -- this stage's contents never reach the final image.
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /build

COPY pom.xml .
COPY src ./src

RUN mvn -B package -DskipTests

# Stage 2: run it with just a JRE -- no Maven, no JDK, no source code.
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=builder /build/target/learning-platform-0.1.0-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
