# Deployment

Every lesson in this Microservices category has assumed order-service, inventory-service, eureka-server, config-server, api-gateway, and Kafka are already running somewhere, reachable at `localhost`. That assumption has been doing real work quietly this whole time -- and it stops holding the moment any of these pieces needs to run somewhere that ISN'T the same machine. This closing lesson covers how the system this category built actually gets deployed.

## What Does Deployment Mean for a Microservices System?

Deploying a single application usually means packaging it and running it somewhere. Deploying a microservices system means packaging and running MANY independently deployable pieces -- each with its own image, its own configuration, its own startup dependencies on the OTHERS -- and making sure they can all find each other once they're no longer all sharing the same `localhost`.

## Why Does It Exist?

Every `localhost:8761`, `localhost:8888`, and `localhost:9092` this category's earlier lessons wrote assumed every service runs on the SAME machine, during local development. That assumption is exactly right for the examples this course builds -- and exactly wrong the moment any service moves to its own container, its own machine, or its own cloud instance. Deployment is the practice of making a system designed and tested this way actually run somewhere else, without rewriting its configuration by hand for every new environment.

## History

Docker, released in 2013, popularized the container -- a package containing an application and everything it needs to run, isolated from whatever else is on the host machine, without the overhead of a full virtual machine. This solved a problem microservices make sharper than a single application ever did: many independently built pieces, each with potentially different dependency versions, all needing to run on the same infrastructure without interfering with each other. Docker Compose (packaged with Docker itself) extended this to ORCHESTRATING multiple containers together for local development -- exactly the scale of coordination this category's six pieces (order-service, inventory-service, eureka-server, config-server, api-gateway, and Kafka) now need.

## Containerizing a Single Service: order-service's Dockerfile

A Dockerfile describes how to build an image -- a self-contained package including order-service's own jar and just enough of a Java runtime to run it.

{{OrderServiceDockerfile.dockerfile}}

## A Multi-Stage Build: Keeping the Image Small

Notice `OrderServiceDockerfile.dockerfile` uses TWO stages: a `build` stage with the full JDK and Maven, and a separate final stage with only a JRE. The final image never includes Maven, the JDK's compiler, or order-service's own source code -- only the already-built jar and what's needed to RUN it. This keeps the shipped image meaningfully smaller and reduces its attack surface, without giving up anything the build itself needed.

## Orchestrating the Whole System: docker-compose

One file describes every piece this category built, how they're built, and how they depend on each other.

{{DockerComposeConfig.yml}}

> 💡 Tip
> This is genuinely the FIRST time this course's nine microservices lessons are described together in one place -- everything from `microservices-fundamentals` through `security` built toward exactly this file.

## Configuration in Containers: Environment Variables Over application.yml

Every `localhost` this category's earlier lessons hardcoded into an `application.yml` -- Eureka's `defaultZone`, Config Server's `spring.config.import`, Kafka's `bootstrap-servers` -- breaks once a service runs in its OWN container, because "localhost" then refers to that container, not to `eureka-server`'s.

{{OrderServiceContainerConfig.yml}}

> ⚠️ Warning
> This is the SAME environment-variable-override pattern the Configuration Management lesson already used for secrets like `ORDERS_DB_PASSWORD` -- applied here to service ADDRESSES instead. Nothing new is being introduced; container deployment just makes THIS particular use of it necessary rather than optional.

## Startup Order: Why depends_on Isn't Enough

`DockerComposeConfig.yml`'s `depends_on: condition: service_healthy` waits for a service's `/actuator/health` endpoint to actually pass, not just for its container to have started -- eureka-server's process starting doesn't mean it's ready to accept registrations yet.

> ⚠️ Warning
> Notice `kafka` uses `condition: service_started`, not `service_healthy` -- the plain Kafka image used here has no built-in health check. `service_started` only confirms the container process began running, NOT that Kafka is actually ready to accept connections -- order-service and inventory-service's own retry behavior (see the Resilience4j lesson) is what actually absorbs the gap between "Kafka's container started" and "Kafka is ready," not this dependency declaration.

