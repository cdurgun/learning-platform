# Date & Time API

In this lesson we'll cover Java's date/time machinery — the `java.time` package —
end to end: from `LocalDate` to `Instant`, from how time zones actually work to how to
interoperate with the legacy `Date`/`Calendar` API. Date and time looks simple at first
glance but quickly gets complicated with details like time zones and Daylight Saving
Time (DST) — so we'll close this lesson with a clear answer to "which class should I
use, and when?"

## What Is the Date & Time API?

The `java.time` package is a family of classes — all **immutable** — that represent a
date, a time, a combination of the two, or a point on the timeline. The four most
fundamental ones: `LocalDate` (date only), `LocalTime` (time only), `LocalDateTime`
(both combined), and `Instant` (a single, unambiguous point on the universal timeline,
with no time zone involved):

```java
LocalDate today = LocalDate.now();       // 2026-08-10
LocalTime now = LocalTime.now();         // 14:32:07
LocalDateTime dateTime = LocalDateTime.now(); // 2026-08-10T14:32:07
Instant instant = Instant.now();         // 2026-08-10T11:32:07Z (UTC)
```

The "Local" prefix can be confusing — what's "local" here isn't the time zone a user
happens to be in, it's that the class carries **no time zone information at all**.
We'll see why that distinction matters in "ZonedDateTime and the Time Zone Concept."

## Why Does It Exist?

A real-world example: imagine a user in Istanbul schedules a meeting for 15:00, and a
participant in New York needs to see it in **their own** local time (07:00 EDT). Doing
this correctly requires three separate pieces of information: an absolute point in time
(the "real" moment everyone agrees on), a time zone's rules (what local time that
moment corresponds to in a given region), and a way to present both of those to the
user in a readable form. The reason `java.time` splits these into separate classes is
precisely to solve these three needs independently, without conflating them — we'll
walk through this end to end in the first mini project.

## History

Java's original date/time API (`java.util.Date`, later `Calendar`) had been around
since 1996, but it carried serious design problems: `Date` was mutable, and its month
values started at 0 (January = 0); the `Calendar` API was overly complex; and
`SimpleDateFormat` wasn't thread-safe — we'll come back to all of these in "Migrating
from the Legacy API to java.time." These problems were common enough complaints that
Stephen Colebourne wrote the popular **Joda-Time** library; Joda-Time was successful
enough that it directly inspired Java's own official standard. Oracle brought
Colebourne on board to drive JSR-310, and the result shipped in Java 8 (2014) as the
`java.time` package — immutable, thread-safe, and built from scratch with a clear
separation of responsibilities.

## LocalDate

`LocalDate` holds only a calendar date (year, month, day) — no time or time zone
information:

{{LocalDateExample.java}}

You can create a date directly with `LocalDate.of(2026, 3, 15)`, and derive new dates
with methods like `plusDays(...)` — every `plus`/`minus` call, as with every
`java.time` class, **never mutates the original**, it returns a new `LocalDate`.
Methods like `getDayOfWeek()` and `isLeapYear()` handle calendar arithmetic (leap-year
rules, weekdays) correctly for you — trying to compute these by hand is a well-known
source of bugs.

## LocalTime

`LocalTime` is `LocalDate`'s time-of-day counterpart — it holds only a time within a
day (hour, minute, second, nanosecond), with no date or time zone information:

{{LocalTimeExample.java}}

A call like `LocalTime.of(14, 30)` implicitly assumes zero seconds and nanoseconds.
`LocalTime`'s most typical use is expressing a recurring time that's independent of any
particular date — a business rule like "opens every day at 09:00" is modeled more
correctly with `LocalTime` than `LocalDateTime`, since it isn't tied to a specific
calendar day.

## LocalDateTime

`LocalDateTime` combines `LocalDate` and `LocalTime` — in practice it's the most
commonly used `java.time` class, since most applications think about "when" as both a
date and a time together:

