#!/bin/sh
# A developer needs a local PostgreSQL instance to run this project against,
# without installing PostgreSQL itself on their own machine.

docker pull postgres:16
# Output (trimmed):
# Status: Downloaded newer image for postgres:16

docker run --name learning-platform-db \
  -e POSTGRES_PASSWORD=secret \
  -p 5432:5432 \
  -d postgres:16
# Output:
# 7f8e9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f

docker ps
# Output:
# CONTAINER ID   IMAGE         STATUS         PORTS                    NAMES
# 7f8e9a0b1c2d   postgres:16   Up 2 seconds   0.0.0.0:5432->5432/tcp   learning-platform-db

docker logs learning-platform-db
# Output (trimmed):
# database system is ready to accept connections

# The database is now reachable at localhost:5432, exactly as if PostgreSQL
# had been installed directly -- but running as an isolated container instead.

docker exec -it learning-platform-db psql -U postgres -c "SELECT version();"
# Output:
# PostgreSQL 16.x on x86_64-pc-linux-gnu, compiled by gcc ...

# Work is done for the day -- stop the container without deleting it.
docker stop learning-platform-db
# Output:
# learning-platform-db

# The next morning, resume with the exact same data still intact.
docker start learning-platform-db
# Output:
# learning-platform-db

# Done with this database entirely -- remove it for good.
docker stop learning-platform-db
docker rm learning-platform-db
# Output:
# learning-platform-db
# learning-platform-db

# The postgres:16 image itself is untouched -- "docker images" still lists it,
# ready to start a brand-new container from at any time.
