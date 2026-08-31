FROM alpine:3.20

RUN apk add --no-cache python3

WORKDIR /app

COPY index.html .

EXPOSE 8080

CMD ["python3", "-m", "http.server", "8080"]
