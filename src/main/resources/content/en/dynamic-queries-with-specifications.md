"REST API Design"'s filtering example built optional conditions in Java — a `Predicate<Topic>` per filter, each defaulting to "match everything" when its query parameter was absent, combined with `.and(...)` over an in-memory `Stream`. Its own comment was explicit about the limitation: "a real repository would push this down into a WHERE clause... or a JPA `Specification` for cases this dynamic." This lesson is that real repository-level implementation.

## What "REST API Design" Left Unfinished: Pushing Filtering Into the Database

The in-memory version worked, but only because its example list had three `Topic`s in it. Filtering that way against a real table means fetching every row first, then discarding most of them in Java — the database never gets to use an index, and every unfiltered row still has to cross the network. The idea itself — an optional condition that does nothing when absent, combined with others — was already right; what's missing is running that same idea as a real, generated `WHERE` clause instead of a `Stream.filter(...)`.

## Why Query Methods and @Query Aren't Enough Here

"Query Methods and JPQL with @Query" covered two ways to get a query: a name Spring Data JPA parses, or JPQL you write directly. Both are FIXED at compile time — a method's name declares its conditions once, and a `@Query` string is the same text every time it runs. Neither can express "filter by category, but only if a category was actually supplied, and by difficulty, but only if that was too" — the SET of active conditions isn't known until a request actually arrives. That's a genuinely different problem, and it needs a genuinely different tool.

## What Is a Specification?

A `Specification<T>` is a small functional interface representing one WHERE condition, expressed as Java code that builds it, rather than as a fixed string of JPQL or a method name.

{{SingleSpecificationExample.java}}

`hasDifficulty(...)` returns a `Specification<Topic>` — a lambda that, given a `Root<Topic>`, a `CriteriaQuery`, and a `CriteriaBuilder`, produces a `Predicate`. Nothing runs yet at this point; a `Specification` only describes how to BUILD a condition. Something still has to hand it to a repository before it does anything.

## The Criteria API Underneath a Specification

`Root`, `CriteriaQuery`, `CriteriaBuilder`, and `Predicate` come from JPA's own Criteria API — the specification (in the JPA-the-spec sense covered in "JPA, Hibernate, and Spring Data JPA") for building queries out of Java objects instead of query text. `Root<Topic>` refers to "the `Topic` being queried" — `root.get("difficulty")` is the Criteria API's way of writing `t.difficulty`. `CriteriaBuilder` is what actually constructs a `Predicate` (`cb.equal(...)`, and many similar methods for other comparisons) from a path and a value. Spring Data JPA's `Specification` is a thin, convenient wrapper around this API — it doesn't replace it, the same way "JPA, Hibernate, and Spring Data JPA" covered Spring Data JPA not replacing JPA or Hibernate more generally.

## JpaSpecificationExecutor: Letting a Repository Accept Specifications

A `Specification` describes a condition, but a repository needs to explicitly opt into accepting one.

{{JpaSpecificationExecutorExample.java}}

Extending `JpaSpecificationExecutor<Topic>` alongside `JpaRepository<Topic, Long>` is what actually gives a repository `findAll(Specification)`, `findOne(Specification)`, `count(Specification)`, and more — inherited for free, the exact same way "Entities and the Repository Abstraction" covered `CrudRepository` contributing `save`/`findById`/`findAll`. Without `JpaSpecificationExecutor`, a `Specification` has nothing to actually run against.

## Combining Specifications: where, and, or

The real value of a `Specification` shows up once several of them combine into one larger condition.

{{CombiningSpecificationsExample.java}}

`Specification.where(...)` starts a chain; `.and(...)`/`.or(...)` combine two `Specification`s into a single, larger one — exactly the shape `DynamicFilterExample` in "REST API Design" already used with `Predicate.and(...)`, except this generates a real SQL `WHERE` clause instead of filtering an in-memory `Stream`.

## Optional Filters, Pushed Into the Database

This is the piece that actually delivers on "REST API Design"'s deferred promise — the same optional-filter shape, now generating real SQL.

{{OptionalFiltersSpecificationExample.java}}

`Specification.where(null)` is a genuinely useful starting point — it behaves as a no-op, "match everything" `Specification`, exactly the role `DynamicFilterExample`'s absent filters played by defaulting to `t -> true`. Each `if (category != null)` / `if (difficulty != null)` check adds one more `.and(...)` only when that filter was actually supplied — with none supplied, the generated query filters nothing at all; with both supplied, it filters on both.

## Specifications Together with Pageable

Dynamic filtering and real pagination aren't separate mechanisms — they combine into a single repository call.

{{SpecificationWithPageableExample.java}}