{{LocalDateTimeExample.java}}

`LocalDate.atTime(LocalTime)` and `LocalDateTime.of(date, time)` produce the same
result two different ways — which one you use depends on the pieces you already have.
`toLocalDate()` and `toLocalTime()` do the reverse: pulling the pieces back out of a
combined `LocalDateTime`.

> ⚠️ Warning
> Remember that `LocalDateTime` still carries **no time zone information** — a
> `LocalDateTime` that says "15:00" has no idea whether that's Istanbul or New York.
> Once you need to tie it to a time zone, move on to "ZonedDateTime and the Time Zone
> Concept."

## Instant

`Instant` represents a single point on the UTC timeline (as seconds and nanoseconds
since the January 1970 epoch) — it carries no notion of a "calendar day" or "time
zone," just a **universal, unambiguous moment**:

{{InstantExample.java}}

`Instant` is ideal for machine-to-machine communication: a log entry, a database
timestamp, or an event's "when did this actually happen" has exactly one correct
answer with `Instant`, completely independent of which time zone it's read in. That's
why, as we'll also see in "Real-World Examples: java.time in Spring Boot," storing a
timestamp in a database usually means reaching for `Instant` (or a fixed-offset
`OffsetDateTime`) — the user's time zone is applied only when displaying that universal
moment to them.

## ZonedDateTime and the Time Zone Concept

`ZonedDateTime` combines a `LocalDateTime` with a `ZoneId` (say, `"Europe/Istanbul"`) —
so it carries both "what the local clock read" and "which region's rules that should be
interpreted under":

{{ZonedDateTimeExample.java}}

`ZoneId.of("Europe/Istanbul")` isn't a fixed number — it represents **all of a
region's historical and future rules** (including DST transitions), so the same
`ZonedDateTime` can correspond to a different UTC offset depending on the date.
`withZoneSameInstant(...)` shows the same universal moment **in another region's local
time** (the clock time changes, the instant stays the same); `withZoneSameLocal(...)`
does the opposite (the clock time stays the same, the instant changes) — mixing these
two up is a common source of bugs.

> ⚠️ Warning
> Calling `equals()` on a `ZonedDateTime` compares both the instant **and the time
> zone** — two `ZonedDateTime`s representing the exact same universal moment but
> expressed in different regions are **not** equal per `equals()`. If you only want to
> check whether they represent the same moment, use `isEqual(...)` instead.

## OffsetDateTime

`OffsetDateTime` combines a `LocalDateTime` with a fixed `ZoneOffset` (say, `+03:00`)
instead of a `ZoneId`. The difference is critical: a `ZoneOffset` is just a fixed
number, carrying no DST transition rules — whereas a `ZoneId`, like `"Europe/Istanbul"`,
represents a **region's** rules, which can change over time:

{{OffsetDateTimeExample.java}}

That distinction decides which one to reach for: if you want to show a user "Istanbul
time," `ZonedDateTime` + `ZoneId` is the right tool (it applies DST rules
automatically); if you want to store a **fixed-offset** timestamp in an API contract or
a database column (the ISO-8601 `OffsetDateTime` shape), `OffsetDateTime` is more
predictable — a region's rules changing in the future (say, a country dropping DST)
never affects records already stored with a fixed offset.

## Duration and Period

There are two ways to express the gap between two points in time, and which one you
pick depends on what you're actually measuring: **`Duration`** represents a
**time-based** amount — hours, minutes, seconds — (between `Instant`, `LocalTime`, or
`LocalDateTime` values); **`Period`** represents a **calendar-based** amount — years,
months, days — (only between `LocalDate` values):

{{DurationAndPeriodExample.java}}

`Duration.between(start, end)` gives the gap between two `Instant`s with
second/nanosecond precision — a concept like "3 months" doesn't fit `Duration` at all,
since months don't have a fixed length. `Period.between(start, end)` does the
opposite: it produces a calendar-shaped gap like "2 years, 3 months, 10 days," but
offers no hour/minute precision. Trying to use one in place of the other (say,
converting a `Period` into seconds) produces meaningless results — `ChronoUnit`, which
we'll see next, builds a more flexible bridge between these two worlds.

