#!/bin/sh
# Everything "Docker Networking" and "Docker Volumes" typed by hand --
# docker network create, docker volume create, and two docker run commands
# -- replaced by a single docker-compose.yml and one command.

docker compose up -d
# Output (trimmed):
# [+] Running 3/3
# => Network learning-platform_default   Created
# => Volume "learning-platform_db-data"  Created
# => Container learning-platform-db-1    Started
# => Container learning-platform-app-1   Started

docker compose ps
# Output:
# NAME                        IMAGE          STATUS         PORTS
# learning-platform-app-1     learning-platform-app   Up 5 seconds   0.0.0.0:8080->8080/tcp
# learning-platform-db-1      postgres:16             Up 5 seconds   5432/tcp

docker compose logs app
# Output (trimmed):
# app-1  | Started LearningPlatformApplication in 3.2 seconds

curl http://localhost:8080/en
# Output (trimmed):
# <!doctype html> ... the homepage renders, meaning app reached db by service name ...

# Stop and remove everything Compose created -- containers and the default
# network. The named volume, "learning-platform_db-data", is deliberately
# left behind (see "Docker Volumes") -- it needs an explicit -v to remove.
docker compose down
# Output (trimmed):
# => Container learning-platform-app-1   Removed
# => Container learning-platform-db-1    Removed
# => Network learning-platform_default   Removed

# The data survives -- confirm the volume is still there.
docker volume ls
# Output:
# DRIVER    VOLUME NAME
# local     learning-platform_db-data
