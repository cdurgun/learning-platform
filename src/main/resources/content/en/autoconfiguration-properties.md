# Spring Boot Auto-Configuration & Properties

In the Component Scanning lesson we saw how beans get found by the container; in the
Spring IoC Container lesson, how beans get defined and what their lifecycle looks
like. In this final lesson, we look at the third layer Spring Boot adds on top of
both: how `@SpringBootApplication` and auto-configuration work behind the scenes,
reading properties from `application.yml` with `@Value`/`@ConfigurationProperties`,
environment-specific configuration with `@Profile`, and the container announcing
things to itself with `ApplicationEvent`. By the end of this lesson, you'll know
exactly what this project's own `application.yml` files and the single
`@SpringBootApplication` line on `LearningPlatformApplication` actually represent.

## What Is Spring Boot Auto-Configuration?

Auto-configuration is Spring Boot looking at which libraries are present on the
classpath and registering beans on your behalf -- without you writing a single
`@Bean` method. For example, because this project depends on
`spring-boot-starter-data-jpa` and `postgresql`, Spring Boot automatically sets up a
`DataSource` bean, an `EntityManagerFactory` bean, and a JPA `TransactionManager`
bean -- none of which we ever defined by hand in a `@Configuration` class like
`WebConfig`:

```java
// If we wrote it by hand (we never do -- Spring Boot does this for us):
@Configuration
class ManualDataSourceConfig {
    @Bean
    DataSource dataSource() {
        HikariDataSource ds = new HikariDataSource();
        ds.setJdbcUrl("jdbc:postgresql://localhost:5433/learning");
        ds.setUsername("learning");
        ds.setPassword("learning");
        return ds;
    }
}
```

Other than setting the `spring.datasource.*` keys in `application.yml`, you've never
seen a class like the one above -- because auto-configuration sees
`org.postgresql.Driver` and `spring-boot-starter-data-jpa` on the classpath and
registers this bean for you.

## Why Does It Exist?

