"REST API Design" showed a controller resolving `Pageable` and `Sort` from query parameters, and returning a `Page<T>` — but its own example admitted, in a comment, that it built that `Page` over an already-fetched, in-memory list, "because a real repository does this in the database." This lesson is that other half: making paging, sorting, and result-shaping actually happen at the repository level, backed by real SQL.

## What "REST API Design" Left Unfinished: Real Pagination

The controller-side story is already complete: a `@RestController` method parameter of type `Pageable` gets resolved from `?page=`/`?size=`/`?sort=` automatically, and `Sort.by(...).and(...)` builds a multi-field sort programmatically. None of that is repeated here. What's missing is what happens on the other end of that `Pageable` — the repository method that actually receives it and turns it into a real, efficient database query.

## Declaring a Paged Repository Method

Making a repository method genuinely paged, instead of simulating it over a list already sitting in memory, needs surprisingly little.

{{PagedRepositoryMethodExample.java}}

`findByCategoryId(Long categoryId, Pageable pageable)` looks almost identical to the derived query methods from "Query Methods and JPQL with @Query" — the only change is the return type, `Page<TopicExample>` instead of `List<TopicExample>`. That single change is enough: Spring Data JPA generates a query with a real `LIMIT`/`OFFSET`, plus a second query counting the total matching rows, and packages both into the `Page` it returns.

## What Actually Happens Underneath: LIMIT, OFFSET, and a Count Query

A single call to a `Page`-returning method quietly runs TWO queries, not one:

```text
findByCategoryId(5L, PageRequest.of(0, 2))
        |
        +--> SELECT * FROM topic WHERE category_id = 5 LIMIT 2 OFFSET 0
        |         (the actual page of rows)
        |
        +--> SELECT COUNT(*) FROM topic WHERE category_id = 5
                  (how many rows exist in total, across every page)
```

The first query fetches only the current page's rows — never the whole table. The second is what makes `page.getTotalElements()`/`getTotalPages()` (already used at the controller level in "REST API Design") possible at all; without it, there'd be no way to know how many pages remain. Both queries share the same `WHERE` condition, generated once from the method's own derived name or `@Query`.

## Sorting at the Repository Level

Sorting a paged (or unpaged) result doesn't need a new mechanism — it reuses pieces already covered.

{{SortAtRepositoryLevelExample.java}}

`findAll(Sort sort)` isn't written anywhere in this interface at all — it's inherited directly from `PagingAndSortingRepository`, exactly as "Entities and the Repository Abstraction" already covered; no new method is needed just to sort every row by an arbitrary field. A derived method can also accept a `Sort` parameter directly, alongside its usual conditions — `findByCategoryId(Long categoryId, Sort sort)` filters by category AND orders the result, with the caller supplying the ordering. The `Sort` object itself — `Sort.by(...).and(...)` — is unchanged from "REST API Design"; only where it's handed to (a repository method, not just resolved at the controller) is new here.

## Combining Paging, Sorting, and a Filter Condition

`Pageable` and `Sort` aren't actually two separate concerns to juggle — a `Pageable` already carries its own embedded `Sort`.

{{PagedAndFilteredQueryExample.java}}

`findByDifficulty(String difficulty, Pageable pageable)` needs no separate `Sort` parameter at all, because `PageRequest.of(page, size, sort)` already bundles paging and ordering into one `Pageable`. One method call, one `Pageable` argument, and the generated query filters, orders, and pages the result all at once — three concerns handled by a single, unremarkable method signature.

## Why Project Instead of Fetching a Whole Entity?

Every query so far has returned a full entity — every mapped field, whether the caller needed it or not. A PROJECTION returns only the fields a specific query actually needs, both narrowing the SQL itself (fewer columns selected) and avoiding the overhead of managing a full entity for data that's only ever going to be read, never modified through it.

## Interface-Based Projections

The simplest projection is just an interface with getters matching a subset of an entity's properties.

{{InterfaceProjectionExample.java}}

`TopicSummary` declares three getters — `getSlug()`, `getDifficulty()`, `getEstimatedMinutes()` — and nothing implements it by hand. Spring Data JPA generates a proxy implementing it at runtime, and — the actual benefit, not just less Java to write — generates a SQL `SELECT` naming only those three columns, not every column the full `Topic` entity would require.

## DTO/Record Projections

A record projection asks for exactly the same narrowing, but the query has to say precisely how to build the result, rather than Spring Data JPA inferring it from getter names.

{{RecordProjectionExample.java}}

`TopicTitleView` — a `record`, exactly the kind of type "Record" recommends for this — is constructed directly inside JPQL with `select new ...TopicTitleView(tt.topic.slug, tt.title)`, a "constructor expression." This query joins across `TopicTranslation`'s relationship to `Topic` and pulls back exactly two columns from two tables, with no intermediate `Topic` or `TopicTranslation` entity ever fully loaded into memory.

