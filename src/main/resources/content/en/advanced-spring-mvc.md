# Advanced Spring MVC

In Spring MVC Fundamentals' "The Journey of an HTTP Request: Request Lifecycle"
section, we saw how a request reaches DispatcherServlet, and from there gets
routed to a controller method via `HandlerMapping`/`HandlerAdapter`. On top of
that journey, there are two ways to add **cross-cutting** behavior to every
request: `Filter` (at the Servlet API level, outside DispatcherServlet) and
`HandlerInterceptor` (at the Spring MVC level, inside DispatcherServlet). This
lesson covers both, the `WebMvcConfigurer` both of them are configured through,
how browsers restrict cross-origin requests (CORS), and how file uploads
(`multipart/form-data`) fit into this pipeline.

## What Is HandlerInterceptor?

`HandlerInterceptor` is a Spring MVC interface that lets you write code that
runs **before** a controller method is called, **after** it's called, and once
the response is fully done -- for behavior like logging, authentication, or
timing that repeats across many endpoints but doesn't belong to any single
endpoint's business logic:

```java
interface MinimalInterceptor {
    boolean preHandle(Object request, Object response, Object handler);
    void afterCompletion(Object request, Object response, Object handler, Exception ex);
}
```

The real interface uses `jakarta.servlet.http.HttpServletRequest`/
`HttpServletResponse` and has a third method (`postHandle`) as well -- the topic
of "The HandlerInterceptor Interface: preHandle, postHandle, afterCompletion."

## Why Does It Exist?

Adding the same logging/auth code by hand to every controller method is another
instance of the repetition problem we saw in Validation & Exception Handling's
"Why Does It Exist?" section -- the rule repeats everywhere, and it's easy to
forget in one place. `HandlerInterceptor` moves that cross-cutting behavior to
**one place** and lets `WebMvcConfigurer` decide, centrally, which URLs it
applies to; the controllers themselves stay unaware of it.

## History

The `HandlerInterceptor` interface has been around since Spring MVC's earliest
versions -- it's as old as Spring MVC itself. Spring 5.0 (2017) made all three
methods **default** (before that you had to extend the abstract class
`HandlerInterceptorAdapter` just to override one method); in the version this
project uses, `HandlerInterceptorAdapter` is no longer needed. CORS support
arrived in Spring 4.2 (2015) with `@CrossOrigin`, and Spring 4.3 added global
support through `WebMvcConfigurer.addCorsMappings` -- before that, CORS meant
writing a `Filter` by hand. Multipart support entered the Servlet API with
Servlet 3.0 (2009), and from there into Spring MVC through `MultipartResolver`.

## Filter vs. Interceptor: Both "Get in the Way," but Where?

Both wrap code around a request, but at different layers:

{{FilterVsInterceptorExample.java}}

`Filter` is part of the Servlet API -- the container (embedded Tomcat) runs
every request through the filter chain before it ever reaches
DispatcherServlet; that means even a request for a static file, or one that
will end in a 404, still passes through filters. `HandlerInterceptor` only
kicks in once DispatcherServlet has actually matched a request to a handler --
if there's no match, it never runs at all. We'll see exactly how these two
layers nest around each other in "The Journey of a Request: Filter Chain and
Interceptor Chain Together."

## The HandlerInterceptor Interface: preHandle, postHandle, afterCompletion

The three callbacks correspond to three different moments:

{{HandlerInterceptorLifecycleExample.java}}