In the Component Scanning lesson we saw that Java Config is repetitive, and that
component scanning reduces this by moving the bean definition onto the class itself.
But component scanning only works for **your own classes** -- beans like
`DataSource`, `EntityManagerFactory`, or `RequestMappingHandlerMapping` are classes
you didn't write, from third-party libraries; you can't add `@Component` to them (see
the Component Scanning lesson's "Component Scanning vs. Java Config: Which One,
When?").

Without auto-configuration, every new Spring Boot project would need dozens of
hand-written `@Bean` methods -- for `DataSource`, `TransactionManager`,
`RequestMappingHandlerMapping`, `ViewResolver`, `ObjectMapper`, and more. Auto-configuration
moves the assumption "if this library is on the classpath, you probably need these
beans" into the framework itself -- you only customize those defaults with a handful
of properties in `application.yml`.

## History

Spring Boot launched in 2014 with version 1.0 -- until then, setting up a Spring
application could take hours, whether through XML-based configuration (the
`ClassPathXmlApplicationContext` era we mentioned in the Spring IoC Container
lesson's "History" section) or dozens of hand-written `@Bean` methods. Spring Boot's
core promise was "convention over configuration": start with sensible defaults, write
something only when you need to deviate from them.

`@EnableAutoConfiguration` (and `@SpringBootApplication`, which wraps it) is the
technical foundation of that promise. It originally read the list of
auto-configuration classes from a `META-INF/spring.factories` file; in Spring Boot
2.7 (2022) this mechanism moved to the faster, more explicit
`META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`
file -- since this project uses Spring Boot 4.1 (see `pom.xml`), it uses the newer
mechanism. `@Conditional` derivatives like `@ConditionalOnClass` and
`@ConditionalOnMissingBean` have also been the foundation of auto-configuration since
1.0.

## @SpringBootApplication: A Combination of Three Annotations

The single `@SpringBootApplication` annotation on `LearningPlatformApplication` is
actually a combination of three separate annotations -- we already recognize two of
them from earlier lessons:

{{SpringBootApplicationExample.java}}

`@SpringBootConfiguration` is a specialized derivative of `@Configuration` (Spring
IoC Container lesson). `@ComponentScan` is the very same annotation we saw in the
Component Scanning lesson -- used with no arguments, it scans its own package (and
subpackages), which is why every `@Controller`/`@Service` under `com.cdurgun.learning`
is found without being registered by hand. The third is
`@EnableAutoConfiguration`, the actual subject of this lesson.

## The @Conditional Family and How Auto-Configuration Works

At the heart of auto-configuration is the `@Conditional` family: annotations that
let a bean, or an entire `@Configuration` class, be registered only when (or only
when not) a certain condition holds. When `@EnableAutoConfiguration` is processed,
Spring Boot tries each of the hundreds of `@Configuration` classes in its own
`spring-boot-autoconfigure` module (`DataSourceAutoConfiguration`,
`JpaRepositoriesAutoConfiguration`, `ThymeleafAutoConfiguration`, and so on) in turn --
each one is guarded by its own `@Conditional` annotations, and nothing whose
condition fails gets registered. We'll use the two most common derivatives --
`@ConditionalOnClass` and `@ConditionalOnMissingBean` -- with our own hands in the
next two sections.

## @ConditionalOnClass: When a Class Is on the Classpath

`@ConditionalOnClass` says "only register this bean if the given class is on the
classpath" -- the same mechanism the real `DataSourceAutoConfiguration` uses to only
kick in when a JDBC driver is actually among the project's dependencies:

{{ConditionalOnClassExample.java}}

`com.fasterxml.jackson.databind.ObjectMapper` really is on the classpath (Jackson
comes in transitively through `spring-boot-starter-web`), so the first bean is
registered; the second bean, guarded by a made-up class name, is silently skipped --
no exception is thrown, the bean simply behaves as if it never existed.

## @ConditionalOnMissingBean: When the Application Defines Its Own Bean

`@ConditionalOnMissingBean` lets libraries say "I'll offer a sensible default, but
use your own bean if you define one" -- in real Spring Boot, many beans like
`ObjectMapper` and `RestTemplateBuilder` behave exactly this way:

{{ConditionalOnMissingBeanExample.java}}

Order matters here: the application's own `@Configuration` class has to be processed
**before** the class defining the library's default -- in real Spring Boot, this is
guaranteed by auto-configuration classes always being processed **after** the
application's own `@Configuration` classes, which is exactly why a bean you define
yourself always wins over auto-configuration's default.

## Writing Our Own Auto-Configuration

Let's see, at small scale, what a real Spring Boot starter looks like on the inside --
`@ConditionalOnProperty` lets a whole feature be switched on or off from
`application.yml`:

{{CustomAutoConfigurationExample.java}}

`matchIfMissing = false` means the bean stays **off by default** if the property is
never set at all -- the same behavior as many optional real Spring Boot features
(`spring.cache.type`, `management.endpoints.web.exposure.include`, and others): it
never kicks in unless you explicitly ask for it.

## application.properties and application.yml

Spring Boot supports two equivalent file formats: `application.properties`, made up
of flat `key=value` lines, and `application.yml`, which expresses nested structure
with indentation. This project prefers YAML -- a fragment from its own
`application.yml`:

```yaml
spring:
  application:
    name: learning-platform
  profiles:
    active: dev
  thymeleaf:
    cache: false

server:
  port: 8080
```

The same settings in `.properties` format would look like:
`spring.application.name=learning-platform`, `spring.profiles.active=dev`,
`spring.thymeleaf.cache=false`, `server.port=8080`. Both resolve to the same flat,
dot-separated property keys (like `spring.thymeleaf.cache`) -- YAML just lets you
write it with less repetition, through nested indentation. In the following sections
we'll see how to read these keys on the Java side with `@Value` and
`@ConfigurationProperties`.

## Injecting a Single Property with @Value

`@Value` injects a single property from `application.yml` directly into a field or
constructor parameter -- the simplest way to read one, but with no grouping at all:

{{ValueInjectionExample.java}}

The `:Hello` part of `${app.greeting.prefix:Hello}` specifies the default value to
use if the property is never set -- so the application doesn't crash just because an
optional property was left out. As the comment in the code example notes, in plain
Spring IoC Container (without Spring Boot), you have to define a
`PropertySourcesPlaceholderConfigurer` bean by hand for `${...}` placeholders to work
at all -- in Spring Boot you never write this yourself, because
`@EnableAutoConfiguration` registers it for you automatically. This is exactly the
kind of repetition-removal we mentioned in "Why Does It Exist?".

## Grouped Properties with @ConfigurationProperties

Unlike `@Value`, `@ConfigurationProperties` binds an entire family of properties
sharing the same prefix into one typed object:

{{ConfigurationPropertiesExample.java}}

`app.mail.tls-enabled` (kebab-case, as it would appear in YAML) is automatically
bound to the `tlsEnabled` field -- Spring Boot's "relaxed binding" rules treat
kebab-case, camelCase, and UPPER_SNAKE_CASE (for environment variables) as the same
property. This project doesn't yet define its own `@ConfigurationProperties` class --
we'll come back to that in "This Project's Own application.yml and Config Classes".

## Validating @ConfigurationProperties

Real projects validate `@ConfigurationProperties` with `jakarta.validation`
annotations (`@NotBlank`, `@Min`, and so on) plus `@Validated` -- that requires the
`spring-boot-starter-validation` dependency, which this project doesn't have (see
`pom.xml`). We get the same safety net by hand, with `@PostConstruct`:

{{ConfigurationPropertiesValidationExample.java}}

An invalid `max-attempts` value fails loudly at startup (during
`context.refresh()`), instead of the application silently running with a nonsensical
"0 retries" configuration -- the same `@PostConstruct`/`@PreDestroy` lifecycle hook
from the Spring IoC Container lesson, used here to "fail fast."

## Profiles: Environment-Specific Beans with @Profile

`@Profile` lets two completely different implementations of the same interface sit
side by side in the source code, with only one of them actually registered --
chosen by whichever profile is active:

{{ProfileExample.java}}

This is exactly the mechanism this project uses to switch between
`application-dev.yml`, `application-test.yml`, and `application-prod.yml` -- not just
property values, but even the beans themselves can change based on the environment.

## Profile-Specific application-{profile}.yml Files

This project has four `application*.yml` files: a base `application.yml` with shared
settings, and three profile-specific files. The `spring.profiles.active: dev` line in
`application.yml` determines which profile is active by default:

```yaml
# application-dev.yml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5433/learning
  jpa:
    show-sql: true

# application-prod.yml
spring:
  datasource:
    url: ${DB_URL}
  jpa:
    show-sql: false
```

Expressions like `${DB_URL}` in `application-prod.yml` are read from environment
variables, as we'll see in "External Configuration: The Priority Order of Property
Sources" -- secrets (like a database password) are never written into the repo at
all. When the active profile is changed (via `spring.profiles.active` or an
environment variable), Spring Boot layers the matching
`application-{profile}.yml` file on top of the base `application.yml`.

## External Configuration: The Priority Order of Property Sources

If a property is defined in more than one place at once (say, both in
`application.yml` and in an environment variable), Spring Boot has a strict priority
order to decide which one wins. From highest to lowest priority, the main sources
are: command-line arguments, environment variables, `application-{profile}.yml`, and
at the bottom, the base `application.yml`. Let's simulate that ordering by hand:

{{PropertySourceOrderExample.java}}

This is exactly what explains why the `${DB_URL}` expression from "Profile-Specific
application-{profile}.yml Files" works at all: in production, a real environment
variable is layered on top of the placeholder in `application-prod.yml`.

## Environment Variables and Command-Line Arguments

The two highest-priority property sources -- environment variables and command-line
arguments -- are completely independent of the code, decided at deployment time. If a
Spring Boot application is started with `java -jar app.jar --server.port=9090`, that
value overrides everything in `application.yml`; an environment variable of
`SERVER_PORT=9090` has the exact same effect (Spring Boot automatically translates
`SERVER_PORT` into `server.port`). This is the standard way to inject a secret (like
a database password) without ever writing it into the repo, only into the deployment
environment -- exactly what `${DB_URL}`, `${DB_USERNAME}`, and `${DB_PASSWORD}` in
`application-prod.yml` do.

## ApplicationEvent and @EventListener

The container publishes events throughout its own lifecycle, and your own classes
can publish and listen to their own events too -- with no direct dependency between
the publisher and the listener:

{{ApplicationEventExample.java}}

`@EventListener` is the modern, annotation-based alternative to implementing
`ApplicationListener<T>` directly -- no interface needed at all; the parameter type
on the method signature determines which event is being listened for.
`ContextRefreshedEvent` is one of the container's own published events; the next
section looks at what Spring Boot adds on top of it.

## Spring Boot's Own Events (A Quick Look)

On top of plain Spring IoC Container's `ContextRefreshedEvent`, Spring Boot
publishes its own chain of events during `SpringApplication.run(...)`:
`ApplicationStartingEvent` (at the very start), `ApplicationEnvironmentPreparedEvent`
(once the Environment is ready, but before the context itself exists),
`ApplicationContextInitializedEvent`, `ApplicationPreparedEvent`, then the
container's own `ContextRefreshedEvent`, and finally `ApplicationReadyEvent` -- the
"everything, including the embedded server, is completely ready" signal. These
events only occur in an application actually started with `SpringApplication.run(...)`
-- the plain `AnnotationConfigApplicationContext` used by this lesson's examples
never triggers them, which is why there's no separate code example here. In
practice, the two most commonly used are `ApplicationReadyEvent` (for kicking off
background work) and `ApplicationFailedEvent` (for cleanup when startup fails).

## This Project's Own application.yml and Config Classes

This project's `application.yml` is a good example of what auto-configuration looks
like in real life: none of the `spring.datasource.*`, `spring.jpa.*`,
`spring.thymeleaf.*`, or `spring.flyway.*` keys correspond to a hand-written `@Bean`
method -- they are all predefined properties read by the relevant auto-configuration
classes (`DataSourceAutoConfiguration`, `JpaBaseConfiguration`,
`ThymeleafAutoConfiguration`, `FlywayAutoConfiguration`). The only `@Configuration`
class this project writes itself is `WebConfig` (from the Spring IoC Container
lesson), which defines a `LocaleResolver` bean -- **replacing** Spring Boot's own
`LocaleResolver` auto-configuration, because `WebMvcAutoConfiguration`'s own
`localeResolver` bean is guarded by exactly `@ConditionalOnMissingBean` (see
"@ConditionalOnMissingBean: When the Application Defines Its Own Bean"). The project
doesn't use `@Value` or `@ConfigurationProperties` anywhere yet -- every setting is a
standard `spring.*`/`server.*` key read directly by Spring Boot's own
auto-configuration classes.

## Best Practices

- **Understand auto-configuration before trusting it** -- treating it as pure "magic"
  without knowing which bean is registered and why makes debugging an unexpected
  outcome nearly impossible (see "The @Conditional Family and How Auto-Configuration
  Works").
- **Read groups of properties with `@ConfigurationProperties`, single values with
  `@Value`** -- when several related settings exist together, a grouped class is far
  easier to maintain than a pile of individual `@Value` fields (see "Grouped
  Properties with @ConfigurationProperties").
- **Never write secrets (passwords, API keys) into `application.yml` -- read them
  from environment variables instead** -- this project's own `application-prod.yml`
  does exactly that (see "Environment Variables and Command-Line Arguments").
- **To override a default guarded by `@ConditionalOnMissingBean`, defining your own
  bean of the same type is enough** -- there's no need to look for a separate "turn
  it off" switch (see "@ConditionalOnMissingBean: When the Application Defines Its
  Own Bean").
- **Validate `@ConfigurationProperties` settings at startup, not at runtime** --
  failing early and loudly on an invalid setting catches the mistake at startup
  instead of in production (see "Validating @ConfigurationProperties").

## Common Mistakes

**1. Assuming `@Value("${...}")` works automatically in plain Spring IoC Container
(without Spring Boot).** Without a hand-registered
`PropertySourcesPlaceholderConfigurer` bean, `${...}` placeholders are never resolved
at all (see "Injecting a Single Property with @Value").

**2. Writing a `@ConfigurationProperties` class and forgetting
`@EnableConfigurationProperties` (or `@ConfigurationPropertiesScan`).** The class
itself is not a `@Component` -- no bean is created unless you explicitly tell the
container to bind it (see "Grouped Properties with @ConfigurationProperties").

**3. Forgetting `matchIfMissing` on `@ConditionalOnProperty`.** The default behavior
(`matchIfMissing = false`) is to **not** register the bean when the property is
never set at all -- if you want a feature that's "on by default," you have to state
that explicitly (see "Writing Our Own Auto-Configuration").

**4. Trying to `getBean(...)` a bean guarded by `@Profile` while that profile isn't
active.** Since the bean was never registered, this results in a
`NoSuchBeanDefinitionException` -- the same outcome as an unannotated class in the
Component Scanning lesson (see "Profiles: Environment-Specific Beans with
@Profile").

**5. Misremembering the priority order of property sources, and being surprised that
"my environment variable isn't overriding application.yml."** An environment
variable should always outrank `application.yml` -- if it isn't, the variable name is
probably misspelled (see "External Configuration: The Priority Order of Property
Sources").

**6. Trying to test a Spring-Boot-specific event like `ApplicationReadyEvent` with a
plain `AnnotationConfigApplicationContext`.** These events only fire with a real
`SpringApplication.run(...)` -- don't confuse them with `ContextRefreshedEvent` (see
"Spring Boot's Own Events (A Quick Look)").

## Summary, Cheat Sheet, and Glossary

Auto-configuration is Spring Boot registering beans on your behalf by looking at
which libraries are on the classpath; `@Value` and `@ConfigurationProperties` are
two ways to bring `application.yml` settings into Java code; `@Profile` picks
different beans based on the environment, while `ApplicationEvent`/`@EventListener`
let the container (and your own code) communicate loosely. Key points:

- `@SpringBootApplication` = `@SpringBootConfiguration` + `@EnableAutoConfiguration` +
  `@ComponentScan`
- `@ConditionalOnClass`/`@ConditionalOnMissingBean`/`@ConditionalOnProperty`: the
  conditions auto-configuration uses to decide whether to register a bean
- `@Value("${key:default}")`: a single property, with an optional default value
- `@ConfigurationProperties(prefix = "...")` + `@EnableConfigurationProperties`: a
  grouped, typed family of properties
- `@Profile("name")`: a bean registered only while the given profile is active
- Property source priority (highest to lowest): command-line arguments > environment
  variables > `application-{profile}.yml` > `application.yml`
- `ApplicationEvent` + `ApplicationEventPublisher` + `@EventListener`: communication
  between a publisher and a listener with no direct dependency between them

Quick reference:

```java
@SpringBootApplication  // = @SpringBootConfiguration + @EnableAutoConfiguration + @ComponentScan
class MyApplication { }

@Configuration
class MyAutoConfiguration {
    @Bean
    @ConditionalOnClass(name = "some.library.Class")
    @ConditionalOnMissingBean
    @ConditionalOnProperty(name = "app.feature.enabled", havingValue = "true", matchIfMissing = false)
    MyBean myBean() { return new MyBean(); }
}

class MyService {
    @Value("${app.setting:default}")
    private String setting;
}

@ConfigurationProperties(prefix = "app.settings")
class MySettings {
    private String name;
    // getter/setter
}

@Configuration
@EnableConfigurationProperties(MySettings.class)
class SettingsConfig {
    @Bean
    @Profile("prod")
    MyBean prodBean() { return new MyBean(); }
}

@Component
class MyListener {
    @EventListener
    void onEvent(MyEvent event) { }
}
```

**Glossary**

**Auto-configuration** — Spring Boot registering beans on your behalf by looking at
which libraries are present on the classpath.

**`@SpringBootApplication`** — The convenience annotation combining
`@SpringBootConfiguration`, `@EnableAutoConfiguration`, and `@ComponentScan` into
one.

**`@Conditional`** — The base of the annotation family that lets a bean or a
`@Configuration` class be registered only when (or only when not) a given condition
holds.

**`@ConditionalOnClass`** — A condition that registers a bean only if the given
class is on the classpath.

**`@ConditionalOnMissingBean`** — A condition that registers a bean only if no other
bean of the given type exists yet; lets library defaults yield to user-defined
beans.

**`@ConditionalOnProperty`** — A condition that registers a bean only if a given
property has a specific value (or is missing, depending on `matchIfMissing`).

**`@Value`** — The annotation that injects a single property from
`application.yml` into a field or parameter.

**`@ConfigurationProperties`** — The annotation that binds a whole family of
properties sharing a common prefix into one typed object.

**`@Profile`** — The annotation that registers a bean only while the given
profile(s) are active.

**`ApplicationEvent`** — An event object that can be published by the container or
by application code, and listened to with `@EventListener`/`ApplicationListener`.

## Appendix: Mini Project — A Feature Toggle System

This mini project brings together `@ConfigurationProperties` (a family of feature
flags), `@ConditionalOnProperty` (one specific flag deciding whether an entire bean
exists at all), and `@Primary` from the Component Scanning lesson:

{{FeatureToggleConfig.java}}

{{FeatureToggleDemo.java}}

Every key under `app.features.flags.*` binds into the `FeatureToggles` bean's `flags`
map, while `app.features.ai-recommendations` decides, through a completely different
mechanism -- `@ConditionalOnProperty` -- whether a bean exists at all. Even though
they share a prefix, these are two entirely independent paths: one is data bound
into a Java object, the other is a condition telling the container "don't even
create this bean."

> 💡 Tip
> The `@Primary` on `aiRecommendationEngine()` is exactly the mechanism from the
> Component Scanning lesson's "@Primary: Marking a Default Candidate" section -- when
> both beans exist at once, it decides which one wins by default.

## Appendix: Mini Project — A Notification Settings Manager

The final mini project ties together almost everything from this lesson:
`@ConfigurationProperties` for grouped settings, `@Profile` for environment-specific
behavior, and an `ApplicationEvent` published once the settings are loaded:

{{NotificationSettingsApp.java}}

{{NotificationSettingsDemo.java}}

`SettingsLoader` publishes a `SettingsLoadedEvent` right after the settings are
injected, using `@PostConstruct` (the Spring IoC Container lesson's "@PostConstruct
and @PreDestroy" section) -- `SettingsAuditListener` listens for that event without
even knowing `SettingsLoader` exists. While the `prod` profile is active, the
`slowRetryWarning` bean is registered; in any other profile (`!prod`), it's
`fastRetryWarning` instead -- the two never exist at the same time.

> ⚠️ Warning
> Negation expressions like `@Profile("!prod")` are useful, but need care: the
> `!prod` condition holds while `dev`, `test`, or even no profile at all is active --
> "every case that isn't prod" is not the same thing as "only dev," and confusing the
> two can register the wrong bean in the wrong environment.
