#!/bin/sh
# Bringing the whole thing up, creating real data through the REST API,
# confirming it's actually stored in PostgreSQL, and confirming it survives
# a restart of just the app container.

docker compose up -d
# Output (trimmed):
# => Container task-tracker-db-1    Started
# => Container task-tracker-db-1    Healthy
# => Container task-tracker-app-1   Started

docker compose ps
# Output:
# NAME                    IMAGE               STATUS                    PORTS
# task-tracker-app-1      task-tracker-app    Up 10 seconds (healthy)   0.0.0.0:8080->8080/tcp
# task-tracker-db-1       postgres:16         Up 15 seconds (healthy)

curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Finish the Docker course", "done": false}'
# Output:
# {"id":1,"title":"Finish the Docker course","done":false}

curl http://localhost:8080/tasks
# Output:
# [{"id":1,"title":"Finish the Docker course","done":false}]

# Restart just the app container -- the database keeps running, untouched.
docker compose restart app

curl http://localhost:8080/tasks
# Output:
# [{"id":1,"title":"Finish the Docker course","done":false}]

# The task survived the app restart, because it was never stored in the app
# container to begin with -- it lives in PostgreSQL, in the named volume.

# The real test, per "Docker Volumes": tear down BOTH containers entirely,
# not just restart one, and confirm the data is still there afterward.
docker compose down
# Output (trimmed):
# => Container task-tracker-app-1   Removed
# => Container task-tracker-db-1    Removed
# => Network task-tracker_default   Removed

docker compose up -d
# Output (trimmed):
# => Container task-tracker-db-1    Started
# => Container task-tracker-app-1   Started

curl http://localhost:8080/tasks
# Output:
# [{"id":1,"title":"Finish the Docker course","done":false}]

# Still there -- docker compose down (without -v) never touched the named
# volume, exactly as "Docker Compose" described.
