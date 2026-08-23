# order-service's own Dockerfile -- lives at the root of order-service's own
# source tree, named plainly "Dockerfile" in a real project (this course's
# example naming convention adds a descriptive prefix, see "Containerizing a
# Single Service: order-service's Dockerfile"). Every OTHER service in this
# category (inventory-service, eureka-server, config-server, api-gateway) gets
# its own near-identical Dockerfile, changed only in which jar it copies.

# --- Build stage: has the JDK and Maven, but never ships in the final image ---
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN --mount=type=cache,target=/root/.m2 mvn -B package -DskipTests

# --- Runtime stage: only a JRE and the already-built jar ---
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/order-service.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
