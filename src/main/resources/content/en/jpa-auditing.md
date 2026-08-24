This project's own `QuestionIngestService` builds a new `Question` with `.createdAt(LocalDateTime.now()).updatedAt(LocalDateTime.now())`, written by hand, right there in the service method. It works — but it's exactly the kind of repetitive, easy-to-forget code Spring Data JPA usually removes elsewhere. This lesson covers the tool built specifically for it: auditing.

## The Problem: Setting createdAt/updatedAt by Hand

Every place that creates or updates an audited entity has to remember to set its timestamp correctly, every single time.

{{ManualTimestampProblemExample.java}}

`createQuestion(...)` and `updateQuestion(...)` both need their own `LocalDateTime.now()` line — exactly this project's own `QuestionIngestService` pattern. Nothing here is technically broken, but the moment a second service method (or a third, or a tenth) needs to create or update the same kind of entity, that same line has to be remembered and repeated correctly, every time, in every place — forgetting it once leaves a row with a silently wrong timestamp.

## @CreatedDate and @LastModifiedDate

Two annotations replace that manual line entirely, once wired up.

{{AuditedEntityExample.java}}

`@CreatedDate` is populated automatically, exactly once, the moment an entity is first persisted — never touched again afterward. `@LastModifiedDate` is populated on that same initial insert, and then re-populated automatically on every subsequent update — this is the field `ManualTimestampProblemExample` had to remember to update by hand, in every single place that touched it.

## Wiring It Up: @EntityListeners and @EnableJpaAuditing

Two pieces have to be in place before `@CreatedDate`/`@LastModifiedDate` actually do anything — neither one alone is enough.

{{EnableJpaAuditingExample.java}}

`@EntityListeners(AuditingEntityListener.class)`, on the entity itself, registers a listener that runs automatically on that entity's lifecycle events (right before the first insert, and right before every update). `@EnableJpaAuditing`, on a `@Configuration` class, turns Spring Data JPA's auditing infrastructure on for the application as a whole. Missing either one means `@CreatedDate`/`@LastModifiedDate` are simply never populated — silently left `null`, with no error pointing at what's missing.

## Recording Who: @CreatedBy and @LastModifiedBy

The same mechanism extends to WHO made a change, not just WHEN.

{{CreatedByLastModifiedByExample.java}}

