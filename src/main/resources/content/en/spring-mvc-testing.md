# Testing in Spring MVC

This is the last lesson in the Spring MVC category -- and in a way, it ties
all the others together. So far we've written `@Controller`/
`@RestController`s, `@RequestBody`/`ResponseEntity`, `@Valid`/`ProblemDetail`,
Thymeleaf views, `HandlerInterceptor`/CORS/multipart, and DTO/pagination/
idempotency patterns -- but we never actually **ran and verified** any of it.
This lesson covers how `MockMvc` and `@WebMvcTest` let us prove that code
actually does what it claims, quickly and repeatably, without spinning up a
real server.

## What Are Test Layers in Spring MVC?

There's no single way to test a Spring MVC application -- there are a few
layers, each with a different purpose:

```java
// Three different tests, three different speed/realism trade-offs:
// 1) Pure unit test: new TopicController(...).show(...) -- no Spring at all.
// 2) Slice test: @WebMvcTest + MockMvc -- only the web layer is loaded.
// 3) Integration test: @SpringBootTest -- the real app, a real DB (or test container).
```

This lesson focuses mainly on the middle layer: `MockMvc` with
`@WebMvcTest`. A pure unit test is very fast but never verifies HTTP itself
(path matching, headers, serialization); `@SpringBootTest` is realistic but
slow and needs a database. `@WebMvcTest` sits between the two -- it tests
real HTTP request-handling mechanics without a real server or database.

## Why Does It Exist?

Testing a controller by hand (with `curl` or a browser) is work that has to
be repeated on every change, easy to forget, and doesn't scale to
automation. Every controller we've written since `spring-mvc-fundamentals`
-- path matching, model attributes, JSON serialization, validation, error
bodies -- should be automatically re-verifiable on every code change.
`MockMvc` makes that possible without opening a real HTTP server (no socket,
no port) -- which keeps tests both fast and reliable in a CI environment.

## History

Spring Test MVC started out (around 2012) as a separate `spring-test-mvc`
project, outside Spring Framework's main codebase; that's where `MockMvc`
and its `andExpect` chaining API came from. Spring 3.2 moved that project
into Spring Framework itself (the `spring-test` module). Spring Boot 1.4
(2016) introduced "slice test" annotations like `@WebMvcTest` and its
sibling `@DataJpaTest` -- the goal being to load only the slice of the
`ApplicationContext` a test actually needs, not the whole thing.
`@MockBean` was, for a long time, the standard way to fill in missing
dependencies in these slices; Spring Boot 3.4 (2024) deprecated it in favor
of `@MockitoBean`, which moved into Spring Framework's own test
infrastructure -- since this project runs Spring Boot 4.1.0, we use only
`@MockitoBean` here.

## Unit Test vs. Slice Test vs. Integration Test: Where Does @WebMvcTest Sit?

`@WebMvcTest` actually runs the real `HandlerMapping`/`HandlerAdapter`/
`ViewResolver` machinery we saw in spring-mvc-fundamentals' "This Project's
Own Controllers: A Real Spring MVC Example" section, together with
DispatcherServlet's front controller pattern -- but it does NOT load the
`@Service`/`@Repository` layer or a real database connection. That makes it
a deliberate middle ground among the three options: more realistic than a
pure unit test (real HTTP request/response mechanics run), faster than a
full `@SpringBootTest` (no database, not every bean). The rest of this
lesson focuses on exactly that middle ground: `@WebMvcTest` and `MockMvc`.

## @WebMvcTest and MockMvc: Loading Only the Web Layer

Let's see concretely what `@WebMvcTest` does and doesn't load:

{{WebMvcTestSliceExample.java}}

`@WebMvcTest(PingController.class)` loads `DispatcherServlet`, message
converters, and the given controller (plus any `@ControllerAdvice`/
`HandlerInterceptor`/`WebMvcConfigurer` beans) -- but if it had a `@Service`
dependency, context startup would fail with "no qualifying bean". `MockMvc`
is one of the few beans this narrowed-down context can inject
automatically.

## Your First MockMvc Test: perform, andExpect, status()

Let's see `MockMvc` at its simplest, without even needing a Spring context:

{{FirstMockMvcTestExample.java}}

