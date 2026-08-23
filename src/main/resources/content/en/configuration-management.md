# Configuration Management

Every service in this course has kept its own configuration in its own `application.yml` -- order-service's port and datasource settings (see the Spring Boot Microservice Basics lesson's "Its Own `application.yml`: Port, Application Name, and Database" section), its Eureka client settings (see the Service Discovery & Eureka lesson), and now its Resilience4j instances (see the Resilience4j lesson). That's fine for a handful of services -- but imagine twenty services all needing the SAME datasource pool-size tuning, or a value that needs to change ACROSS every one of them at once. Copy-pasting the same block into twenty `application.yml` files, and editing all twenty when it changes, doesn't scale. This lesson introduces the piece that centralizes configuration instead: Spring Cloud Config.

## What Is Configuration Management?

Configuration management, in the microservices sense, is keeping configuration OUTSIDE the applications that use it, in one central place, instead of duplicating it inside every service's own packaged code. A Config Server serves configuration OVER THE NETWORK to any service that asks for it by name, on startup (and, as this lesson covers, sometimes without even a restart).

## Why Does It Exist?

Configuration duplicated across many services creates two real problems: first, a value that's genuinely SHARED (a connection pool size, a feature flag, a third-party API's base URL) has to be updated in every single service's own file when it changes -- easy to miss one, and each service needs its own redeploy just to pick up a value that never touched its actual code. Second, some configuration needs to be DIFFERENT per environment (a database URL in staging vs. production) without duplicating the entire file for each one. Centralizing configuration in one server, with support for per-environment overrides (see "Profiles: Different Configuration for Different Environments"), solves both.

## History

