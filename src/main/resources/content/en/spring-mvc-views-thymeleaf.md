# Spring MVC Views and Thymeleaf

In Spring MVC Fundamentals we saw how `Model` carries data from the controller to
the view, but never looked at the view itself -- the template file that actually
turns that `Model` into HTML. Validation & Exception Handling stayed entirely on
the `@RestController` side too: JSON bodies, `ResponseEntity`, `ProblemDetail`.
This lesson turns to the other side of the coin, the one this project actually
uses -- how the logical view name returned by `@Controller` becomes real HTML in
this project's own `templates/topic.html` and `templates/fragments/layout.html`
files. The technology that does that translation, brought in by
`spring-boot-starter-thymeleaf`, is **Thymeleaf**.

## What Is the View Layer in Spring MVC?

In "ViewResolver: From Logical View Name to HTML" (Spring MVC Fundamentals) we
saw `ViewResolver` translate a view name like `"topic"` into
`templates/topic.html`. The view layer is exactly that file's content -- a
template that describes how the data placed into the `Model` should be turned
into HTML:

```java
// From DispatcherServlet's point of view, a "View" can be summarized as one method:
interface MinimalView {
    void render(java.util.Map<String, Object> model,
                jakarta.servlet.http.HttpServletResponse response) throws java.io.IOException;
}
```

In real Spring MVC, that interface's actual name is
`org.springframework.web.servlet.View`; the Thymeleaf integration provides a
`ThymeleafView` that implements it -- its `render` method copies the `Model` into
Thymeleaf's own `Context` and processes the template.

## Why Does It Exist?

Without a view layer, every controller would have to build HTML by hand through
Java string concatenation -- hard to read, prone to XSS (it's easy to forget to
escape something by hand), and it makes it impossible for a designer and a
developer to work on the same file. A template engine separates HTML structure
(the designer's territory) from data (what the controller produces); Thymeleaf in
particular does that separation with a philosophy it calls **"natural
templating"** -- exactly the topic of the next section, What Is Thymeleaf? The
"Natural Templating" Philosophy.

## History

Thymeleaf 1.0 shipped in 2011 as an alternative to JSP, which was the common
choice in the Spring world at the time -- instead of JSP's `<%...%>` scriptlets
and its dedicated `.jsp` extension, it proposed an engine that works on plain
`.html` files. Thymeleaf 2.0 (2013) matured the Spring integration
(`thymeleaf-spring`). Thymeleaf 3.0 (2016) introduced a new processing engine
that significantly improved performance (especially for large templates), and
that's still the main release line in use today. Spring Boot has auto-configured
Thymeleaf through `spring-boot-starter-thymeleaf` since 1.0 (2014) -- the path
this project also takes; JSP fell out of favor in the Spring Boot world largely
because it doesn't fit well with the embedded servlet container model (the
subject of the Auto-Configuration lesson).

## Model, ModelMap, and ModelAndView: Three Ways to Carry Data to the View

Spring MVC Fundamentals' "Model: Carrying Data from Controller to View" section
covered `Model` -- but it's not the only way to get data from a controller to a
view:

{{ModelVariantsExample.java}}

All three end up in the same place: a String-keyed data map the view reads from.
`Model` is a narrow interface that extends `ModelMap`; `ModelMap` can also be used
directly like a `java.util.Map`. `ModelAndView` bundles both (the data and the
view name) into a single return value -- for a controller like this project's
`TopicController.show`, where the view name is always the same (`"topic"`) but
which sections get rendered depends on a flag (`contentAvailable`), the split
between a `Model` parameter and a `String` return value is usually more readable;
`ModelAndView` is more useful when the view name itself is what varies.

## What Is Thymeleaf? The "Natural Templating" Philosophy

The idea that sets Thymeleaf apart from other template engines is that a template
is meant to be **both** valid HTML **and** a processable template at the same
time:

{{NaturalTemplatingExample.java}}

