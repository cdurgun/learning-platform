# Error Boundaries

In this lesson, we'll see our FIRST **class component** in the course.
There's no way to write error boundaries with hooks in React -- they
can only be written using class components. Everything you've learned
so far (hooks, state, props) applied to function components; this is
an exceptional, narrowly-scoped topic.

## Writing a Basic Error Boundary

When a component throws an error during rendering, React normally
unmounts the ENTIRE application (showing a blank screen). An error
boundary prevents this:

{{BasicErrorBoundaryExample.jsx}}

`static getDerivedStateFromError()` is called by React when a child
throws an error -- whatever it returns becomes the new state. The
`render()` method shows either the normal `children` or a fallback
message, based on the `hasError` state.

## Logging the Error with componentDidCatch

`getDerivedStateFromError` is ONLY for showing the fallback UI --
sending the error somewhere (logging it) requires a separate method:

{{ComponentDidCatchExample.jsx}}

`componentDidCatch(error, errorInfo)` receives the error itself AND
`errorInfo.componentStack` (a "stack trace" showing which component the
error came from) -- in real applications, this is usually where a
request is sent to an error-tracking service (like Sentry).

## Using an Error Boundary

We use an error boundary to wrap components that might throw:

{{UsingErrorBoundaryExample.jsx}}

`BuggyCounter` deliberately throws an error when `count === 3` --
`ErrorBoundary` catches it and replaces the normal render with a
fallback UI. `BuggyCounter` itself doesn't need to handle the error --
that's the error boundary's job.

## The Scope of Error Boundaries

Using multiple, SMALL error boundaries is usually better than one big
one:

{{ErrorBoundaryScopeExample.jsx}}

Two separate `ErrorBoundary`s wrap two separate sections -- if one
crashes, the other is NOT affected. If we used a single large boundary,
any error could turn the ENTIRE page into a fallback message.

## What Error Boundaries Don't Catch

Error boundaries have a limit -- they don't catch every kind of error:

{{WhatErrorBoundariesDontCatchExample.jsx}}

Error boundaries only catch errors thrown during RENDERING -- they do
NOT catch errors in event handlers (like `onClick`), asynchronous code
(`setTimeout`, fetch callbacks), server-side rendering, or errors
thrown in the boundary itself. Regular `try`/`catch` is used for
errors in event handlers.

## Summary and Glossary

An error boundary is a class component that defines
`static getDerivedStateFromError` (to show a fallback UI) and
optionally `componentDidCatch` (to log the error) -- React has no hook
equivalent for this. An error boundary catches errors thrown during
rendering by any component INSIDE it and replaces the normal render
with a fallback UI. Using multiple small boundaries prevents an error
in one section from affecting others. Error boundaries do NOT catch
errors in event handlers, asynchronous code, or the boundary itself.

**Glossary**

**Error Boundary** — A class component that catches errors thrown
during rendering by the components inside it and shows a fallback UI.

**Fallback UI** — Alternative UI shown in place of normal content
during an error (or a loading state).