> 💡 Tip
> Prefer an interface projection when a query needs a straightforward subset of ONE entity's own fields — it needs no query changes at all. Reach for a record/constructor-expression projection once a projection needs to pull fields from ACROSS a relationship, the way `TopicTitleView` does here, or needs any computed value a plain getter can't express.

## Common Misconceptions

**"`Page<T>` and `List<T>` are basically the same thing, just with extra metadata."** They come from genuinely different queries — a `List<T>`-returning method runs one query; a `Page<T>`-returning method runs two (the page's rows, and a separate count). **"A projection is just about writing less Java."** The real benefit is a narrower SQL `SELECT` — fewer columns fetched from the database, not merely a smaller Java type to hold the result. **"`Pageable` and `Sort` are two separate things to pass around."** A `Pageable` already carries its own `Sort` internally — building one with `PageRequest.of(page, size, sort)` is usually enough, with no separate `Sort` parameter needed alongside it.

## What Comes Next

Every query in this lesson filtered on a fixed, known condition — `categoryId`, `difficulty` — decided at compile time by the method's own name or `@Query`. "Dynamic Queries with Specifications," next in this category, covers what "REST API Design"'s filtering section only named in passing: building a query's conditions at RUNTIME, when the set of active filters isn't known until a request actually arrives.

## Best Practices

- Return `Page<T>` (not `List<T>`) from any repository method a paginated API endpoint will call — the extra count query is what makes `totalElements`/`totalPages` possible at all.
- Reach for a projection — interface or record — whenever a query's caller only needs a subset of an entity's fields, rather than fetching (and paying for) the whole thing.
- Build a `Pageable` with `PageRequest.of(page, size, sort)` rather than juggling a separate `Sort` parameter alongside it.
- Use an interface projection for a straightforward subset of one entity's fields; reach for a record/constructor-expression projection once a relationship or a computed value is involved.

## Common Mistakes

- Simulating pagination over an already-fully-fetched `List` (exactly what "REST API Design"'s own example deliberately avoided doing for real) instead of declaring a genuinely `Page`-returning repository method.
- Fetching a full entity and manually copying a few fields onto a DTO afterward, instead of letting a projection narrow the query itself.
- Passing a separate `Sort` parameter to a method that also takes a `Pageable`, not realizing the `Pageable` can already carry the ordering.
- Expecting an interface projection to work for anything beyond a straightforward subset of one entity's own getters — a relationship-spanning or computed result needs a constructor-expression projection instead.

## Summary, Cheat Sheet, and Glossary

**Summary**

- A repository method returning `Page<T>` (instead of `List<T>`) generates a real `LIMIT`/`OFFSET` query plus a separate count query, packaged together.
- `findAll(Sort)` is inherited for free from `PagingAndSortingRepository`; a derived method can also take a `Sort` parameter directly.
- A `Pageable` already carries its own embedded `Sort` — `PageRequest.of(page, size, sort)` handles paging and ordering together.
- A projection returns only the fields a query actually needs, narrowing the generated SQL itself, not just the Java type holding the result.
- An interface projection needs only getters matching a subset of an entity's properties; a record/constructor-expression projection is needed once a query spans a relationship or computes a value.

**Cheat Sheet**

```java
// A genuinely paged repository method
Page<Topic> findByCategoryId(Long categoryId, Pageable pageable);

// Sorting: inherited for free, or as a derived-method parameter
List<Topic> findAll(Sort sort); // from PagingAndSortingRepository
List<Topic> findByCategoryId(Long categoryId, Sort sort);

// Paging + sorting + filtering together
Page<Topic> findByDifficulty(String difficulty, Pageable pageable);
Pageable pageable = PageRequest.of(1, 5, Sort.by("slug"));

// Interface projection
interface TopicSummary {
    String getSlug();
    Integer getEstimatedMinutes();
}
List<TopicSummary> findByCategoryId(Long categoryId);

// Record / constructor-expression projection
record TopicTitleView(String slug, String title) {}

@Query("select new com.example.TopicTitleView(tt.topic.slug, tt.title) " +
       "from TopicTranslation tt where tt.language = :language")
List<TopicTitleView> findAllTitles(String language);
```

**Glossary**

- **Page&lt;T&gt;**: a Spring Data type representing one page of results plus metadata (total elements, total pages), backed by two real queries.
- **Pageable**: an object describing which page and size to fetch, along with its own embedded `Sort`.
- **Projection**: a query result narrowed to a subset of an entity's fields, reducing the generated SQL's own `SELECT` list.
- **Interface projection**: a projection defined as an interface whose getters match a subset of an entity's properties, implemented automatically by Spring Data JPA.
- **Constructor-expression (record/DTO) projection**: a projection built explicitly inside JPQL with `select new ...SomeType(...)`, needed when fields span a relationship or are computed.
