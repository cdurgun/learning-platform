# REST API Design

Advanced Spring MVC covered how to add behavior **around** a request
(interceptors, CORS, multipart) -- this lesson turns to the shape of the
request/response **itself**. Request and Response Handling covered
`@RequestBody`, `ResponseEntity`, and HTTP status codes; Validation &
Exception Handling covered `ProblemDetail` for standard error bodies -- this
lesson builds on those tools to address five concrete design problems
real-world REST APIs run into often: moving data without leaking an entity's
internals (DTOs), returning large collections a piece at a time
(pagination/sorting/filtering), changing an API without breaking backward
compatibility (versioning), preventing a request from being processed twice
by accident (idempotency), and having a response carry its own navigation
(HATEOAS).

## What Is REST API Design?

REST (Representational State Transfer) is an architectural style built on
principles we've already used in Request and Response Handling and Path
Variables and Request Parameters -- resources are represented by URLs, HTTP
methods carry a meaningful contract, responses speak through status codes.
This lesson takes those principles beyond a **single** endpoint, to how an
API is designed **as a whole**:

```java
// A single "RESTful" endpoint isn't enough -- an entire API needs to be
// consistent: the same error shape, the same pagination pattern, the same
// versioning strategy.
@GetMapping("/api/v1/topics")
ResponseEntity<PagedResponse<TopicSummary>> listTopics(Pageable pageable) { ... }
```

## Why Does It Exist?

If every endpoint invents its own convention (one names pagination `?page=`,
another `?offset=`; one returns errors as plain text, another as JSON), a
client consuming the API has to build a separate mental model for every
endpoint. We saw `@RestControllerAdvice` gather error bodies into **one
place** in Validation & Exception Handling -- every pattern in this lesson
(DTOs, a pagination shape, a versioning strategy) shares the same
motivation: making consistency central and predictable across endpoints.

## History