Spring Cloud Config was one of the original Spring Cloud projects, released alongside Eureka and Zuul around 2015 (see the Service Discovery & Eureka and API Gateway lessons' "History" sections) as part of the same wave of Netflix-OSS-inspired tooling brought into the Spring ecosystem. Unlike Eureka, it isn't built on any Netflix library -- it's a Spring-native answer to a problem every distributed system eventually runs into, and it remains actively maintained within Spring Cloud today.

## Setting Up a Config Server

config-server, like eureka-server, is its OWN independent Spring Boot application -- a fifth one in this course, alongside order-service, inventory-service, eureka-server, and api-gateway.

{{ConfigServerApplication.java}}
{{ConfigServerConfig.yml}}

> 💡 Tip
> This lesson uses Config Server's "native" backend (a local filesystem/classpath directory) instead of a Git repository, to keep the example self-contained -- in production, `spring.cloud.config.server.git.uri` pointing at a real Git repo is far more common, since it gives configuration changes the same version history and review process as code.

## The Config Repository: Where Configuration Actually Lives

The actual configuration values -- one YAML file per service, named to match that service's `spring.application.name` -- live in the Config Repository, completely separate from any service's own packaged code.

{{OrderServiceExternalConfig.yml}}

Notice this file only contains what's genuinely worth CENTRALIZING -- `server.port` and `spring.application.name` stay in order-service's own local `application.yml`, since a service needs to know its own identity and port before it can even ASK Config Server for anything else.

## Making order-service a Config Client

A single property, added to order-service's EXISTING `application.yml`, is what makes it fetch and merge in configuration from config-server on startup.

{{OrderServiceConfigClientConfig.yml}}

## Profiles: Different Configuration for Different Environments

A Config Repository file can be split further by PROFILE -- `order-service-staging.yml` and `order-service-production.yml`, alongside the base `order-service.yml` above, override or add to it depending on which profile order-service is started with (`spring.profiles.active=staging`, for instance). This is the SAME profile mechanism Spring Boot already uses locally (`application-dev.yml` overriding `application.yml`, if this project's own `application-dev.yml`/`application-prod.yml` pattern looks familiar) -- Config Server just applies it to centrally-hosted files instead of local ones.

## Refreshing Configuration Without Restarting: @RefreshScope

By default, a `@Value`-injected property is read exactly once, when Spring creates the bean -- editing a Config Repository file afterward has NO effect on an already-running service. `@RefreshScope` changes that: it makes a bean eligible to be thrown away and recreated, re-reading its `@Value`s, whenever a refresh is triggered (a `POST` to that service's own `/actuator/refresh` endpoint).

{{RefreshableGreetingController.java}}

> ⚠️ Warning
> A single `/actuator/refresh` call only refreshes the ONE service you called it on -- with many services, triggering every one of them by hand doesn't scale much better than editing files by hand did. Spring Cloud Bus (broadcasting a refresh event to every service at once over a shared message broker) solves this, but is out of scope for this lesson -- worth knowing it exists once a system has more than a couple of services.

## Secrets: What Config Server Should NOT Store in Plain Text

Not everything belongs in a Config Repository file as plain text -- a database password is configuration in the sense that it varies by environment, but storing it unencrypted in a file (even a private Git repo) is a real security risk. Spring Cloud Config supports encrypting individual values, and dedicated secrets tools (HashiCorp Vault is the most common pairing) exist specifically for this -- this lesson keeps using `${ORDERS_DB_PASSWORD}` as an environment variable (see the Spring Boot Microservice Basics lesson) for the genuinely sensitive value, and only centralizes configuration that ISN'T a secret.

## Best Practices

- **Centralize values that are genuinely SHARED or that change independently of code** (pool sizes, feature flags, third-party URLs) -- leave a service's own identity (port, application name) in its local `application.yml`.
- **Use profiles for environment-specific overrides**, instead of maintaining separate near-duplicate files by hand.
- **Mark beans that need live updates with `@RefreshScope` deliberately, not everywhere** -- refreshing has a real cost (bean recreation), and most beans never need it.
- **Never put secrets in a Config Repository file as plain text** -- use encryption or a dedicated secrets tool, exactly as this lesson keeps `ORDERS_DB_PASSWORD` as an environment variable rather than centralizing it.

## Common Mistakes

- **Centralizing `server.port` or `spring.application.name`.** A service needs both LOCALLY, before it can even contact Config Server to ask for anything else.
- **Editing a Config Repository file and expecting a running service to pick it up immediately.** Without `@RefreshScope` and an explicit refresh call (or Spring Cloud Bus), nothing changes until the next restart.
- **Storing a database password or API key in a Config Repository file as plain text.** Even in a private repository, this is a real credential leak waiting to happen -- see "Secrets" above.
- **Applying `@RefreshScope` to every bean "just in case."** It adds real overhead to bean creation and complicates reasoning about a bean's lifecycle, for beans that in practice never change at runtime.

## Summary, Cheat Sheet, and Glossary

Configuration management centralizes configuration OUTSIDE the services that use it. Spring Cloud Config's Config Server (`@EnableConfigServer`) serves per-service YAML files from a Config Repository (a Git repo in production, a local directory here); a service becomes a Config Client with a single `spring.config.import` property. Profiles let a Config Repository file be overridden per environment, the same way this project's own `application-dev.yml`/`application-prod.yml` already work locally. `@RefreshScope` lets a bean pick up new configuration without a restart, triggered by `/actuator/refresh`. Secrets never belong in a Config Repository file as plain text.

Quick reference:

```java
@SpringBootApplication
@EnableConfigServer
public class ConfigServerApplication { ... }   // its own Spring Boot app,
                                                // serves configuration only

// order-service's application.yml
// spring.config.import: "configserver:http://localhost:8888"

@RestController
@RefreshScope                                  // re-reads @Value on refresh,
class SomeController {                         // instead of only at startup
    @Value("${greeting.message}")
    private String greetingMessage;
}
```

**Glossary**

**Config Server** — A Spring Boot application, enabled with `@EnableConfigServer`, that serves per-service configuration over the network.

**Config Repository** — Where the actual configuration files live -- a Git repository in production, a local directory in this lesson's example.

**Config Client** — A service that fetches and merges in configuration from a Config Server on startup, via `spring.config.import`.

**Profile** — A named variant of configuration (e.g. staging, production) that overrides or extends a base configuration file.

**`@RefreshScope`** — An annotation that makes a bean's `@Value`-injected properties re-read whenever a refresh is triggered, instead of only once at startup.