`preHandle` runs **before** the handler method -- returning `false` stops the
chain right there, and neither the handler nor `postHandle` runs (see
"Stopping a Request in preHandle: A Simple Auth/Logging Example"). `postHandle`
runs after the handler completes successfully, but **before** the view is
rendered -- it can still modify the `ModelAndView`. `afterCompletion` runs
after the view has been rendered, even if the handler threw an exception --
which makes it the most reliable place for cleanup/logging (see "Appendix:
Mini Project — An Interceptor That Logs Request Duration").

## The Journey of a Request: Filter Chain and Interceptor Chain Together

Filters and interceptors nest inside the same request:

{{RequestPipelineSimulationExample.java}}

A filter wraps DispatcherServlet's **entire** call, including view rendering --
interceptors only wrap the handler call; even `afterCompletion` runs after the
view is rendered, but still before the filter's "after" code. Knowing this
order answers "where should this code be logged" -- if you need to see every
request (static files included), use a `Filter`; if you only care about
requests that reach a controller, use a `HandlerInterceptor`.

## WebMvcConfigurer: Registering an Interceptor

Implementing a `HandlerInterceptor` isn't enough on its own -- unlike a
`@Component` from Component Scanning, it isn't found automatically; it has to
be registered explicitly:

{{InterceptorRegistrationExample.java}}

`WebMvcConfigurer` is the extension point Spring MVC looks for at startup -- a
`@Configuration` class that implements it and overrides `addInterceptors` gets
every interceptor added via `registry.addInterceptor(...)` added to
`HandlerMapping`'s interceptor list. This project doesn't register an
interceptor right now -- `WebConfig.java` is a `@Configuration` class that only
defines a `LocaleResolver` bean; if an interceptor were added, overriding
`addInterceptors` on that same class would be the natural place for it.

## addPathPatterns and excludePathPatterns: Scoping an Interceptor

Not every interceptor needs to run on every URL:

{{PathPatternScopingExample.java}}

`addPathPatterns("/topics/**")` limits an interceptor to URLs matching that
pattern; `excludePathPatterns(...)` then carves a subset back out of an
included pattern. Path Variables and Request Parameters covered the URL
patterns used by `@GetMapping` -- the `/**` here uses the exact same Ant-style
matching, the only difference is that it scopes an interceptor instead of a
handler method.

## Multiple Interceptors: Ordering and Chaining

With more than one interceptor registered, order matters:

{{MultipleInterceptorOrderExample.java}}

`preHandle` calls run in **registration order**; `postHandle` and
`afterCompletion` run in **reverse order** -- the same "stack" pattern as
try-with-resources closing multiple resources. This lets one interceptor
safely assume another interceptor's `preHandle` has already run -- for
instance, a logging interceptor can safely read, in its `postHandle`, a user
attribute an auth interceptor placed on the request.

## Stopping a Request in preHandle: A Simple Auth/Logging Example

`preHandle`'s ability to return `false` also makes it usable for a simple
access check:

{{AuthLoggingInterceptorExample.java}}

The `response.setStatus(401)` call matters here -- returning `false` stops the
chain, but unless you set the status code **yourself**, the client still gets
a default `200`. This is a heavily simplified version of what a real security
framework (like Spring Security) does -- this project doesn't use Spring
Security, but the core idea (reject the request before it reaches a handler)
is exactly the same.

## What Is CORS? Same-Origin Policy and the Preflight Request

Browsers block a page from reading data from a different origin
(scheme+host+port) by default -- the **same-origin policy**. CORS is the
standard way for a server to say "I allow this origin":

{{CorsPreflightExample.java}}

For a request that isn't "simple" (say, one carrying a custom header, or using
a method other than `GET`/`POST`), the browser first sends a **preflight** --
without sending the real request at all, it asks, using `OPTIONS`, "am I
allowed to make this request?" If the server doesn't answer with the right
`Access-Control-Allow-*` headers, the browser never sends the real request.
`CorsConfiguration` is the object that produces that answer -- its
`checkOrigin`/`checkHttpMethod` methods compute the response to whatever the
browser is asking.

## @CrossOrigin: CORS at the Controller/Method Level

`@CrossOrigin` is the way to declare CORS for individual endpoints:

{{CrossOriginAnnotationExample.java}}

The same `getAnnotation` mechanism from the Reflection lesson is at work here
too -- at startup, Spring scans every handler method, and if `@CrossOrigin` is
present, builds a `CorsConfiguration` from its attributes (`origins`,
`methods`, ...) and stores it for that mapping. It's the exact same mechanism
that reads `@RequestMapping` and its shortcuts (the Mapping Annotations and
HTTP Methods lesson).

## Global CORS Configuration with WebMvcConfigurer

Instead of adding `@CrossOrigin` to every controller, you can also configure
CORS for all of `/api/**` in one place:

{{GlobalCorsConfigExample.java}}

`addCorsMappings` is another method on the same `WebMvcConfigurer` interface as
`addInterceptors` from "WebMvcConfigurer: Registering an Interceptor" -- both
can live in the same `@Configuration` class. If a URL pattern matches more than
one `CorsRegistration` (say, one global and one via `@CrossOrigin`), Spring
tries to merge them, but in practice it's usually best to pick **either**
global **or** annotation-based, not both, to avoid confusion.