## Calculating Time Differences with ChronoUnit

`ChronoUnit` is an enum that implements the `TemporalUnit` interface (recall the
pattern from the Enum lesson's "Interface Implementation" section) — it offers
constants like `DAYS`, `HOURS`, `MONTHS`, and lets you compute a gap as a **single raw
number**, without constructing a `Duration`/`Period` object:

{{ChronoUnitExample.java}}

Unlike `Period.between(...).getDays()`, `ChronoUnit.DAYS.between(start, end)` returns
the **total** day gap (say, 400 days) as a single `long` — `Period` instead breaks that
same gap into pieces, like "1 year, 1 month, 5 days." Pick based on what question you
actually want answered: "how many days apart are they?" is a `ChronoUnit` question,
"how much time apart, in human terms?" is a `Period`/`Duration` question. Another
advantage of `ChronoUnit` is its generality: the same `between(...)` call works across
many different types — `LocalDate`, `LocalDateTime`, `Instant`, and more.

## DateTimeFormatter: Formatting and Parsing

`DateTimeFormatter` is the standard way to turn a date/time object into text
(`format(...)`) or text into a date/time object (`parse(...)`) — you can use either
ready-made ISO-8601 formats or define a custom pattern with `ofPattern(...)`:

{{FormattingAndParsingExample.java}}

`DateTimeFormatter.ofPattern("dd/MM/yyyy")` prints a `LocalDate` in a human-friendly
shape like `"15/03/2026"`; the same formatter converts text back into a `LocalDate` in
the other direction via `LocalDate.parse(text, formatter)`. If the text doesn't match
the expected pattern (say, an invalid date like `"2026-13-45"`), a
`DateTimeParseException` is thrown — this is an exception you **must** handle with a
`try`/`catch` whenever you're processing user input.

## Date Calculations

Every `java.time` class offers a set of `plus`/`minus` methods — `plusDays()`,
`minusMonths()`, `plusYears()`, and so on — all of which preserve immutability (recall
"LocalDate") and return a **new** object, never mutating the original:

{{DateCalculationsExample.java}}

A call like `plusMonths(1)` handles month-overflow intelligently on its own — say,
January 31 plus one month doesn't land on the nonexistent "February 31," it clamps to
that month's last valid day (the 28th or 29th). Chained calls
(`date.plusYears(1).minusDays(5)`) are perfectly safe, since each step produces a new
object — no intermediate step ever affects the one before it.

## TemporalAdjusters

Some date calculations are too rule-based to express with a simple `plus`/`minus` —
things like "the next Monday" or "the last day of this month." The
`TemporalAdjusters` class offers ready-made rules (adjusters) you can pass to `with(...)`:

{{TemporalAdjustersExample.java}}

`date.with(TemporalAdjusters.next(DayOfWeek.MONDAY))` computes "the first Monday after
today" in a single line — doing this by hand would mean thinking through several edge
cases like the number of days in the week and month boundaries. Ready-made adjusters
like `lastDayOfMonth()` and `firstDayOfYear()` follow the same philosophy: they reduce
common calendar rules to a single, well-tested method call instead of error-prone
manual arithmetic.

## Comparing Dates

Classes like `LocalDate`, `LocalDateTime`, and `Instant` offer `isBefore()`,
`isAfter()`, and `compareTo()` for comparing two values — `equals()` also works, but as
we saw in "ZonedDateTime and the Time Zone Concept," some types can fold extra
information (like a time zone) into that comparison too:

{{ComparingDatesExample.java}}

`isBefore()`/`isAfter()` are far more readable than writing `compareTo() < 0` — the
code reads almost like English for "is this date before that one?" For `LocalDate` and
`LocalDateTime`, `equals()` already compares only the value (field by field, much like
the auto-generated `equals()` we saw in the Record lesson) — the exception you actually
need to watch for is `ZonedDateTime`, covered in the previous section.

## Migrating from the Legacy API to java.time

You may still run into `java.util.Date`, `Calendar`, and `SimpleDateFormat` in older
codebases — all three have the serious problems we touched on in "History," but for
situations you can't fully avoid (say, a third-party library that still hands you a
`Date`), there are conversion bridges:

