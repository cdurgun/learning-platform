#!/bin/sh
# Building the minimal web server image from its Dockerfile, running it,
# confirming it actually serves the page, and cleaning up afterward.

docker build -t minimal-web-server:1.0 .
# Output (trimmed):
# [+] Building 4.2s (9/9) FINISHED
# => [1/4] FROM docker.io/library/alpine:3.20
# => [2/4] RUN apk add --no-cache python3
# => [3/4] WORKDIR /app
# => [4/4] COPY index.html .
# => exporting to image
# => naming to docker.io/library/minimal-web-server:1.0

docker run -d --name minimal-web-server -p 8080:8080 minimal-web-server:1.0
# Output:
# 3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d

curl http://localhost:8080
# Output:
# <!doctype html>
# <html>
#   <head>
#     <title>Minimal Web Server</title>
#   </head>
#   <body>
#     <h1>Served from inside a container.</h1>
#   </body>
# </html>

# Confirmed -- the container is actually serving the file COPY placed inside
# the image. Clean up.
docker stop minimal-web-server
docker rm minimal-web-server