`JpaSpecificationExecutor`'s `findAll` also accepts a `Pageable`, the exact same type "Pagination, Sorting, and Projections" already covered. `repository.findAll(spec, pageable)` generates a filtered, paged query PLUS a filtered count query — the identical two-query shape from that lesson, now with a dynamic `WHERE` clause instead of a fixed one.

## Common Misconceptions

**"A `Specification` is a query."** It's a description of one condition — nothing runs until it's handed to a repository that extends `JpaSpecificationExecutor`. **"`Specification` is a completely separate mechanism from JPA."** It's a thin wrapper around JPA's own Criteria API (`Root`/`CriteriaQuery`/`CriteriaBuilder`/`Predicate`) — the same relationship Spring Data JPA has to JPA everywhere else. **"Dynamic filtering always needs Specifications."** It doesn't — a query with a small, fixed set of optional conditions can sometimes be expressed with a single JPQL `@Query` using the `:param IS NULL OR ...` pattern (used in this project's own `QuestionRepository`); `Specification` earns its place once the number or shape of conditions genuinely varies per request.

## What Comes Next

Every query covered in this category so far — derived methods, JPQL, projections, `Specification`s — has been a straightforward read within a single request. "Relationships, Fetching, and the N+1 Problem," next in this category, moves from WHAT a query returns to HOW an entity's own relationships get loaded — including a performance problem (N+1) that a perfectly correct query can still trigger.

## Best Practices

- Reach for a `Specification` once the SET of active filter conditions genuinely isn't known until a request arrives — not as a default replacement for query methods or `@Query`.
- Start an optional-filter chain with `Specification.where(null)`, and add one `.and(...)` per filter only when that filter's value is actually present.
- Keep individual `Specification`s small and named for what they check (`hasCategory`, `hasDifficulty`) — combine them with `.and(...)`/`.or(...)` rather than writing one large, monolithic `Specification`.
- Remember `findAll(Specification, Pageable)` exists — dynamic filtering and pagination combine into one call, not two separate steps.

## Common Mistakes

- Reaching for `Specification` for a query with a small, truly fixed set of conditions, when a derived method or a plain `@Query` would say the same thing more directly.
- Forgetting `JpaSpecificationExecutor` entirely, and being surprised a repository has no `findAll(Specification)` to call.
- Building a fresh `Specification` chain without starting from `Specification.where(null)`, and having to special-case the "no filters at all" scenario separately.
- Treating a `Specification` as something that runs on its own, rather than something that still needs a `Root`/`CriteriaBuilder` (supplied by the repository at query time) to actually produce a `Predicate`.

## Summary, Cheat Sheet, and Glossary

**Summary**

- A `Specification<T>` is Java code describing one `WHERE` condition, built from JPA's own Criteria API (`Root`, `CriteriaQuery`, `CriteriaBuilder`, `Predicate`).
- A repository must extend `JpaSpecificationExecutor<T>` (alongside `JpaRepository<T, ID>`) to accept a `Specification` at all.
- `Specification.where(...).and(...)/.or(...)` combines multiple conditions into one, the same shape as combining `Predicate`s in memory, now generating real SQL.
- `Specification.where(null)` is a genuinely useful no-op starting point for building up optional filters one `.and(...)` at a time.
- `findAll(Specification, Pageable)` combines dynamic filtering with real pagination in a single repository call.

**Cheat Sheet**

```java
// A single Specification
static Specification<Topic> hasDifficulty(String difficulty) {
    return (root, query, cb) -> cb.equal(root.get("difficulty"), difficulty);
}

// A repository that accepts Specifications
interface TopicRepository extends JpaRepository<Topic, Long>, JpaSpecificationExecutor<Topic> {}

// Combining Specifications
Specification<Topic> spec = Specification.where(hasCategory("spring-mvc")).and(hasDifficulty("ADVANCED"));

// Optional filters, pushed into the database
Specification<Topic> spec = Specification.where(null);
if (category != null)   spec = spec.and(hasCategory(category));
if (difficulty != null) spec = spec.and(hasDifficulty(difficulty));

// Dynamic filtering + real pagination together
Page<Topic> page = repository.findAll(spec, PageRequest.of(0, 10));
```

**Glossary**

- **Specification&lt;T&gt;**: a functional interface representing one query condition, built with JPA's Criteria API rather than a fixed query string.
- **Criteria API**: JPA's own API (`Root`, `CriteriaQuery`, `CriteriaBuilder`, `Predicate`) for building queries out of Java objects instead of query text.
- **JpaSpecificationExecutor**: the interface a repository must extend, alongside `JpaRepository`, to accept `Specification`s.
- **Specification.where(null)**: a no-op, "match everything" starting `Specification`, useful as the base of an optional-filter chain.
