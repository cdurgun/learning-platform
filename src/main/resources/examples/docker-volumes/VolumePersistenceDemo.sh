#!/bin/sh
# Proving that data written to a named volume survives even after the
# container that wrote it is completely removed -- not just stopped.

docker volume create learning-platform-db-data
# Output:
# learning-platform-db-data

docker run --name learning-platform-db \
  -e POSTGRES_PASSWORD=secret \
  -v learning-platform-db-data:/var/lib/postgresql/data \
  -d postgres:16
# Output:
# 7f8e9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f

# Write some real data.
docker exec -it learning-platform-db psql -U postgres -c \
  "CREATE TABLE proof (id SERIAL PRIMARY KEY, note TEXT); INSERT INTO proof (note) VALUES ('still here after removal');"
# Output:
# CREATE TABLE
# INSERT 0 1

# Destroy the container entirely -- not just stop it.
docker stop learning-platform-db
docker rm learning-platform-db
# Output:
# learning-platform-db
# learning-platform-db

# The container is gone. The volume is not -- confirm it's still listed.
docker volume ls
# Output:
# DRIVER    VOLUME NAME
# local     learning-platform-db-data

# Start a brand-new container, pointed at the SAME volume.
docker run --name learning-platform-db \
  -e POSTGRES_PASSWORD=secret \
  -v learning-platform-db-data:/var/lib/postgresql/data \
  -d postgres:16
# Output:
# 3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4

docker exec -it learning-platform-db psql -U postgres -c "SELECT * FROM proof;"
# Output:
#  id |            note
# ----+-----------------------------
#   1 | still here after removal
# (1 row)

# The row survived a full container removal -- because it was never stored
# inside the container's own filesystem to begin with.