The term REST was defined in Roy Fielding's 2000 doctoral dissertation -- not
an architectural style as old as HTTP itself, but an observation about the
**correct** use of HTTP. HATEOAS was part of Fielding's original dissertation,
but in practice it became the least adopted of its principles -- most "REST
APIs" are actually HATEOAS-free, plain JSON over HTTP. The Spring HATEOAS
project started in 2012 to fill that gap (not used in this project, see "What
Is HATEOAS? (A Quick Look)"). The Idempotency-Key header pattern is a
convention Stripe's API popularized in 2017, later turning into an IETF
draft. The debate between URI and header versioning strategies has been
running since the 2010s, and still has no single settled answer.

## The Risks of Returning an Entity Directly: Why a DTO?

Returning a JPA entity directly from a `@RestController` looks tempting --
Jackson can already turn it into JSON. But that carries two real risks:

{{EntityLeakageRiskExample.java}}

First: an entity carries **every** field the database needs -- including
things no client should ever see, like a password hash or internal notes.
Second: a lazily-loaded collection on a real entity (like the
`@ManyToOne(FetchType.LAZY)` fields this project's own `TopicRepository`
deals with) can throw `LazyInitializationException` if touched during
serialization -- this project solves that risk upfront with a join fetch in
`findBySlugWithCategoryAndCourse`, but the general principle is the same:
don't let an entity's internal structure leak into the API contract.

## The DTO Pattern: Separating Request/Response with Records

The fix is to define the shape the API actually needs **separately**:

{{DtoRecordExample.java}}

As we saw in the Record lesson, a record is immutable and concise -- each one
describes exactly one direction (request or response). `CreateUserRequest`
has no `id` field (it doesn't exist yet); `UserResponse` has no `password`
field (it should never leave the server). A single shared "User" shape
couldn't express both constraints at once.

## Entity ↔ DTO Mapping: By Hand

The DTO pattern only earns its keep once something actually **converts**
between the two:

{{EntityToDtoMappingExample.java}}

At this project's scale, a hand-written `toDto(...)` method is perfectly
maintainable. In larger codebases, once there are dozens of DTOs and fields
change often, keeping this mapping in sync by hand becomes error-prone -- a
mapping library like MapStruct (which generates the same kind of method at
compile time) usually steps in at that point.

## Pagination: Pageable and Page<T>

Instead of returning a large collection all at once, return it a piece at a
time:

{{PaginationExample.java}}

`Pageable`/`Page` come from the same `JpaRepository` family this project's
own `TopicRepository` already extends -- when a `@RestController` method
parameter is of type `Pageable`, Spring resolves it from `?page=`/`?size=`/
`?sort=` query parameters automatically, no manual parsing needed.
`page.getTotalElements()`/`getTotalPages()` let a client know how many more
pages there are.

## Sorting: Sort with Multiple Fields

`Sort` works together with `Pageable`, and can be chained across multiple
fields:

{{SortingExample.java}}

`Sort.by(Sort.Direction.ASC, "difficulty").and(Sort.by(Sort.Direction.DESC, "title"))`
is the server-side equivalent of what a client would request with
`?sort=difficulty,asc&sort=title,desc` -- Spring resolves those query
parameters into exactly this kind of `Sort` object automatically.

## Filtering: Dynamic Queries from Query Parameters

Path Variables and Request Parameters showed that `@RequestParam` can be
optional -- filtering is built on exactly that:

{{DynamicFilterExample.java}}

Every filter parameter is optional: if present, it narrows the result; if
absent, it has no effect at all (via a predicate that defaults to `true`). A
real repository usually pushes this logic down into the database, into a
`WHERE` clause or (for many optional fields) a JPA `Specification` -- but the
core idea is the same: every filter falls back to "exclude nothing" when it
isn't supplied.

## The Shape of a Paginated Response: content, totalElements, totalPages

Returning a `Page<T>` directly from a controller works, but Spring Data
itself advises against it -- `PageImpl`'s internal fields aren't a
documented, stable contract, and its default JSON shape has changed across
versions:

{{PagedResponseShapeExample.java}}

The fix is the same idea as the DTO pattern: wrap `Page<T>` in a
`PagedResponse<T>` this project can document and control the field names
of. Whatever `Page<T>`'s internal serialization looks like in a given Spring
Data version, this record's shape only changes if this project changes it.

## API Versioning: URI Versioning vs. Header Versioning

An API changes over time -- two common ways to offer a new shape without
breaking existing clients:

{{ApiVersioningExample.java}}

URI versioning (`/api/v1/...` vs. `/api/v2/...`) is part of `@GetMapping`'s
path, the same mechanism from Mapping Annotations and HTTP Methods --
impossible to miss, but "v1"/"v2" leaks into every one of a client's URLs
forever. Header versioning (`Api-Version: 2`) uses `@RequestHeader` from Path
Variables and Request Parameters -- the URL never changes, but the version is
no longer visible just by looking at the URL, and becomes dependent on
documentation.

## What Is Idempotency? Naturally Idempotent Methods

An operation is idempotent when calling it once produces **the same result**
as calling it N times:

{{IdempotentMethodsExample.java}}

`PUT` and `DELETE` are idempotent by nature -- sending the same `PUT` twice
leaves the resource in the same final state; sending the same `DELETE` twice
leaves the resource "gone" either way (the second call changes nothing).
`POST` is **not** -- by definition, every call creates a new resource. This
distinction was introduced in Mapping Annotations and HTTP Methods' "HTTP
Methods: The Safe and Idempotent Concepts" section; here we actually run it
and confirm it.

## Making POST Idempotent with the Idempotency-Key Header

`POST` not being idempotent creates a real problem: when a client retries a
request after a timeout, it's unclear whether the server already processed
the first attempt. The fix is a key the client generates, so the server can
say "I've already seen this one":

{{IdempotencyKeyExample.java}}

The client generates a single `Idempotency-Key` (usually a UUID) for one
logical operation and sends the same key on every retry. If the server has
already processed that key, it returns the original result **without
creating a new resource** -- the second call has exactly the same effect as
the first, so `POST` becomes effectively idempotent.

## What Is HATEOAS? (A Quick Look)

HATEOAS means a response carries not just data, but the client's **next
steps**:

{{HateoasConceptExample.java}}

A client following the `next` link never needs to know this project's URL
scheme (`/api/topics/{slug}`) at all -- it just follows the link the server
gave it. This project doesn't use the real `spring-hateoas` library (it isn't
a project dependency), so the example above hand-builds a `links` map -- but
the idea is the JSON equivalent of what this project's own `topic.html`
already does with `previousTopic`/`nextTopic` (see Spring MVC Views and
Thymeleaf): the server knows where "previous"/"next" are, the client doesn't
need to.

## Best Practices

- **Explicitly filter out fields a consuming client should never see
  (password hashes, internal notes, internal IDs) with a DTO** -- returning
  an entity directly makes it easy to forget one (see "The Risks of Returning
  an Entity Directly: Why a DTO?").
- **Wrap paginated responses in a DTO you control, don't return `Page<T>`
  directly** -- Spring Data itself recommends this (see "The Shape of a
  Paginated Response: content, totalElements, totalPages").
- **Pick a versioning strategy from the start (or at least before the first
  breaking change) and apply it consistently** -- switching from URI to
  header versioning (or back) partway through breaks every existing client
  (see "API Versioning: URI Versioning vs. Header Versioning").
- **Take `Idempotency-Key` seriously on `POST` endpoints with side effects
  (payments, order creation)** -- network timeouts are real and common;
  without this pattern, a retry can cause concrete user-facing harm like
  double charges (see "Making POST Idempotent with the Idempotency-Key
  Header").

## Common Mistakes

**1. Returning an entity directly "for now" and pushing the DTO to later.**
Once clients depend on the entity's shape, inserting a DTO later becomes a
backward-incompatible change -- setting up the DTO from the start is much
cheaper than adding one afterward (see "The Risks of Returning an Entity
Directly: Why a DTO?").

**2. Reading pagination parameters (`page`, `size`, `sort`) by hand with
`@RequestParam` instead of using `Pageable`.** This re-solves a problem
Spring already solves -- a `Pageable` parameter does the same job, with
validation and defaults, in a single line (see "Pagination: Pageable and
Page<T>").

**3. Forgetting a filter parameter can be `null` and calling `.equals(...)`
on it directly.** Code like `category.equals(t.category())` throws a
`NullPointerException` when `category` isn't supplied -- every optional
filter needs to explicitly express "no effect when not supplied" (see
"Filtering: Dynamic Queries from Query Parameters").

**4. Mixing URI versioning and header versioning within the same API.** If
some endpoints use `/api/v1/...` and others use an `Api-Version` header, it
becomes hard for a client to guess which strategy applies where -- an API
should stay consistent with one strategy (see "API Versioning: URI
Versioning vs. Header Versioning").

**5. Storing `Idempotency-Key`s on the server forever.** In a real
application, keys should expire after some window (24 hours, say) -- otherwise
memory/storage grows without bound; the `Map` in this example only shows the
idea, with no expiry logic (see "Making POST Idempotent with the
Idempotency-Key Header").

**6. Documenting HATEOAS links but never actually putting them in the
response.** The whole point of HATEOAS is that a client can find its next
step by looking at the **response itself**, not the documentation -- a link
that's only documented but never appears in the response isn't HATEOAS, it's
just an ordinary API contract (see "What Is HATEOAS? (A Quick Look)").

## Summary, Cheat Sheet, and Glossary

REST API design goes beyond a single endpoint working correctly -- it's
about an entire API staying consistent, predictable, and backward
compatible. Key points:

- DTO: a pattern that separates the API contract from an entity's internal
  structure, with distinct shapes for request and response
- `Pageable`/`Page<T>`/`Sort`: Spring Data's counterpart for pagination and
  sorting, resolved automatically from query parameters
- Filtering: every query parameter is optional, a predicate that has no
  effect when not supplied
- `PagedResponse<T>`: a project-controlled pagination shape, instead of
  `Page<T>`'s unstable internals
- URI versioning: the version lives in the path (`/api/v1/...`) -- visible
  but permanent
- Header versioning: the version lives in a header (`Api-Version`) -- the URL
  stays fixed, but the version becomes invisible
- Idempotent: an operation that produces the same result whether called once
  or N times (`GET`/`PUT`/`DELETE` naturally, `POST` not)
- `Idempotency-Key`: a client-generated header that lets the server say "I've
  already processed this request"
- HATEOAS: a response carrying the client's next steps (links) alongside its
  data

Quick reference:

```java
@RestController
class TopicApiController {

    @GetMapping("/api/v1/topics")
    PagedResponse<TopicSummary> list(
            @RequestParam(required = false) String category,
            Pageable pageable) {
        // filter -> paginate -> wrap in a DTO
        return PagedResponse.from(repository.findAll(pageable));
    }

    @PostMapping("/api/v1/orders")
    ResponseEntity<OrderResponse> createOrder(
            @RequestHeader("Idempotency-Key") String key,
            @RequestBody CreateOrderRequest request) {
        OrderResponse existing = seenKeys.get(key);
        if (existing != null) return ResponseEntity.ok(existing);
        // ... create the new resource, add it to seenKeys ...
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
}
```

**Glossary**

**DTO (Data Transfer Object)** — A data shape designed for the API contract,
independent of the database entity.

**`Pageable`** — A Spring Data interface carrying page number, size, and
sorting, resolved automatically from query parameters.

**`Page<T>`** — A Spring Data interface carrying a page's content along with
total element/page counts.

**`Sort`** — A Spring Data type defining sorting by one or more fields with a
direction (`ASC`/`DESC`).

**URI versioning** — A versioning strategy where the API version is part of
the URL path.

**Header versioning** — A versioning strategy where the API version is
specified through an HTTP header, keeping the URL fixed.

**Idempotent** — An operation that produces the same result whether called
once or N times.

**`Idempotency-Key`** — A client-generated HTTP header that lets the server
determine whether it has already processed a given request.

**HATEOAS (Hypermedia as the Engine of Application State)** — The REST
principle that a response should carry links a client can follow, alongside
its data.

## Appendix: Mini Project — A Paginated and Filtered Topic Catalog API

Bringing this lesson's three data-shaping mechanics (filtering,
pagination/sorting, and a stable response shape) together in a single
catalog endpoint:

{{PaginatedCatalogController.java}}

{{PaginatedCatalogDemo.java}}

`listTopics` takes an optional filter with
`@RequestParam(required = false) String category`, pagination/sorting with
`Pageable`, and wraps the result in a stable `PagedResponse<T>`, the same
pattern as `PagedResponseShapeExample`. `PaginatedCatalogDemo` makes two
calls -- one unfiltered, one with a `category` filter -- to show that
`totalElements` reflects the filtered set, not the whole catalog.

## Appendix: Mini Project — Idempotency-Key-Backed Order Creation

The last mini project brings the DTO pattern together with the
`Idempotency-Key` mechanism on a real `@PostMapping`/`ResponseEntity`:

{{IdempotentOrderController.java}}

{{IdempotentOrderDemo.java}}

`createOrder` uses the `CreateOrderRequest`/`OrderResponse` DTO pair, reads
the client's key with `@RequestHeader("Idempotency-Key")`, and returns
`201 Created` for a key it hasn't seen before, `200 OK` (with the same body)
for one it has. `IdempotentOrderDemo` shows a "retry" with the same key
returning the same order id, while a different key genuinely creates a new
order.