{{LegacyInteropExample.java}}

`Date.toInstant()` converts an old `Date` into a modern `Instant` — since `Date`
itself is internally nothing more than an epoch timestamp, this conversion is
lossless. `Instant.atZone(zoneId)` builds the bridge in the other direction. The most
critical warning is about `SimpleDateFormat`: this class is **not thread-safe** —
multiple threads sharing the same `SimpleDateFormat` instance (recall "Race
Conditions" from the Threads lesson) can produce corrupted results; `DateTimeFormatter`
is immutable and can be safely shared across threads.

> ⚠️ Warning
> New code should never start with `Date`, `Calendar`, or `SimpleDateFormat` — these
> should only ever be used to bridge at the boundary with an older API (a third-party
> library, an old database driver). We'll emphasize this rule again in "Common
> Mistakes."

## Time Zones and Daylight Saving Time

Time zones are this lesson's most overlooked, yet most bug-prone, topic. **UTC**
(Coordinated Universal Time) is the fixed reference point every time zone is measured
against; **GMT** shares practically the same offset as UTC but is historically based on
a different definition. Region identifiers like `"Europe/Istanbul"` and
`"America/New_York"` don't represent a fixed offset at all — they carry rules that can
**change over time**, most notably Daylight Saving Time (DST):

{{TimeZoneAndDstExample.java}}

DST transitions produce two odd situations: on the day clocks spring forward, some
local times **never happen at all** (say, 02:30 is skipped straight to 03:30); on the
day clocks fall back, some local times happen **twice**. `ZonedDateTime` resolves these
ambiguities for you with an automatic rule — but not knowing that rule exists leads to
surprising bugs like "why does this date show a 25-hour day?" A concrete example from
Turkey: the `"Europe/Istanbul"` region stopped observing Daylight Saving Time in 2016
and has stayed fixed at UTC+3 year-round ever since — solid proof that `ZoneId` rules
really can change over time.

## Real-World Examples: java.time in Spring Boot

`java.time` shows up in almost every layer of a modern Spring Boot application. On the
JSON side, Spring Boot's default Jackson configuration automatically registers the
`jackson-datatype-jsr310` module — so an `Instant` or `LocalDate` field serializes to
ISO-8601 text (like `"2026-08-10T11:32:07Z"`) with no extra annotations needed. On the
database side, Hibernate has natively supported `java.time` types since 5.2 — an
`Instant` field on a JPA `@Entity` maps directly onto PostgreSQL's time-zone-aware
`timestamptz` column:

{{EventExample.java}}

The `Event` class holds its `Instant createdAt` and `LocalDate eventDate` fields with
no framework annotations at all — and that's the whole point: framework integration
doesn't live in the class itself, it lives in the fact that the framework **already
understands** these types. The exact same `Event` class could become a JPA `@Entity` or
a Jackson DTO, and the field types (`Instant`, `LocalDate`) would never need to
change — because both Hibernate and Jackson understand them out of the box.

## Best Practices

- Store timestamps in a database as `Instant` (or a fixed-offset `OffsetDateTime`), and
  convert to `ZonedDateTime` only when displaying to a user — as we noted in
  "Instant," this eliminates time zone ambiguity at the earliest possible point.
- Always use `ZonedDateTime` (or at least a known `ZoneId`) when showing a date/time to
  a user — a bare `LocalDateTime` never answers the question "in which time zone?"
  (see the warning in "LocalDateTime").
- When choosing between `Duration`/`Period`/`ChronoUnit`, ask what you're actually
  measuring: a time-based span (`Duration`), a calendar-based range (`Period`), or a
  single raw number (`ChronoUnit`) (see "Duration and Period" and "Calculating Time
  Differences with ChronoUnit").
- Never start new code with `Date`, `Calendar`, or `SimpleDateFormat` — use them only
  to bridge at the boundary with an old API (see "Migrating from the Legacy API to
  java.time").
- Always handle `DateTimeParseException` when parsing a date from user input — an
  invalid date string is an inevitability, not an edge case (see "DateTimeFormatter:
  Formatting and Parsing").

## Common Mistakes

**1. Treating `LocalDateTime` as if it knew a time zone.** `LocalDateTime` never
carries time zone information — if you need to show a user an unambiguous moment, use
`ZonedDateTime` or `Instant` instead (see the warning in "LocalDateTime").

**2. Comparing two `ZonedDateTime`s with `equals()` and assuming they represent the
same moment.** `equals()` also compares the time zone — to compare only the instant,
use `isEqual(...)` (see the warning in "ZonedDateTime and the Time Zone Concept").

**3. Sharing a single `SimpleDateFormat` instance across multiple threads.** This class
isn't thread-safe and produces corrupted results; `DateTimeFormatter` safely replaces
it (see "Migrating from the Legacy API to java.time").

**4. Assuming a time zone's rules (especially DST) never change.** As the
"Europe/Istanbul" example shows, a region's DST rules can change completely over the
years (see "Time Zones and Daylight Saving Time").

**5. Trying to use `Period` for an hour/minute-precision calculation.** `Period` is
calendar-based only (years/months/days); for time-based gaps use `Duration`, and for a
single raw number use `ChronoUnit` (see "Duration and Period").

## Summary, Cheat Sheet, and Glossary

`java.time` has been Java's immutable, thread-safe date/time API, built with a clear
separation of responsibilities, since Java 8. Key takeaways:

- `LocalDate`/`LocalTime`/`LocalDateTime` carry no time zone information at all — the
  word "Local" emphasizes exactly that
- `Instant` is a single, unambiguous point on the UTC timeline — ideal for
  machine-to-machine communication and database timestamps
- `ZonedDateTime` carries a `ZoneId` (a region's rules, including DST);
  `OffsetDateTime` carries only a fixed `ZoneOffset`
- `Duration` is time-based, `Period` is calendar-based, and `ChronoUnit` expresses the
  gap between two points as a single raw number
- `DateTimeFormatter` handles both formatting and parsing, and is thread-safe
- Every `plus`/`minus` call returns a new object, never mutating the original
- `TemporalAdjusters` offers ready-made adjusters for rule-based calculations like "the
  next Monday"
- `Date`/`Calendar`/`SimpleDateFormat` should only be used to bridge with legacy
  APIs — `SimpleDateFormat` is not thread-safe
- Store `Instant`/`OffsetDateTime` in your database, display `ZonedDateTime` to users

Quick reference:

```java
// Core classes
LocalDate date = LocalDate.now();               // date only
LocalTime time = LocalTime.now();                // time only
LocalDateTime dateTime = LocalDateTime.now();    // date + time, no time zone
Instant instant = Instant.now();                 // a single point on the UTC timeline

// Time zones
ZonedDateTime zoned = ZonedDateTime.now(ZoneId.of("Europe/Istanbul"));
OffsetDateTime offset = OffsetDateTime.now(ZoneOffset.of("+03:00"));

// Measuring gaps
Duration duration = Duration.between(instant1, instant2); // hours/minutes/seconds
Period period = Period.between(date1, date2);              // years/months/days
long days = ChronoUnit.DAYS.between(date1, date2);          // a raw number

// Formatting / parsing
DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
String text = date.format(fmt);
LocalDate parsed = LocalDate.parse(text, fmt);

// Calculations and TemporalAdjusters
LocalDate nextMonday = date.with(TemporalAdjusters.next(DayOfWeek.MONDAY));
LocalDate endOfMonth = date.with(TemporalAdjusters.lastDayOfMonth());

// Legacy bridge
Instant fromLegacy = legacyDate.toInstant();
Date toLegacy = Date.from(instant);
```

**Glossary**

**`LocalDate`/`LocalTime`/`LocalDateTime`** — Immutable classes carrying no time zone
information, representing a date, a time, and the combination of the two,
respectively.

**`Instant`** — An immutable class representing a single, unambiguous point on the UTC
timeline.

**`ZonedDateTime`** — Combines a local date/time with a `ZoneId` that carries a
region's full set of rules, including DST.

**`OffsetDateTime`** — Combines a local date/time with a fixed `ZoneOffset` that
carries no DST rules.

**`Duration`** — A time-based amount expressing the gap between two points in
hours/minutes/seconds.

**`Period`** — A calendar-based amount expressing the gap between two dates in
years/months/days.

**`ChronoUnit`** — An enum implementing `TemporalUnit`, used to express the gap
between two points as a single raw number.

**`DateTimeFormatter`** — A thread-safe class used to convert date/time objects to
text (formatting) and text back into date/time objects (parsing).

**`TemporalAdjusters`** — A helper class offering ready-made adjusters for rule-based
date calculations like "the next Monday" or "the last day of the month."

**DST (Daylight Saving Time)** — The practice, in some regions, of moving clocks
forward/backward during certain parts of the year; the primary reason `ZoneId` rules
can change over time.

## Appendix: Mini Project — A Multi-Time-Zone Meeting Scheduler

In this mini project we build the scenario described in "Why Does It Exist?": a
scheduler that stores a meeting as a single absolute moment (`Instant`) and can display
it in any time zone you ask for:

{{MeetingScheduler.java}}

{{MeetingSchedulerDemo.java}}

`MeetingScheduler` holds the meeting's moment as nothing but an `Instant` — as we
emphasized in "Instant," this single source of truth carries no time zone ambiguity at
all. The `viewIn(ZoneId)` method converts that `Instant` into the requested region's
`ZonedDateTime`; `MeetingSchedulerDemo` shows what local time the same meeting
corresponds to **simultaneously** in Istanbul, New York, and Tokyo — all three print a
different clock time, yet all three point at the exact same `Instant`.

> 💡 Tip
> It's no accident that all three cities in `MeetingSchedulerDemo` have different UTC
> offsets — seeing that Istanbul no longer observes DST (recall "Time Zones and
> Daylight Saving Time"), while New York still does, makes concrete exactly why a
> `ZoneId`'s rules are specific to a single region.

## Appendix: Mini Project — Event Duration Tracking

Our last mini project combines the ideas from "Migrating from the Legacy API to
java.time" and "Duration and Period": a tracker that converts `Date`-based records
coming from an old system into `Instant` and computes their duration:

{{EventDurationTracker.java}}

{{EventDurationTrackerDemo.java}}

`EventDurationTracker.fromLegacyDates(...)` converts two `java.util.Date`s coming from
a legacy API into modern `Instant`s via `toInstant()` — a real application of the
bridge we saw in "Migrating from the Legacy API to java.time." The `duration()` method
then uses `Duration.between(...)` to compute the event's total length in hours and
minutes; `EventDurationTrackerDemo` shows that records coming from both the old and the
new API can be processed by the same `EventDurationTracker` without any friction.

> ⚠️ Warning
> The reason `fromLegacyDates(...)` uses `Date.toInstant()` is that `Date` itself
> **already** carries nothing but an epoch timestamp — so the conversion is always safe
> and lossless. But converting from `Calendar` may also require accounting for its time
> zone information — a more advanced topic we didn't cover in "Migrating from the
> Legacy API to java.time."
