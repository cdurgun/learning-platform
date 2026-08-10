# Dependency Injection & IoC

This lesson is the first Spring Boot topic on the site, but it doesn't touch Spring yet --
Dependency Injection (DI) and Inversion of Control (IoC) are two framework-independent
design ideas that predate Spring by a long way. The goal is to first do, entirely by hand,
in plain Java, what Spring's `@Autowired` does "magically" -- the next lesson (Spring IoC
Container & Bean Lifecycle) covers the container that automates this by-hand work. We'll
start from the tight coupling problem, compare all three of constructor/setter/field
injection, and end with a short look at how Spring automates them.

## What Are Dependency Injection and IoC?

At its simplest, Dependency Injection (DI) means an object receives the other objects it
depends on from the outside, instead of creating them itself with `new`. Inversion of
Control (IoC) is the more general idea behind it: "inverting control" -- normally a class
manages its own dependencies and flow, but IoC hands that control to something outside the
class (a hand-written "composition root," or a container like Spring). DI is the most
common concrete way of implementing IoC:

```java
// Without DI: OrderService decides and owns everything itself.
class OrderService {
    private final EmailSender sender = new EmailSender();
}

// With DI: OrderService only declares what it needs; someone else decides
// which EmailSender (or alternative) to hand it.
class OrderService {
    private final EmailSender sender;
    OrderService(EmailSender sender) { this.sender = sender; }
}
```

In the second version, `OrderService` has no idea where its `EmailSender` came from --
that's the common thread running through constructor/setter/field injection, which we'll
cover one at a time in the sections ahead.

## Why Does It Exist?