## Multipart File Upload: Taking a MultipartFile with @RequestParam

File uploads use a different mechanism than `@RequestBody` (Request and
Response Handling), which reads a single JSON body:

{{MultipartUploadControllerExample.java}}

`multipart/form-data` splits a request into named **parts** -- each part can be
a plain form field or a file. `MultipartFile` is bound with `@RequestParam`,
the same way as "@RequestParam: Reading a Value from the Query String" in Path
Variables and Request Parameters, but what it reads isn't a query parameter,
it's a part of the request -- accessed through methods like
`getOriginalFilename()`, `getSize()`, `getBytes()`.

## Multipart Configuration and Size Limits

`spring.servlet.multipart.max-file-size`/`max-request-size` set an upper bound
Spring rejects before a request ever reaches a handler:

{{MultipartSizeLimitExample.java}}

The `MaxUploadSizeExceededException` thrown when the limit is exceeded is
caught the same way as in Validation & Exception Handling's "Catching Errors
at the Controller Level: @ExceptionHandler" and "Global Error Handling:
@RestControllerAdvice" sections; returning a standard error body like
"ProblemDetail: A Standard Error Body with RFC 7807" is a much better behavior
than letting a raw stack trace leak to the client.

## Best Practices

- **Only reach for `Filter` when you genuinely need to see every request
  (static files included); otherwise prefer `HandlerInterceptor`** -- the
  latter works closer to Spring's own mechanisms (Model, exception handling)
  (see Filter vs. Interceptor: Both "Get in the Way," but Where?).
