# Lazy Loading & Code Splitting

Every component we've written so far has been part of the application's
FIRST loaded JavaScript bundle. As an application grows, so does this
bundle -- users may end up downloading code for pages they'll never
even visit. This lesson covers how to avoid that.

## Loading a Component Later with React.lazy

`lazy()` turns a component's code into a SEPARATE file that's
downloaded when needed, instead of a regular `import`:

{{ReactLazyBasicExample.jsx}}

`lazy(() => import("./CourseDetails.jsx"))` REMOVES `CourseDetails`'s
code from the app's initial bundle -- it's only downloaded once
`showDetails` becomes `true`. `Suspense` is required to show a
`fallback` during this download (we'll take a closer look at Suspense
in the next lesson).

## Route-Based Code Splitting

The most common use of `lazy()` is splitting the pages from the
Routing lesson into separate bundles:

{{RouteBasedCodeSplittingExample.jsx}}

Each page (`CoursesPage`, `AboutPage`) is its own separate file -- if a
user never visits `/about`, that page's code is never downloaded. This
pattern is called **code splitting**: breaking an application into
multiple small pieces instead of one giant bundle.

## Using lazy with Named Exports

`lazy()` expects `import()` to resolve to a DEFAULT export -- a
component with a named export needs a small adaptation:

{{NamedExportLazyExample.jsx}}

`.then((module) => ({ default: module.CourseChart }))` CONVERTS the
named export (`CourseChart`) into the `{ default: ... }` shape that
`lazy` expects.

## Conditional Lazy Loading

`lazy()` is useful not just for pages, but for ANY rarely-used
component:

{{ConditionalLazyLoadExample.jsx}}

`EmojiPicker`'s code is never downloaded until the user makes
`showPicker` `true` for the FIRST time -- most users may never use it,
in which case we never download its code at all.

## Summary and Glossary

`lazy()` splits a component's code into a separate file (chunk),
downloading it only when it's actually needed -- this REDUCES the
amount of JavaScript loaded initially. Its most common uses are
splitting pages (routes) or rarely-used components (modals, emoji
pickers). `lazy()` is always used together with `Suspense` -- a
fallback is needed while the code downloads.

**Glossary**

**Code Splitting** — The technique of breaking an application's
JavaScript into small pieces that are downloaded as needed, instead of
one large bundle.

**Bundle** — An application's JavaScript files combined together to be
sent to the browser.

**Chunk** — A small, separately downloadable JavaScript file produced
by code splitting.