`th:text="${message}"` is an HTML attribute -- a browser that doesn't recognize it
simply ignores it and shows the plain text inside the tag ("This is placeholder
text..."). On the server side, once Thymeleaf processes it, that text is replaced
with the actual value of `${message}`. That's something JSP's `<% %>` scriptlets,
or the `{{ }}` syntax of engines like Mustache, **can't** do -- a file containing
them looks broken when opened directly in a browser or a design tool. This is
exactly why this project's own `templates/topic.html` is valid HTML a designer
(or you) can preview directly in a browser without ever running Thymeleaf.

## Variable Expressions: Reading Model Data with ${...}

`${...}` is the basic way to read data placed into the `Model`:

{{VariableExpressionExample.java}}

Notice the parentheses in `${topic.title()}` -- since `Topic` is a `record`, its
accessor isn't `getTitle()`, it's `title()` directly. That's not an arbitrary
syntax choice: this project's own `fragments/layout.html` accesses the
`CourseNav`/`CategoryNav`/`TopicNavItem` records the exact same way
(`course.name()`, `category.slug()`, `topicItem.title()`) -- we'll see that in the
actual file in "This Project's Own Layout: fragments/layout.html and the Sidebar
Accordion." Index access like `${tags[0]}` also works directly on lists.

## Link Expressions: Building URLs with @{...}

`@{...}` builds a URL -- you don't need separate string concatenation for path
variables and query parameters:

{{LinkExpressionExample.java}}

Inside `@{/topics/{slug}(slug=${slug}, lang=${lang})}`, the parenthesized part
plays two roles: if a path placeholder named `{slug}` already exists in the path,
the matching parameter (`slug=${slug}`) is substituted into it; any remaining
parameters (`lang=${lang}`) automatically become a query string like `?lang=en`.
This project's own `topic.html` line,
`th:href="@{/topics/{slug}(slug=${topic.slug}, lang=${otherLanguage.code})}"`, is
a direct use of that mechanism -- the view-side counterpart of the same
path/query distinction we read on the server side with `@PathVariable`/
`@RequestParam` in Path Variables and Request Parameters.

## Displaying Text: th:text vs. th:utext

`th:text` always **escapes** its output (encodes HTML special characters);
`th:utext` ("unescaped text") writes it out verbatim:

{{TextVsUtextExample.java}}

Escaping is the default **and** the safe behavior -- if a user-supplied string
contains a `<script>` tag, `th:text` turns it into harmless plain text. This
project's `topic.html` uses `th:utext="${contentHtml}"` -- so it does **not**
escape -- but that's a deliberate exception: `contentHtml` isn't user input, it's
trusted HTML that `MarkdownService` produces **on the server, from `.md` files in
the repo** (see the accompanying comment in `topic.html`). Any text that could
come from a user (a future comment form, for example) should always be rendered
with `th:text`.

## Conditional Rendering: th:if and th:unless

`th:if` **removes the tag from the output entirely** when its condition is
falsy -- it doesn't hide it like `display:none`, it never reaches the HTML at
all; `th:unless` checks the opposite condition:

{{ConditionalRenderExample.java}}

This project's `topic.html` uses exactly this pair:
`th:if="${!contentAvailable}"` for the "not available in this language" warning,
and `th:if="${contentAvailable}"` for the actual content block -- the two never
render at the same time because the conditions are exact opposites of each other.
A `null` check works through the same mechanism: `th:if="${previousTopic != null}"`
keeps the "Previous" link from showing up at all on the first topic (the
`th:if="${previousTopic != null}"` line in the navigation block).

## Loops: Rendering Lists with th:each

`th:each` repeats the tag it's on once for every element in a collection:

{{IterationExample.java}}

The `iterStat` in `topic, iterStat : ${topics}` is an optional **status
variable** -- it carries fields like `count`, `index`, `size`, `first`, `last`,
`even`, `odd`. This project's sidebar (`fragments/layout.html`) never uses the
status variable (`th:each="topicItem : ${category.topics()}"`) because it doesn't
need to; but when you want to style the last item in a list differently (as in
this lesson's "Appendix: Mini Project — A Simple Blog Page"), `iterStat.last` is
exactly what it's for.

## Message Expressions: i18n with #{...}

`#{...}` is the Thymeleaf counterpart of the `messages*.properties` mechanism
from the i18n lesson -- it turns a key into text resolved for the current locale:

{{MessageExpressionExample.java}}

In a real Thymeleaf template this is one line:
`th:text="#{topic.unavailable(${languageName})}"`. What happens behind the
scenes is exactly what `TopicController.buildUnavailableMessage` does by hand --
picking a bundle from a `MessageSource` based on locale and filling in `{0}`-style
placeholders; the difference is that Thymeleaf does this automatically for every
`#{...}` it sees. This project's `topic.html` already relies on this for UI text
like `#{nav.previous}`, `#{breadcrumb.home}`, `#{toc.onThisPage}` -- the fact that
`buildUnavailableMessage` is written by hand is a **special** case where the
word order differs enough between Turkish and English that a single `{0}`
placeholder isn't enough (see the corresponding Javadoc in `TopicController`).

## Fragments: th:fragment, th:insert, and th:replace

A piece of markup that repeats across a site (a navbar, a footer, a card
component) is defined once with `th:fragment` and pulled in wherever it's needed
with `th:insert`/`th:replace`:

{{FragmentExample.java}}

The difference is exactly one thing: `th:insert` places the fragment **inside the
host tag** (the host tag stays); `th:replace` **swaps the host tag out** (the
fragment's own root tag takes its place). This project's `topic.html` always uses
`th:replace`, as in `<div th:replace="~{fragments/layout :: navbar}"></div>` --
because that `<div>` itself has no reason to survive into the output, it's only
there to mark the fragment's location. The `fragments/layout` in
`~{fragments/layout :: navbar}` points at a separate file; the `::` in this
example's `~{::badge(...)}` means "this same template."

## SpringEL Selection Expressions: .?[...] and #vars

`.?[...]` filters a collection -- the condition inside the square brackets is
evaluated once per element, with `#this` bound to that element:

{{SelectionExpressionExample.java}}

> ⚠️ Warning
> Inside a selection expression, `#this` rebinds the **entire evaluation scope**
> to the current element -- so referring to an outer context variable by its bare
> name (`activeSlug`) inside the brackets no longer looks up that variable, it
> looks for a field with that name on the element instead, and fails.
> `#vars.activeSlug` bypasses that rebinding and reaches straight into the
> top-level context variables. This project's real `fragments/layout.html`
> sidebar hit exactly this trap while computing `categoryIsActive` --
> `.?[#this.slug() == activeTopicSlug]` threw a `SpelEvaluationException`, and
> `.?[#this.slug() == #vars.activeTopicSlug]` fixed it (see "Known Constraints"
> in the project notes).

## This Project's Own Layout: fragments/layout.html and the Sidebar Accordion

Every mechanism in this lesson can be seen in the project's own
`templates/fragments/layout.html` and `templates/topic.html` files.
`layout.html` defines three fragments: `navbar`, `sidebar`, `footer` --
`topic.html` and `index.html` pull them in with `th:replace` (exactly the
mechanism from "Fragments: th:fragment, th:insert, and th:replace").

The sidebar's category accordion brings together almost every topic in this
lesson in one place: `th:each="category : ${course.categories()}"` walks each
category ("Loops: Rendering Lists with th:each"), `th:with` computes two local
variables named `categoryId` and `categoryIsActive` (`categoryIsActive`, using
exactly the `.?[...]` + `#vars` pattern from "SpringEL Selection Expressions:
.?[...] and #vars"), `th:classappend="${categoryIsActive} ? 'show' : ''"` adds a
conditional CSS class, and `th:each="topicItem : ${category.topics()}"` lists
that category's topics. It works together with Bootstrap's own
`data-bs-toggle="collapse"` mechanism -- Thymeleaf only computes the right
`id`/`aria-expanded`/CSS classes, the expand/collapse animation itself is
entirely Bootstrap's JavaScript.

## Form Binding (A Quick Look): th:object and th:field

This project doesn't have a form yet -- every page is read-only content. But
Thymeleaf's Spring-specific form dialect offers `th:object`/`th:field` for
binding any future `@ModelAttribute`-backed form:

{{FormBindingExample.java}}

`th:object` determines which object `*{...}` expressions (starred, unlike
`${...}`) resolve against; `th:field="*{author}"` both reads that object's
`author` field as the `value` and derives the `id`/`name` attributes from the
field name -- that same `name` is what Spring's `DataBinder` writes back into
when the form is `POST`ed. Whenever this project adds a form (a comment form, for
instance), this mechanism becomes a direct counterpart to the
`@RequestBody`/`HttpMessageConverter` pair from Request and Response Handling --
one binds a JSON body to an object, the other binds form fields.

## MVC (Server-Side Rendering) vs. REST: Which One, When?

Spring MVC Fundamentals' "@Controller vs. @RestController: Which One, When?"
section drew this line at the annotation level; now that we know the view layer
too, we can compare the outcomes. Server-side rendering (`@Controller` +
Thymeleaf, the path this project takes) sends the browser directly viewable
HTML -- the first page load feels faster (there's no waiting on JavaScript to
fetch data and build the DOM), SEO works naturally (a search engine already sees
HTML), but every page transition needs a full page load (or at least a server
round-trip). REST (`@RestController` + JSON, the kind of API a
single-page-application consumes) sends the client only data -- the client side
(React, Vue...) turns it into DOM; page transitions can feel smoother, but the
first load is heavier and SEO needs extra effort (server-side rendering,
prerendering). This project is a learning site -- content is largely static, SEO
matters, and it doesn't need complex client-side interaction -- so server-side
rendering is a deliberate choice (the same kind of reasoning as the
blocking/non-blocking trade-off in Spring MVC Fundamentals' "Spring MVC vs.
Spring WebFlux (A Quick Look)").

## Best Practices

- **Only use `th:utext` for trusted, server-generated content** -- any text that
  could come from a user must be escaped with `th:text` (see "Displaying Text:
  th:text vs. th:utext"); this project's `contentHtml` exception is deliberate
  and documented, not the default.
- **Inside selection/projection expressions (`.?[...]`, `.^[...]`, `.![...]`),
  always reach outer variables with `#vars.`** -- forgetting that `#this` changes
  scope caused a real bug in this project's sidebar (see "SpringEL Selection
  Expressions: .?[...] and #vars").
- **Prefer `th:replace` for fragments unless the host tag actually needs to
  survive** -- unnecessary `<div>` wrappers can produce unexpected gaps in CSS,
  especially in flex/grid layouts.
- **Put only what rendering needs into the view, not business logic** -- none of
  the three mechanisms in "Model, ModelMap, and ModelAndView: Three Ways to
  Carry Data to the View" restrict how the view uses that data; that discipline
  is on the developer -- the same idea as Spring MVC Fundamentals' "keep
  controllers thin, push logic to the service layer," applied here to the view
  layer.

## Common Mistakes

**1. Making `th:utext` a habit instead of `th:text`.** Reaching for `th:utext`
because "it's not working" and forgetting to switch back opens the door to XSS
in any field that can contain user input -- `th:text`'s escaping is almost always
the behavior you **want** (see "Displaying Text: th:text vs. th:utext").

**2. Referring to an outer variable by its bare name inside a `.?[...]`.**
Because `#this` changes scope, the lookup targets a field on the element instead
of the variable you meant, usually resulting in a `SpelEvaluationException` (see
"SpringEL Selection Expressions: .?[...] and #vars").

**3. Accessing a record field in `${...}` with `.title` (no parentheses).** On a
bean-style class, a `getTitle()` getter corresponds to the property `title`, but
on a record the accessor is a real method (`title()`) -- `${topic.title}` can
silently return `null` or fail depending on the case; the safe form is always
`${topic.title()}` (see "Variable Expressions: Reading Model Data with ${...}").

**4. Mixing up `th:insert` and `th:replace`.** Both pull in a fragment, but one
keeps the host tag and the other takes its place -- picking the wrong one shows
up as an unexpected extra wrapper tag in the output (`th:insert`) or a missing
wrapper you were relying on (`th:replace`) (see "Fragments: th:fragment,
th:insert, and th:replace").

**5. Not noticing that a path placeholder in `@{...}` doesn't match the
parameter name.** Writing `@{/topics/{slug}(id=${slug})}`, the parameter name in
the parentheses (`id`) doesn't match the placeholder in the path (`{slug}`), so
the placeholder is never filled and `id` falls through to the query string --
the result is a broken URL like `/topics/{slug}?id=...` (see "Link Expressions:
Building URLs with @{...}").

**6. Assuming a `#{...}` key is defined in both languages (tr/en
`messages*.properties`).** A missing key silently shows up on the page as
something like `??key??` -- it isn't caught at build time, only when someone
actually visits that page in that language (see "Message Expressions: i18n with
#{...}").

## Summary, Cheat Sheet, and Glossary

Thymeleaf is Spring MVC's default view technology -- its "natural templating"
philosophy lets a template be both valid HTML and a processable file at the same
time. Key points:

- `Model`/`ModelMap`/`ModelAndView`: three equivalent ways to carry data from a
  controller to a view
- `${...}`: variable expression, reads data from the `Model` (parenthesized
  access on records: `topic.title()`)
- `@{...}`: link expression, automatically combines the context path with path
  variables and query parameters
- `#{...}`: message expression, returns text resolved from an i18n bundle (in
  this project, through Spring's `MessageSource`)
- `th:text` / `th:utext`: escaped and unescaped text output, respectively
- `th:if` / `th:unless`: conditional blocks that remove the tag from rendering
  entirely
- `th:each`: walks a collection and repeats the tag for every element;
  `iterStat` gives access to index/count/first/last
- `th:fragment` / `th:insert` / `th:replace`: defining and pulling in a reusable
  chunk of markup (`th:replace` takes the host tag's place)
- `.?[...]`: selection (filtering) expression; `#this` inside it is bound to
  each element, outer variables are reached with `#vars.`
- `th:object` / `th:field`: bind form fields to a Java object (not yet used in
  this project)

Quick reference:

```html
<!-- variable + link + message -->
<a th:href="@{/topics/{slug}(slug=${topic.slug()})}" th:text="${topic.title()}">Topic</a>
<span th:text="#{time.minutesShort}">min</span>

<!-- conditional + loop -->
<div th:if="${!items.isEmpty()}">
    <p th:each="item, stat : ${items}" th:text="${stat.count} + '. ' + ${item.name()}">row</p>
</div>
<div th:unless="${!items.isEmpty()}">Empty.</div>

<!-- fragment definition and call -->
<div th:fragment="card(title)" class="card" th:text="${title}">card</div>
<div th:replace="~{::card(${topic.title()})}">placeholder</div>

<!-- safe vs. trusted content -->
<p th:text="${userComment}">from a user -- escaped</p>
<article th:utext="${serverRenderedMarkdown}">server-generated -- unescaped</article>
```

**Glossary**

**Thymeleaf** — The Java template engine Spring Boot auto-configures by default,
built around the "natural templating" philosophy.

**Natural templating** — Thymeleaf's design principle that a template should
look valid and meaningful in a browser or design tool even before it's
processed.

**Variable expression (`${...}`)** — A Thymeleaf expression that reads a value
from the model/context.

**Link expression (`@{...}`)** — A Thymeleaf expression that builds a URL by
combining the context path with path variables and query parameters.

**Message expression (`#{...}`)** — A Thymeleaf expression that resolves an
i18n key into text for the current locale.

**`th:text` / `th:utext`** — Attributes that write a tag's text content escaped
and unescaped, respectively.

**Fragment** — A reusable chunk of template defined with `th:fragment` and
pulled in elsewhere with `th:insert`/`th:replace`.

**Selection expression (`.?[...]`)** — An expression that filters a collection
based on a condition where `#this` is bound to the current element.

**`#vars`** — A Thymeleaf basic object that reaches straight into the top-level
context variables from inside scope-changing expressions like selections and
projections.

**`th:object` / `th:field`** — Thymeleaf's form dialect attributes that bind a
form field to a field on a Java object arriving via `@ModelAttribute`.

## Appendix: Mini Project — A Simple Blog Page

Building a small page that brings this lesson's mechanisms together: a
`th:fragment` (a single post card), `th:each` (the list of posts), and
`th:if`/`th:unless` (the empty-list state), all in one template:

{{BlogPageTemplateExample.java}}

{{BlogPageDemo.java}}

The `postCard` fragment only knows about one post -- a title and an excerpt. The
`th:unless="${#lists.isEmpty(posts)}"` block kicks in when there's at least one
post and uses `th:each` to `th:insert` `postCard` for each one; when the list is
empty, `th:if="${#lists.isEmpty(posts)}"` shows "No posts yet." on its own.
`BlogPageDemo` calls the same `render` method first with a populated list, then
with an empty one, to show both branches working correctly.

## Appendix: Mini Project — An i18n Product Card Template

The second mini project brings `${...}`, `@{...}`, and `th:if` together, using
the same approach as "Message Expressions: i18n with #{...}" (resolving the
message first, then feeding an already-resolved string into the template):

{{ProductCardTemplateExample.java}}

{{ProductCardDemo.java}}

`ProductCardTemplateExample` renders a product's name (`${product.name()}`), a
link to its product page (`@{/products/{slug}(slug=${product.slug()})}`), and a
badge that only shows up when it's discounted
(`th:if="${product.discounted()}"`). `ProductCardDemo` resolves the "Add to
Cart"/"Sepete Ekle" label per language ahead of time and runs the same template
in both languages, for both a discounted and a regular-priced product -- in a
real Thymeleaf setup that last step would collapse into `#{addToCart}` in one
line, but keeping it separate lets the template itself be tested independently
of the message-resolution infrastructure.