`@CreatedBy` and `@LastModifiedBy` work exactly like their date counterparts — same listener, same lifecycle timing — but capture the identity of whoever made the change instead of a timestamp. This project's real `Question` entity already has a `reviewedBy` column, but that's set manually, as part of a deliberate admin review action (per this project's own question-pool review workflow) — a genuinely different thing from automatically recording who created or last touched the row itself.

## AuditorAware&lt;T&gt;: Where "Who" Comes From

Spring Data JPA has no built-in notion of a "current user" — something has to supply that answer.

`AuditorAware<T>` is that something: a single-method interface returning an `Optional<T>` representing whoever is "currently" making a change, called automatically every time an audited entity is saved. A real application would implement it by reading from Spring Security's `SecurityContextHolder` — the currently authenticated user's name or id — rather than returning a fixed value; the fixed `"system"` value in the example keeps the focus on `AuditorAware`'s role itself, not on Spring Security, which this category doesn't cover.

## Sharing Audit Fields Across Entities with @MappedSuperclass

Once more than one entity needs the same audit fields, repeating `@CreatedDate`/`@LastModifiedDate` on each one becomes exactly the kind of repetition auditing was meant to remove in the first place.

{{MappedSuperclassAuditingExample.java}}

`@MappedSuperclass` isn't itself an `@Entity` and has no table of its own — it's a base class whose fields get copied into every entity that extends it. This project's real `Question` already has `createdAt`/`updatedAt` columns; if `QuestionOption` or another entity needed the exact same two fields, extending a shared `@MappedSuperclass` avoids declaring `@CreatedDate`/`@LastModifiedDate` (and `@EntityListeners`) separately on each one.

## Common Misconceptions

**"`@CreatedDate` alone is enough to make auditing work."** It isn't — without `@EntityListeners(AuditingEntityListener.class)` on the entity AND `@EnableJpaAuditing` somewhere in the application, the field is simply never populated, with no error. **"`@LastModifiedDate` only updates on genuine field changes."** It updates on every save that reaches the database, the same way dirty checking (covered in "Transaction Management") writes any tracked change — it isn't selectively smart about which saves "really" changed something meaningful. **"`AuditorAware` needs Spring Security to work at all."** It doesn't structurally depend on it — it's just an interface returning an `Optional<T>`; a real application typically implements it by reading from Spring Security, but the mechanism itself is independent of that specific choice.

## What Comes Next

Every topic in this category so far has focused on reading, writing, or tracking entity data correctly. "Testing Spring Data JPA Repositories," the final lesson in this category, shifts to verifying that all of it — repositories, queries, projections, relationships, even auditing — actually behaves the way these lessons describe, with `@DataJpaTest`.

## Best Practices

- Add both `@EntityListeners(AuditingEntityListener.class)` and `@EnableJpaAuditing` together — one without the other silently does nothing.
- Reach for `@MappedSuperclass` the moment a second entity needs the same audit fields, rather than repeating the annotations on each one.
- Implement `AuditorAware<T>` by reading the current user from Spring Security's `SecurityContextHolder` in a real application, not a fixed value.
- Prefer auditing over hand-written `LocalDateTime.now()` calls for any field that's genuinely just "when was this created/modified" — reserve manual timestamp fields for cases with their own distinct meaning, like this project's `reviewedAt`.

## Common Mistakes

- Adding `@CreatedDate`/`@LastModifiedDate` without `@EntityListeners` or `@EnableJpaAuditing`, and being confused why the fields stay `null`.
- Assuming `@LastModifiedDate` updates only when something "meaningful" changed, rather than on every save that reaches the database.
- Confusing `reviewedBy` (a deliberate, manual review action, as in this project's own `Question` entity) with `@LastModifiedBy` (an automatic record of who last saved the row) — they answer different questions.
- Repeating `@CreatedDate`/`@LastModifiedDate` on every entity individually instead of extracting them to a shared `@MappedSuperclass` once more than one entity needs them.

## Summary, Cheat Sheet, and Glossary

**Summary**

- `@CreatedDate`/`@LastModifiedDate` replace manually written `LocalDateTime.now()` calls (like this project's real `QuestionIngestService` pattern) with automatic timestamps.
- Both `@EntityListeners(AuditingEntityListener.class)` (on the entity) and `@EnableJpaAuditing` (on a configuration class) are required together — either alone does nothing.
- `@CreatedBy`/`@LastModifiedBy` record who made a change, using the same listener mechanism as the date annotations.
- `AuditorAware<T>` supplies the "who" — typically implemented by reading the current user from Spring Security in a real application.
- `@MappedSuperclass` shares audit fields across multiple entities without repeating the annotations on each one.

**Cheat Sheet**

```java
// Turn auditing on for the application
@Configuration
@EnableJpaAuditing
class JpaAuditingConfig {}

// An audited entity
@Entity
@EntityListeners(AuditingEntityListener.class)
class Question {
    @CreatedDate
    private LocalDateTime createdAt;

    @LastModifiedDate
    private LocalDateTime updatedAt;

    @CreatedBy
    private String createdBy;

    @LastModifiedBy
    private String lastModifiedBy;
}

// Supplying "who"
@Bean
AuditorAware<String> auditorProvider() {
    return () -> Optional.ofNullable(SecurityContextHolder.getContext().getAuthentication())
            .map(Authentication::getName);
}

// Sharing fields across entities
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
abstract class Auditable {
    @CreatedDate private LocalDateTime createdAt;
    @LastModifiedDate private LocalDateTime updatedAt;
}
```

**Glossary**

- **@CreatedDate / @LastModifiedDate**: annotations that populate a timestamp field automatically on insert (and, for the latter, every subsequent update).
- **@EntityListeners(AuditingEntityListener.class)**: registers the listener, on an entity, that actually drives the auditing annotations.
- **@EnableJpaAuditing**: turns on Spring Data JPA's auditing infrastructure for the whole application.
- **@CreatedBy / @LastModifiedBy**: annotations that record who made a change, using the same listener mechanism as the date annotations.
- **AuditorAware&lt;T&gt;**: the interface supplying "who the current user is" to `@CreatedBy`/`@LastModifiedBy`.
- **@MappedSuperclass**: a non-entity base class whose fields (like audit fields) are inherited by every entity that extends it, without its own table.