`MockMvcBuilders.standaloneSetup(...)` wires the given controller(s) into a
mini pipeline by hand, WITHOUT a Spring `ApplicationContext` -- that's why
this example can run as a plain `main()`, following this project's
run-with-`main()` convention. `perform(...)` sends a fake request (no real
socket opens), and `andExpect(...)` runs chainable assertions, throwing an
`AssertionError` if one fails.

## Faking Dependencies with @MockitoBean

We saw that `@WebMvcTest` doesn't load `@Service`/`@Repository` beans --
so what happens when a controller genuinely depends on one?

{{MockitoBeanExample.java}}

`@MockitoBean` adds a Mockito mock of the given type to the context (or
replaces a real bean if one exists) -- without it, `GreeterController`'s
`GreetingService` dependency would fail context startup with "no qualifying
bean". Note: instead of `@MockBean` (deprecated since Spring Boot 3.4,
removed in the 4.1.0 this project runs), we use `@MockitoBean` exclusively
here and throughout the rest of this lesson.

## Testing This Project's Own HomeController: A Real Example

Not a made-up controller -- let's test the real `HomeController` we
introduced in spring-mvc-fundamentals' "This Project's Own Controllers: A
Real Spring MVC Example" section. `HomeController` now has two endpoints:
`/{lang:en|tr}` renders the actual home page, while a bare `/` is a
language "negotiator" that 302-redirects to `/en` or `/tr` based on the
`Accept-Language` header:

{{HomeControllerTest.java}}

`HomeController`'s only dependency is `NavigationService`, so a single
`@MockitoBean` covers both tests. We don't care about the actual list
`buildNavigation(...)` returns -- what's being tested here isn't
`NavigationService`'s behavior, it's whether `HomeController` calls it
correctly and puts the right attributes into the model. The index test hits
`/en` directly instead of relying on an ambient default locale -- the
language is now an explicit URL segment, not implicit test-environment
state -- and the redirect test simply confirms a bare `/` request (no
`Accept-Language` header) lands on `/en`, matching the negotiator's
fallback.

## Verifying the Model and View Name: model(), view()

Two matchers that matter more than `content()` for a classic (non-JSON)
`@Controller`:

{{ModelAndViewAssertionExample.java}}

`view().name(...)` verifies the logical view name that's returned -- not
whether the physical HTML file got rendered (`standaloneSetup` has no
`ViewResolver`/template engine at all). `model().attribute(...)` verifies
an attribute's value, while `model().attributeExists(...)` verifies only
its presence.

## Testing a @RestController: Verifying a JSON Body with jsonPath

`@RestController`s have no view/model -- the response is straight JSON, and
the tool for verifying it is `jsonPath(...)`:

{{JsonPathAssertionExample.java}}

`jsonPath("$.field")` looks INSIDE the response body -- verifying fields one
at a time, rather than comparing the whole body as a string
(`content().json(...)`), is useful especially when you want to ignore part
of the body (like a server-generated timestamp). `jsonPath(...).exists()`/
`doesNotExist()` verify a field's presence without looking at its value at
all.

## Sending a Request Body: content() and contentType()

Sending a POST/PUT/PATCH body takes two pieces: the body itself, and its
type:

{{RequestBodyTestExample.java}}

`content(requestJson)` supplies the raw bytes/string, `contentType(...)`
supplies the Content-Type header -- without a Content-Type, Spring can't
tell which `HttpMessageConverter` to use, and the request can be rejected
(415 Unsupported Media Type). Hand-serializing with `ObjectMapper` is
usually pulled out into a small helper method in real projects, since it
repeats in almost every write test.

## Testing Path Variables and Query Parameters

Path variables live inside the URL itself; query parameters are added with
`.param(...)`:

{{PathVariableQueryParamTestExample.java}}

The placeholder-filling in `get("/api/categories/{categorySlug}/topics",
"spring-mvc")` matches `@PathVariable`; calls like `.param("page", "1")`
build the actual query string (`?page=1&size=5`) for you. We also verify
that an `@RequestParam(required = false)` parameter that isn't supplied
reaches the controller as `null`, not as a 400.

## Testing Validation Errors: 400 and ProblemDetail