## Beyond Local: A Brief, Honest Look at Kubernetes

Docker Compose is genuinely a LOCAL development and single-machine tool -- it doesn't run a service across multiple machines, doesn't restart a crashed container onto a different host, and doesn't have its own built-in service discovery the way Kubernetes does (see the Service Discovery & Eureka lesson's honest note that Eureka usually isn't needed ON Kubernetes for exactly this reason). Kubernetes solves problems at a scale this category's examples never actually reach.

{{KubernetesDeploymentPreview.yml}}

> 💡 Tip
> This is shown only so the SHAPE looks familiar -- actually setting up and operating a Kubernetes cluster is a large enough topic on its own to be genuinely out of scope for this lesson to build toward. The container image `OrderServiceDockerfile.dockerfile` produces is the SAME image Kubernetes would run -- Kubernetes changes how many instances run and how they're orchestrated, not how the image itself is built.

## Best Practices

- **Use a multi-stage build for every service's Dockerfile** -- see "A Multi-Stage Build: Keeping the Image Small" -- the pattern is identical across order-service, inventory-service, and every other service in this category.
- **Override configuration with environment variables for anything that changes between environments**, keeping the same `localhost` defaults this category's earlier lessons already used for local development -- see `OrderServiceContainerConfig.yml`.
- **Use health-check-based startup ordering (`condition: service_healthy`) wherever a real health check exists**, and lean on a service's own retry/resilience behavior (see the Resilience4j lesson) for dependencies that don't provide one -- see the warning in "Startup Order".
- **Treat Docker Compose as a local development and demonstration tool**, not a production deployment target -- see "Beyond Local".

## Common Mistakes

- **Shipping a Dockerfile without a multi-stage build.** A single-stage build ships the entire JDK, Maven, and the build cache inside the final image -- far larger than necessary, and a larger attack surface.
- **Assuming `depends_on` (without a health check condition) means a dependency is actually READY**, not just started. A container that's running isn't necessarily accepting traffic yet.
- **Hardcoding `localhost` into a Dockerfile or a container image itself**, instead of an environment variable resolved at container startup -- see `OrderServiceContainerConfig.yml` for the alternative.
- **Reaching for Kubernetes before actually needing what it solves.** The scale problems Kubernetes exists for (multi-machine orchestration, automatic rescheduling) aren't the same problems Docker Compose already solves well for local development -- see "Beyond Local".

## Summary, Cheat Sheet, and Glossary

Deployment makes a microservices system designed with `localhost` defaults actually run somewhere else. A multi-stage Dockerfile keeps each service's shipped image small; Docker Compose orchestrates every piece this category built (order-service, inventory-service, eureka-server, config-server, api-gateway, Kafka) together for local development, with environment variables overriding `application.yml` defaults per environment, and health-check-based `depends_on` conditions handling startup order where a health check exists. Kubernetes solves a different, larger-scale set of problems -- genuinely out of scope to build here, but shown briefly so its shape looks familiar.

Quick reference:

```dockerfile
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app
COPY . .
RUN mvn -B package -DskipTests

FROM eclipse-temurin:21-jre
COPY --from=build /app/target/app.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```

```yaml
# docker-compose.yml
services:
  order-service:
    build: ./order-service
    depends_on:
      eureka-server:
        condition: service_healthy
```

**Glossary**

**Container** — A self-contained package including an application and everything it needs to run, isolated from the host machine.

**Multi-Stage Build** — A Dockerfile pattern that uses a separate build stage (with full build tools) and a slimmer final stage (with only what's needed to run).

**Docker Compose** — A tool for orchestrating multiple containers together, primarily for local development.

**Health Check** — A probe (like `/actuator/health`) a container orchestrator uses to determine whether a service is actually ready, not just started.

**Kubernetes** — A container orchestration platform for running services across multiple machines at a scale beyond what Docker Compose targets.