The core problem Dependency Injection solves is **tight coupling** -- a class embedding a
concrete implementation of another class directly inside itself (a `new SomeClass()`
line). That has three concrete costs: **untestability** (you're forced to test against a
real email service, with no way to avoid the network call), **difficulty changing**
(switching to SMS tomorrow means opening up `OrderService` and editing its code), and
**mixed responsibility** (a class ends up owning both "what to do" and "how to construct
its dependencies" at once).

DI solves all three by moving the dependency outside the class: `OrderService` doesn't
know which `NotificationSender` it gets, only that it needs *a* `NotificationSender`. As
we'll see in the sections ahead, that separation both speeds up tests and makes adding a
new channel possible without touching existing code.

## History

Dependency Injection existed before Spring -- the idea's roots go back to the "Inversion
of Control" discussions of the 1990s. But it owes its name and popularity largely to
Spring Framework: in his 2002 book *Expert One-on-One J2EE Design and Development*, Rod
Johnson proposed a much lighter alternative to the heavy, complex EJB (Enterprise
JavaBeans) model of the time -- those ideas took concrete shape as Spring Framework 1.0 in
2004.

That same year, Martin Fowler's article "Inversion of Control Containers and the
Dependency Injection pattern" clarified the until-then vaguely used term "Inversion of
Control" and proposed the name "Dependency Injection" -- most of today's terminology comes
from that article. In 2009, JSR-330 (`javax.inject`, known today as `jakarta.inject`)
standardized shared annotations like `@Inject`, taking DI beyond being Spring-specific --
Spring still prefers its own `@Autowired`, but supports `@Inject` too.

## The Tight Coupling Problem

Let's see the problem we mentioned in "Why Does It Exist?" in concrete code -- an
`OrderService` that creates its own `EmailSender`:

{{TightlyCoupledOrderService.java}}

As long as `OrderService` embeds the line `new EmailSender()`, the only way to switch it
to SMS -- or use a fake sender in a test -- is to open up `OrderService`'s source and
change it. The problem isn't `EmailSender` itself -- it's that `OrderService` bundled the
decision of *which* sender to use together with the logic of *using* one.

## What Is Inversion of Control (IoC)?

IoC in its smallest form: moving the decision of object creation outside the class that
uses it. Below, `OrderNotifier` no longer creates `EmailMessageSender` itself with `new`
-- it hands that job to a separate factory:

{{ManualFactoryExample.java}}

`OrderNotifier` still calls the factory itself -- control hasn't fully inverted yet, it's
just moved one step outward. In the next section we remove that last step too, arriving at
a version where `OrderService` doesn't call anything itself and instead receives a
ready-made object straight through its constructor.

> 💡 Tip
> This idea is sometimes called the "Hollywood Principle": "Don't call us, we'll call
> you" -- a component doesn't reach out and fetch what it needs itself; it waits for it to
> be brought to it from outside when needed.

## Dependency Injection: Programming to a Contract

Now we remove both the factory step and the concrete class dependency entirely --
`OrderService` depends on a `NotificationSender` **interface**, and which implementation
gets used is decided from the outside, through the constructor:

{{NotificationSenderExample.java}}

This is the "program to an interface, not an implementation" principle from the Interface
lesson, applied to the dependency problem. `OrderService`'s source code never mentions
`EmailNotificationSender` or `SmsNotificationSender` by name -- as the two calls in `main`
show, the same `OrderService` can be wired to two different channels without changing a
single line.

## Constructor Injection

The most common way to hand over a dependency is to take it as a constructor parameter and
store it in a `final` field:

{{ConstructorInjectionExample.java}}

`notificationSender` and `storeName` are **always** populated for as long as the
`OrderService` object exists -- there's no way to forget them, because the compiler won't
let you create an `OrderService` without those parameters. We'll look more closely at why
that guarantee matters in "Why Is Constructor Injection Recommended?".

## Setter Injection

The second approach hands over the dependency **after** the object already exists, through
an ordinary setter method:

{{SetterInjectionExample.java}}

Here `notificationSender` can no longer be `final` -- it has to stay reassignable so the
setter can populate it later. The second `OrderService` in `main` shows the cost of that:
calling `placeOrder(...)` without first calling `setNotificationSender(...)` fails right
there, at runtime, not when the object was created.

## Field Injection

The third approach hands over the dependency through neither a constructor nor a setter --
it's "injected" straight into a field. In Spring you'd see this as an `@Autowired` field;
here we simulate the same mechanism by hand, to see what a framework does behind the
scenes:

{{FieldInjectionExample.java}}

`OrderService` has no constructor or setter at all -- the `field.set(...)` call writes
directly into the `private` field from the outside, using the exact mechanism covered in
the Reflection lesson's "Accessing Private Fields and Methods" section. In a real Spring
app the container does this instead of you, but the result is the same: you can't tell
from `OrderService`'s source how that field got filled.

> ⚠️ Warning
> Field injection also requires reflection to test `OrderService` -- a plain `new
> OrderService(fakeSender)` call can't set the dependency at all, because there's no
> constructor that accepts it. "Common Mistakes" covers this and other reasons field
> injection is generally avoided.

## Comparing the Injection Styles

Lined up side by side:

- **Constructor Injection:** the dependency is `final`, required, and guaranteed the
  moment the object is created. A missing dependency is caught **at compile time** (if the
  parameter is missing) or, at the latest, the instant the object is constructed.
- **Setter Injection:** the dependency is mutable and can genuinely be optional. A missing
  dependency only surfaces at runtime, on the exact line where it's actually used.
- **Field Injection:** the least code (no constructor or setter to write), but the least
  control -- where the dependency comes from isn't visible in the source, and testing it
  by hand (without a framework) requires reflection.

These three aren't mutually exclusive -- the same class could take one required dependency
through the constructor and one optional one through a setter. But in practice, a single
style is almost always preferred over the others; the next section covers why.

## Why Is Constructor Injection Recommended?

Constructor injection being the recommended default isn't arbitrary -- it comes from its
guarantees:

{{ImmutableOrderService.java}}

Thanks to `Objects.requireNonNull(...)`, trying to build an `OrderService` with a `null`
dependency fails **immediately**, as `main` shows -- right where the mistake happened.
With setter injection (see "Setter Injection"), that same failure could surface much
later, on a line that looks completely unrelated.

> 💡 Tip
> Constructor injection has a hidden benefit too: once a constructor's parameter list
> creeps up to five or six, that's usually an early sign the class has taken on too many
> responsibilities -- setter/field injection hides this "code smell," because a large
> number of dependencies gets spread across scattered lines instead of standing out at a
> glance.

## Dependency Injection and Testability

DI's most immediate everyday payoff shows up in testing -- instead of a real
`NotificationSender`, all it takes is a fake one that just records what it was asked to
send:

{{TestableOrderServiceExample.java}}

`FakeNotificationSender` never touches a real email provider -- the test finishes in
milliseconds, and checking `sentMessages` lets us verify exactly what `OrderService` tried
to do. None of this was possible with `TightlyCoupledOrderService` from "The Tight
Coupling Problem" -- there, the only way to replace `EmailSender` was to edit the source
code.

## Manual Dependency Injection Without Spring (Composition Root)

Every `main` method up to this point was actually a small "composition root" -- the one
place the application knows its concrete classes. Let's make that clearer with a larger
example that wires up more than one dependency at once:

{{CompositionRootExample.java}}

Outside of `buildOrderService()`, neither `OrderService` itself nor the code calling it
knows that `EmailNotificationSender` or `ConsoleReceiptPrinter` exist. In real
applications this pattern is known as "Pure DI" or "Poor Man's DI" -- it gets you all the
benefits of IoC using nothing but classes and constructors, no framework required; it's
still a perfectly valid choice for small applications or whenever you want to avoid a
framework dependency.

## A Quick Look at How Spring Automates DI

Spring automates the composition root we just wrote by hand, using a container -- it
scans classes (`@Component`/`@Service`), reads their constructors (`@Autowired`), and
builds the objects itself, in the right order:

{{SpringPreviewExample.java}}

This file does nothing on its own, since there's no running `ApplicationContext` to scan
it, find the `@Autowired` constructor, and call it -- that container is exactly what we'll
cover in "Spring IoC Container & Bean Lifecycle." What matters for now: the `OrderService`
here is **identical in design** to the one in "Manual Dependency Injection Without Spring
(Composition Root)" -- Spring just does, by reading annotations, what
`buildOrderService()` did by hand.

> 💡 Tip
> Don't confuse this with the "Simple Dependency Injection Container" mini project from
> the Reflection lesson: the `SimpleContainer` we wrote there **discovered on its own, via
> reflection**, which parameters a type's constructor needed -- here, we explicitly mark
> which implementation wires to which interface with `@Component`/`@Service`. Spring's
> real container is a mix of both: it uses reflection, but it's also steered by
> annotations.

## Best Practices

- **Default to constructor injection** -- it makes required dependencies `final` and
  catches a missing one at the earliest possible point (see "Why Is Constructor Injection
  Recommended?").
- **Reserve setter injection for genuinely optional dependencies** -- if a class can't
  work meaningfully without a dependency, it belongs in the constructor, not a setter.
- **Avoid field injection** -- it provides neither testability nor visibility into a
  class's dependencies (see "Field Injection" and "Common Mistakes").
- **Depend on interfaces, not concrete classes** ("Dependency Injection: Programming to a
  Contract") -- this lets you swap real implementations, or use a fake one in tests,
  without touching any calling code.
- **Read a growing constructor parameter list as a warning** -- it's usually a sign the
  class has taken on too many responsibilities; consider splitting the class instead of
  adding yet another parameter.
- **Fail fast with `Objects.requireNonNull(...)`** ("Why Is Constructor Injection
  Recommended?") -- finding out about a missing dependency immediately, when the object is
  built, always beats hitting an unrelated error much later.

## Common Mistakes

**1. Defaulting to field injection because it's "less code."** Less code means less
control -- where the dependency comes from isn't visible in the source, and testing it by
hand requires reflection (see "Field Injection").

**2. Looking for a missing setter-injected dependency on the line where the error
appears.** The real cause is usually a much earlier line where a `setX(...)` call was
forgotten (see "Setter Injection").

**3. Treating a five-or-six-parameter constructor as normal.** That's an early sign the
class has taken on more than one responsibility (see "Why Is Constructor Injection
Recommended?").

**4. Letting a `null` dependency be accepted silently, with no check like
`Objects.requireNonNull(...)`.** Such an object gets built successfully but blows up
later, at its first real use, somewhere that looks unrelated (see "Why Is Constructor
Injection Recommended?").

**5. Assuming DI is a Spring-specific concept.** As "Manual Dependency Injection Without
Spring (Composition Root)" shows, DI is a design idea that works with no framework at all
-- Spring just automates it.

**6. Skipping interfaces and depending on concrete classes instead.** This brings back the
tight coupling problem from "Why Does It Exist?" and makes it impossible to use a fake
implementation in tests.

## Summary, Cheat Sheet, and Glossary

Dependency Injection is an object receiving its dependencies from the outside instead of
creating them itself; Inversion of Control is the more general "hand control outward" idea
behind it. Key points:

- Tight coupling (creating a concrete class directly with `new`) leads to
  untestability, difficulty changing, and mixed responsibility
- Three injection styles: **constructor** (required, `final`, earliest possible
  failure), **setter** (optional, reassignable later), **field** (least code, least
  control)
- Constructor injection should be the default -- guaranteed population, fail-fast
  validation, and a crowded parameter list works as an early design warning
- A "composition root": the one place an application knows its concrete classes, where
  all the `new` calls collect -- delivers IoC's benefits without Spring
- Spring automates the same idea with `@Component`/`@Service` scanning and
  `@Autowired` -- the container itself is the subject of the next lesson (Spring IoC
  Container & Bean Lifecycle)

Quick reference:

```java
// Tight coupling (avoid this)
class OrderService {
    private final EmailSender sender = new EmailSender();
}

// Constructor injection (recommended default)
class OrderService {
    private final NotificationSender sender;
    OrderService(NotificationSender sender) {
        this.sender = Objects.requireNonNull(sender);
    }
}

// Setter injection (only for genuinely optional dependencies)
class OrderService {
    private NotificationSender sender;
    void setSender(NotificationSender sender) { this.sender = sender; }
}

// Field injection (Spring: @Autowired; no manual equivalent without a framework/reflection)
class OrderService {
    private NotificationSender sender; // set by a framework via reflection
}

// Composition root: the one place that knows the concrete classes
class AppComposition {
    static OrderService buildOrderService() {
        return new OrderService(new EmailNotificationSender());
    }
}
```

**Glossary**

**Dependency Injection (DI)** — An object receiving the dependencies it needs from the
outside, instead of creating them itself.

**Inversion of Control (IoC)** — A component's flow/dependencies being managed by
something outside itself (a composition root or a container) rather than by the
component; DI is the most common concrete way of implementing IoC.

**Tight coupling** — A class being directly dependent (via `new`) on a concrete
implementation of another class it needs.

**Constructor Injection** — A dependency taken as a required constructor parameter and
stored in a `final` field.

**Setter Injection** — A dependency handed over, optionally, through a setter method
after the object has already been created.

**Field Injection** — A dependency assigned directly to a field, without going through a
constructor or setter, typically by a framework via reflection.

**Composition root** — The one place in an application where concrete classes are known
and `new` calls collect; also known as Pure DI or Poor Man's DI.

**Fail-fast** — Throwing an error (e.g., for a missing dependency) at the earliest point
it can be detected, usually when the object is constructed; makes the source of the error
easy to find.

**Test double / fake** — An object that stands in for a real implementation in a test,
with simplified or observable behavior.

## Appendix: Mini Project — A Multi-Channel Notification Dispatcher

Let's combine what we've learned so far ("Constructor Injection", "Dependency Injection:
Programming to a Contract") and take it one step further: instead of a single
`NotificationSender`, the dependency becomes **every implementation at once**. The idea is
simple -- `NotificationDispatcher` forwards the same message to every channel in the list
it was given, without knowing how many channels there are or what they're called:

{{NotificationDispatcher.java}}

{{NotificationDispatcherDemo.java}}

`NotificationDispatcher`'s constructor takes a `List<NotificationSender>` instead of a
single `NotificationSender` -- the composition root decides how many elements go into the
list (`allChannels` has three, `emailOnly` has one), and not a single line of
`dispatch(...)` changes.

> ⚠️ Warning
> When you inject a `List<NotificationSender>` in a real Spring container, the list's
> order is **undefined** by default (it can depend on bean definition order, or even
> class scanning order) -- if you need a specific order, use the `@Order` annotation or
> the `Ordered` interface. In the `List.of(...)` call we wrote by hand here, we control
> the order ourselves, but that guarantee doesn't come for free with Spring's automatic
> scanning.

## Appendix: Mini Project — A Payment Processor

The final mini project shows the same ideas again in a different domain (payment
processing), with one optional dependency (as mentioned in "Comparing the Injection
Styles," not every dependency has to be required). `PaymentProcessor` depends on a
required `PaymentGateway` (`Objects.requireNonNull`, see "Why Is Constructor Injection
Recommended?") and an optional, nullable `FraudChecker`:

{{PaymentProcessor.java}}

{{PaymentProcessorDemo.java}}

Notice the three scenarios in `PaymentProcessorDemo`: with fraud checking, without it
(passing `null`), and finally with a fake `PaymentGateway` written on the spot as a
lambda, just like in "Dependency Injection and Testability." In all three,
`PaymentProcessor`'s own code doesn't change by a single line.

> 💡 Tip
> Instead of letting `FraudChecker fraudChecker` be `null`, the Spring world usually
> makes this more explicit with `Optional<FraudChecker>` or `@Autowired(required =
> false)` -- we'll look at how Spring expresses optional dependencies in "Spring IoC
> Container & Bean Lifecycle."