`standaloneSetup(...)` sets up a default validator automatically, since
Bean Validation is on the classpath -- but as we saw in Validation &
Exception Handling's "Global Error Handling: @RestControllerAdvice"
section, `@ControllerAdvice` classes aren't scanned automatically:

{{ValidationErrorTestExample.java}}

Getting a proper error body requires adding the advice by hand with
`.setControllerAdvice(...)`. The `ValidationAdvice` here catches
`MethodArgumentNotValidException` and builds a `ProblemDetail` using the
same pattern from that lesson's "ProblemDetail: A Standard Error Body with
RFC 7807" section -- with one invalid and one valid request, we compare two
different outcomes from the same controller plus the same advice.

## Testing a Multipart File Upload: MockMultipartFile

Advanced Spring MVC's `MultipartUploadControllerExample`, from the
"Multipart File Upload: Taking a MultipartFile with @RequestParam" section,
hand-implemented `MultipartFile` because it lives in main scope -- here,
being in test scope, we can use the real `MockMultipartFile` directly:

{{MultipartUploadTestExample.java}}

`MockMultipartFile` is a real spring-test class that comes with
`spring-boot-starter-test` (test scope). `multipart(...)` is a special
request builder that builds a `multipart/form-data` body instead of the
usual `get()`/`post()` -- the file added with `.file(file)` matches the
controller's `@RequestParam("file") MultipartFile` parameter. Scenarios
like exceeding a size limit (see that same lesson's "Multipart
Configuration and Size Limits" section) can be tested the same way as
`ValidationErrorTestExample`, by adding an advice that catches the relevant
exception.

## Best Practices

- **Always use `@MockitoBean` instead of `@MockBean`** -- this project's
  Spring Boot 4.1.0 removed `@MockBean`; `@MockitoBean` does the same job
  and lives in Spring Framework's own test infrastructure (see "Faking
  Dependencies with @MockitoBean").
- **Scope `@WebMvcTest` to the specific controller you're testing**
  (`@WebMvcTest(HomeController.class)`, not left empty) -- leaving it empty
  loads every controller and slows the test down, while also making it
  unclear which dependency needs mocking (see "Testing This Project's Own
  HomeController: A Real Example").
- **Verify JSON responses field-by-field with `jsonPath(...)` instead of
  comparing the whole body as a string** -- this keeps the test from
  breaking when the body shape changes slightly, like when a new field is
  added (see "Testing a @RestController: Verifying a JSON Body with
  jsonPath").
- **Don't forget to add `@ControllerAdvice` by hand when using
  `standaloneSetup(...)`** -- otherwise error scenarios end up as a raw
  exception instead of the `ProblemDetail` you'd see in the real
  application (see "Testing Validation Errors: 400 and ProblemDetail").

## Common Mistakes

**1. Forgetting to mock a `@Service` dependency (`@MockitoBean`) with
`@WebMvcTest`.** The context fails at startup with "no qualifying bean" --
forgetting that `@WebMvcTest` never loads the `@Service`/`@Repository`
layer is the single most common mistake in this lesson (see "@WebMvcTest
and MockMvc: Loading Only the Web Layer").

**2. Forgetting `contentType(...)` on POST/PUT requests.** Even with a body
supplied via `content(...)`, without a Content-Type header Spring can't
tell which `HttpMessageConverter` to use, and the request can be rejected
with 415 (see "Sending a Request Body: content() and contentType()").

**3. Writing `jsonPath(...)` without checking whether the response is an
array or an object.** A list needs `$[0].title`, not `$.title` -- the wrong
expression leads to a confusing failure where the field simply can't be
found (see "Testing a @RestController: Verifying a JSON Body with
jsonPath").

**4. Assuming `@Valid` works with `standaloneSetup(...)` and skipping the
`@ControllerAdvice`.** The validator is set up by default and
`MethodArgumentNotValidException` does get thrown, but unless an advice
that turns it into a proper `ProblemDetail` is added by hand, the test hits
an unexpected 500 instead (see "Testing Validation Errors: 400 and
ProblemDetail").

**5. Trying to reach a real database inside a `@WebMvcTest`.** This slice
deliberately doesn't load `@Repository` beans -- a controller that needs a
repository won't work unless that repository is mocked with `@MockitoBean`
(see "Testing This Project's Own HomeController: A Real Example").

## Summary, Cheat Sheet, and Glossary

Testing in Spring MVC starts with a deliberate choice between three layers
-- a pure unit test, a `@WebMvcTest` slice test, or a full `@SpringBootTest`
integration test. Key points:

- `@WebMvcTest`: a slice test annotation that loads only the web layer
  (DispatcherServlet, controllers, converters), excluding `@Service`/
  `@Repository`
- `MockMvc`: a test tool that sends fake requests without opening a real
  HTTP server
- `MockMvcBuilders.standaloneSetup(...)`: an alternative setup that wires a
  controller pipeline by hand, without a Spring context
- `@MockitoBean`: an annotation that adds a Mockito mock to the context, or
  replaces a real bean (the replacement for `@MockBean`)
- `perform()`/`andExpect()`: the MockMvc methods that send a request and
  run chainable assertions, respectively
- `status()`/`view()`/`model()`/`jsonPath()`/`content()`/`header()`:
  matcher families that verify different response aspects (status code,
  view name, model attributes, JSON fields, body, headers)
- `MockMultipartFile`: a real spring-test class for multipart/form-data
  tests (test scope)

Quick reference:

```java
@WebMvcTest(TopicController.class)
class TopicControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private TopicRepository topicRepository;

    @Test
    void unknownSlugReturns404() throws Exception {
        when(topicRepository.findBySlugWithCategoryAndCourse("x"))
                .thenReturn(Optional.empty());

        mockMvc.perform(get("/en/topics/x"))
                .andExpect(status().isNotFound());
    }
}
```

**Glossary**

**`@WebMvcTest`** — A Spring Boot test slice annotation that loads only the
Spring MVC web layer, excluding `@Service`/`@Repository` beans.

**`MockMvc`** — A test tool for sending fake HTTP requests and verifying
responses without opening a real server or socket.

**`standaloneSetup`** — A setup method that wires given controllers into a
`MockMvc` pipeline by hand, without a Spring `ApplicationContext`.

**`@MockitoBean`** — An annotation that adds a Mockito mock to the test
context, or replaces a real bean; the replacement for `@MockBean`.

**`jsonPath`** — A matcher that verifies a specific field of a JSON
response body using a JSONPath expression.

**`MockMultipartFile`** — A fake file class provided by the `spring-test`
library, used for multipart file upload tests.

## Appendix: Mini Project — A Comprehensive Test Suite for This Project's Own TopicController

Bringing every technique from this lesson together, on this project's real
`TopicController` (all six dependencies mocked with `@MockitoBean`):

{{TopicTestFixtures.java}}

{{TopicControllerWebMvcTest.java}}

`TopicTestFixtures` provides helper methods that build the real `Course`/
`Category`/`Topic`/`TopicTranslation` entities (all using Lombok
`@Builder`) as a consistent tree. `TopicControllerWebMvcTest` covers three
scenarios: 404 for an unknown slug, a 301 redirect from the old
query-parameter URL (`/topics/{slug}?lang=..`) to the new path-based one,
and 200 through the real `topic.html` template for a fully published topic
-- in that last scenario, every mocked value is the same type the
controller receives from real services in production (a real `Topic`, a
real `MarkdownService.MarkdownRenderResult`), so the template renders
normally, as if it were handling a real request.

## Appendix: Mini Project — Testing an Interceptor with MockMvc

The last mini project tests the lifecycle from Advanced Spring MVC's "The
HandlerInterceptor Interface: preHandle, postHandle, afterCompletion"
section, in isolation with `MockMvc`, without ever writing a configuration
class like the one in "WebMvcConfigurer: Registering an Interceptor":

{{TimingInterceptorForTest.java}}

{{TimingInterceptorMockMvcTest.java}}

`TimingInterceptorForTest` is a small, realistic `HandlerInterceptor` that
adds an `X-Response-Time-Ms` header to every request.
`TimingInterceptorMockMvcTest` attaches it directly to `MockMvc` with
`standaloneSetup(...).addInterceptors(...)` -- verifying the interceptor ON
ITS OWN, without ever bringing in the whole application's configuration
(path patterns, other interceptors).
