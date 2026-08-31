#!/bin/sh
# Building this project's own image with the multi-stage Dockerfile -- no
# local Maven or JDK install required, Docker builds the JAR internally --
# and running it against the PostgreSQL container from "Docker CLI Fundamentals".

docker build -t learning-platform:0.1.0 .
# Output (trimmed):
# [+] Building 42.7s (14/14) FINISHED
# => [builder 1/4] FROM docker.io/library/maven:3.9-eclipse-temurin-21
# => [builder 4/4] RUN mvn -B package -DskipTests
# => [stage-1 3/3] COPY --from=builder /build/target/learning-platform-0.1.0-SNAPSHOT.jar app.jar
# => naming to docker.io/library/learning-platform:0.1.0

docker run -d --name learning-platform-app \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5432/postgres \
  -e SPRING_DATASOURCE_PASSWORD=secret \
  learning-platform:0.1.0
# Output:
# 9b8c7d6e5f4a3b2c1d0e9f8a7b6c5d4e3f2a1b0c9d8e7f6a5b4c3d2e1f0a9b8c

docker logs -f learning-platform-app
# Output (trimmed):
# Started LearningPlatformApplication in 3.1 seconds

curl http://localhost:8080/en
# Output (trimmed):
# <!doctype html>
# <html> ... the actual homepage this project renders ...

docker stop learning-platform-app
docker rm learning-platform-app
