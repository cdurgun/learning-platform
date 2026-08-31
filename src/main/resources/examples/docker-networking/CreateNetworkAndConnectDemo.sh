#!/bin/sh
# Running this project's own app and its PostgreSQL database as two separate
# containers that reach each other by name, instead of the host.docker.internal
# workaround "Dockerizing a Spring Boot Application" used as a stand-in.

docker network create learning-platform-net
# Output:
# 4a3b2c1d0e9f8a7b6c5d4e3f2a1b0c9d8e7f6a5b4c3d2e1f0a9b8c7d6e5f4a3b

docker run --name learning-platform-db \
  --network learning-platform-net \
  -e POSTGRES_PASSWORD=secret \
  -d postgres:16
# Output:
# 7f8e9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f

docker run --name learning-platform-app \
  --network learning-platform-net \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://learning-platform-db:5432/postgres \
  -e SPRING_DATASOURCE_PASSWORD=secret \
  -d learning-platform:0.1.0
# Output:
# 9b8c7d6e5f4a3b2c1d0e9f8a7b6c5d4e3f2a1b0c9d8e7f6a5b4c3d2e1f0a9b8c

# Note the datasource URL: "learning-platform-db" -- the OTHER container's
# --name -- resolves automatically over this user-defined network, no IP
# address and no host.docker.internal needed. Confirm it actually worked:

docker logs learning-platform-app
# Output (trimmed):
# Started LearningPlatformApplication in 3.4 seconds

curl http://localhost:8080/en
# Output (trimmed):
# <!doctype html> ... the homepage renders, meaning the app reached the database ...

docker network inspect learning-platform-net --format '{{range .Containers}}{{.Name}} {{end}}'
# Output:
# learning-platform-db learning-platform-app

# Clean up.
docker stop learning-platform-app learning-platform-db
docker rm learning-platform-app learning-platform-db
docker network rm learning-platform-net
