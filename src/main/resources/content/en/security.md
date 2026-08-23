# Security

Every lesson in this category so far has assumed order-service and inventory-service simply trust whatever calls them. That's been a reasonable simplification while the focus was elsewhere -- but a real system needs to answer two questions this course hasn't touched yet: who is making this request, and are they allowed to do what they're asking? This lesson introduces Spring Security into the course for the first time, scoped specifically to this category's services.

## What Does Security Mean for a Microservices System?

In a single application, security often means one login check at the front door. In a microservices system, EVERY service that receives a request -- not just the one facing the public internet -- needs its own answer to "who is this, and are they allowed to do this," because a request can reach an internal service (inventory-service) through paths that never touch the public-facing one (api-gateway) at all, whether by misconfiguration or by design.

## Why Does It Exist?

Without any identity check, ANY request that can reach order-service's network can place orders, and any request that can reach inventory-service directly could bypass api-gateway entirely -- the routing and cross-cutting concerns api-gateway provides (see the API Gateway lesson) are convenience and structure, not a security boundary by themselves. A system that only checks identity at api-gateway and then trusts every internal call unconditionally is only as secure as its LEAST protected internal path.

## History

Token-based authentication for HTTP APIs became the dominant pattern as single-page applications and mobile clients replaced server-rendered, session-cookie-based logins through the 2010s -- a stateless token that any service can verify independently fits a distributed system's shape far better than a shared server-side session ever could. JSON Web Token (JWT), standardized in RFC 7519 (2015), became the most common shape for that token specifically because it's self-contained and independently verifiable (see "JWT: A Self-Contained, Verifiable Identity") -- no service needs to call back to a central session store just to check who's making a request.

## Authentication vs. Authorization: Two Different Questions

These two words are often used loosely, but they answer genuinely different questions. Authentication asks "who is this?" -- verifying an identity, typically by checking a token's signature. Authorization asks "is THIS identity allowed to do THIS specific thing?" -- a completely separate decision that happens AFTER authentication succeeds (see "Authorization: Restricting an Endpoint by Role"). A request can be authenticated (a real, valid identity) and still be unauthorized (that identity just isn't allowed to do what it's asking).

## JWT: A Self-Contained, Verifiable Identity

A JWT carries its own claims (who issued it, who it identifies, what roles or scopes it grants, when it expires) and a cryptographic signature over all of that -- any service holding the issuer's public key can verify the signature and trust the claims, without ever contacting the issuer directly for THIS specific check. This is what lets api-gateway and order-service both verify the SAME token independently (see "Validating a JWT at the Gateway" and "Why the Gateway Alone Isn't Enough").

## Validating a JWT at the Gateway

api-gateway is the first service to see an external request, so it's the natural first place to reject one carrying no valid token at all.

{{ApiGatewaySecurityConfig.java}}
{{ApiGatewayJwtConfig.yml}}

> 💡 Tip
> This course has used no Spring Security anywhere until this lesson -- the AI ingestion endpoint built for this project's quiz feature deliberately used a hand-written `X-Api-Key` check instead, specifically because adding a whole security framework for one internal endpoint would have been disproportionate. A public-facing gateway handling real user identity is exactly the kind of case that justifies bringing Spring Security in.

## Why the Gateway Alone Isn't Enough: Zero Trust Between Services

If order-service simply trusted every request that reached it, ANY path that bypasses api-gateway -- a misconfigured route, a service reachable directly on an internal network, a future service someone forgets to route through the gateway -- would have no protection at all. Zero trust means order-service verifies the JWT itself too, independently, rather than assuming "it must have already been checked."

{{OrderServiceSecurityConfig.java}}
{{OrderServiceJwtConfig.yml}}

> ⚠️ Warning
> Notice `OrderServiceJwtConfig.yml` points at the SAME `issuer-uri` as `ApiGatewayJwtConfig.yml` -- both services verify the SAME tokens from the SAME identity provider, completely independently. Neither service asks the other "did you already check this?"

## Authorization: Restricting an Endpoint by Role

Once a request is authenticated, `OrderServiceSecurityConfig`'s `.hasRole("customer")` rule (see above) makes the SEPARATE decision of who's allowed to place an order specifically -- an authenticated identity without that role gets a `403 Forbidden`, not the `401 Unauthorized` a missing or invalid token would produce.

## Propagating Identity: The Correlation Id's Security Counterpart

order-service's own JWT doesn't automatically travel along when it calls inventory-service through `ResilientStockClient` (see the Resilience4j lesson) -- exactly the same gap the Observability lesson closed for the correlation id, now for identity instead.

{{RestClientBearerTokenInterceptor.java}}

## Best Practices

- **Verify identity at every service that receives a request, not only the one facing the public internet** -- see "Why the Gateway Alone Isn't Enough".
- **Keep authentication and authorization as separate concerns**, even when they're configured close together (as in `OrderServiceSecurityConfig`) -- see "Authentication vs. Authorization".
- **Propagate identity across service boundaries deliberately**, the same way the correlation id is propagated -- see `RestClientBearerTokenInterceptor`, and the Observability lesson's `RestClientCorrelationIdInterceptor` it mirrors.
- **Keep health check endpoints public** (see `.pathMatchers("/actuator/health").permitAll()` above) -- load balancers and orchestrators need to reach them without a token.

## Common Mistakes

- **Trusting api-gateway's authentication check as the system's ONLY security boundary.** Any internal service reachable by another path has no protection at all unless it verifies identity itself -- see "Why the Gateway Alone Isn't Enough".
- **Confusing a `401` with a `403`.** A `401 Unauthorized` means authentication itself failed (no token, or an invalid one); a `403 Forbidden` means authentication succeeded but authorization didn't -- conflating the two makes debugging a real access problem much harder.
- **Forgetting to propagate identity to a downstream service call.** Without `RestClientBearerTokenInterceptor`, inventory-service would receive a completely unauthenticated request from order-service, even though the ORIGINAL external request was properly authenticated.
- **Putting authorization logic inside a controller method as scattered `if` statements**, instead of declaring it where the rest of a service's security rules already live (`OrderServiceSecurityConfig`) -- scattering it makes a service's actual access rules hard to audit in one place.

## Summary, Cheat Sheet, and Glossary

Security in a microservices system means every service that can receive a request needs its own answer to who's asking (authentication) and what they're allowed to do (authorization) -- trusting api-gateway's check alone leaves every other path unprotected. JWTs carry a verifiable identity independently checkable by any service holding the issuer's public key, which is what lets both api-gateway and order-service validate the SAME token without calling back to a central store. Identity needs to be deliberately propagated across service boundaries, the same way a correlation id is.

Quick reference:

```java
@EnableWebSecurity
class SomeServiceSecurityConfig {
    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .authorizeHttpRequests(requests -> requests
                        .requestMatchers("/actuator/health").permitAll()
                        .anyRequest().authenticated())
                .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> {}))
                .build();
    }
}

// application.yml
// spring.security.oauth2.resourceserver.jwt.issuer-uri: https://auth.example.com/
```

**Glossary**

**Authentication** — Verifying who is making a request, typically by checking a token's signature.

**Authorization** — Deciding whether an already-authenticated identity is allowed to do a specific thing.

**JWT (JSON Web Token)** — A self-contained, cryptographically signed token carrying its own identity claims, independently verifiable by any party holding the issuer's public key.

**Zero Trust** — The principle that no service should assume a request has already been validated elsewhere, and should verify identity itself.

**Resource Server** — A service (like order-service or api-gateway here) configured to validate JWTs and enforce access rules based on their claims.