- **Put cleanup/logging code in `afterCompletion`, not `postHandle`** -- only
  `afterCompletion` runs even if the handler throws (see "The
  HandlerInterceptor Interface: preHandle, postHandle, afterCompletion").
- **Manage CORS either globally (`WebMvcConfigurer.addCorsMappings`) or via
  annotation (`@CrossOrigin`), not a mix of both** -- mixing the two makes it
  harder to track which rule applies to which endpoint (see "Global CORS
  Configuration with WebMvcConfigurer").
- **Always configure multipart size limits explicitly** -- the defaults
  (1MB in Spring Boot) are either far too low or simply left unconsidered for
  most real upload scenarios; either way, it should be a deliberate decision
  (see "Multipart Configuration and Size Limits").

## Common Mistakes

**1. Assuming `Filter` and `HandlerInterceptor` are interchangeable.** A
`Filter` has no access to Spring concepts like `Model`/`HandlerMethod` -- it
only sees the raw `ServletRequest`/`ServletResponse`; if you need to know
which controller a request matched, `HandlerInterceptor` is the right tool
(see Filter vs. Interceptor: Both "Get in the Way," but Where?).

**2. Returning `false` from `preHandle` and forgetting to set the response
status.** The chain stops, but the client still gets a default `200 OK` --
you have to call `response.setStatus(...)` before returning `false` (see
"Stopping a Request in preHandle: A Simple Auth/Logging Example").

**3. Assuming `postHandle` also runs in registration order with multiple
interceptors.** `preHandle` runs forward, `postHandle`/`afterCompletion` run in
reverse -- forgetting this can lead an interceptor to read another one's state
at the wrong moment (see "Multiple Interceptors: Ordering and Chaining").

**4. Looking for a CORS error in server logs, thinking it's a server-side
failure.** When a preflight fails, the browser never sends the real request at
all -- nothing may show up in the server log; the error only appears in the
browser's own developer console (see "What Is CORS? Same-Origin Policy and the
Preflight Request").

**5. Adding `@CrossOrigin` only at the class level and forgetting that a
method-level one overrides it.** A class-level `@CrossOrigin` applies to every
method by default, but a method that declares its own `@CrossOrigin`
**completely replaces** the class-level one rather than merging with it -- this
can unexpectedly strip CORS permissions from some endpoints (see
"@CrossOrigin: CORS at the Controller/Method Level").

**6. Setting only `max-file-size` and forgetting `max-request-size`.** In a
request with multiple files, each one can stay under the per-file limit while
the total still exceeds `max-request-size` -- they're two separate limits, and
both need to be configured (see "Multipart Configuration and Size Limits").

## Summary, Cheat Sheet, and Glossary

`Filter` and `HandlerInterceptor` are two layers for adding cross-cutting
behavior around a request; `WebMvcConfigurer` is the central place both
(interceptor registration, CORS) get configured; CORS and multipart are two
concrete scenarios real-world applications run into often. Key points:

- `Filter`: Servlet API level, sees **every** request (outside
  DispatcherServlet)
- `HandlerInterceptor`: Spring MVC level, only sees matched requests
  (`preHandle`/`postHandle`/`afterCompletion`)
- If `preHandle` returns `false`, the chain stops -- the handler and
  `postHandle` never run
- `afterCompletion` always runs, even on exception -- the most reliable place
  for cleanup/logging
- Multiple interceptors: `preHandle` runs forward, `postHandle`/
  `afterCompletion` run in reverse
- `WebMvcConfigurer.addInterceptors`/`addCorsMappings`: extension points for
  interceptor registration and global CORS
- CORS: the server-side relaxation of the same-origin policy; preflight is a
  permission question asked ahead of time with `OPTIONS`
- `@CrossOrigin`: CORS at the controller/method level, an alternative to
  `WebMvcConfigurer`
- `MultipartFile`: an interface representing one part of a
  `multipart/form-data` request, bound with `@RequestParam`
- `max-file-size`/`max-request-size`: two separate size limits for multipart
  uploads

Quick reference:

```java
@Configuration
class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new AuthInterceptor())
                .addPathPatterns("/api/**")
                .excludePathPatterns("/api/public/**");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("https://example.com")
                .allowedMethods("GET", "POST");
    }
}

@RestController
class UploadController {
    @PostMapping("/upload")
    ResponseEntity<String> upload(@RequestParam("file") MultipartFile file) {
        return ResponseEntity.ok(file.getOriginalFilename() + ": " + file.getSize() + " bytes");
    }
}
```

**Glossary**

**`Filter`** — Part of the Servlet API; an interface the container runs every
request through before it reaches DispatcherServlet, used for cross-cutting
behavior.

**`HandlerInterceptor`** — A Spring MVC-specific interface that wraps only
requests matched to a handler, with `preHandle`/`postHandle`/`afterCompletion`
callbacks.

**`WebMvcConfigurer`** — The extension point `@Configuration` classes
implement to configure Spring MVC concerns like interceptor registration and
CORS.

**Same-origin policy** — The browser security rule that blocks a page from
reading data from a different origin by default.

**CORS (Cross-Origin Resource Sharing)** — The HTTP header mechanism that lets
a server relax the same-origin policy for specific origins.

**Preflight request** — The browser's advance `OPTIONS` request asking the
server for permission before sending a "non-simple" request.

**`@CrossOrigin`** — An annotation that declares CORS permissions at the
controller class or method level.

**`MultipartFile`** — A Spring interface representing a single file part of a
`multipart/form-data` request.

**`MaxUploadSizeExceededException`** — The exception Spring throws when a
configured size limit is exceeded, catchable with `@ExceptionHandler`.

## Appendix: Mini Project — An Interceptor That Logs Request Duration

Bringing this lesson's `HandlerInterceptor` mechanics together in a realistic
scenario: an interceptor that starts a timer in `preHandle` and logs the
elapsed time in `afterCompletion`, whether the handler succeeded or not:

{{RequestLoggingInterceptorExample.java}}

{{RequestLoggingInterceptorDemo.java}}

Using `afterCompletion` is a deliberate choice -- as we saw in "The
HandlerInterceptor Interface: preHandle, postHandle, afterCompletion," this
callback runs even if the handler throws, so a request that's both slow **and**
failing still gets logged correctly. `RequestLoggingInterceptorDemo` simulates
both a successful and a failing request to show both getting logged.

## Appendix: Mini Project — A CORS-Enabled File Upload Endpoint

The last mini project brings three of this lesson's topics together
(`@CrossOrigin`, `MultipartFile`, and `@ExceptionHandler` for an exceeded size
limit) into a single endpoint:

{{FileUploadCorsController.java}}

{{FileUploadCorsDemo.java}}

`FileUploadCorsController` carries `@CrossOrigin` so it can be called from a
different origin (a separate frontend application, for instance), takes the
file through a `MultipartFile` parameter, and returns a `ProblemDetail` for a
file that exceeds the size limit through its own `@ExceptionHandler` (this
time **local** to the controller, instead of a `@RestControllerAdvice` like in
Validation & Exception Handling). `FileUploadCorsDemo` shows two calls -- a
successful one with a small file, and a 413 result with a large one.
