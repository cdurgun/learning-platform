# Suspense

In Lazy Loading, we only saw `Suspense` paired with `lazy()`. This
lesson takes a closer look at `Suspense` itself -- what it does, how it
can be nested, and what it does NOT do automatically.

## The fallback Prop

`Suspense` shows a `fallback` while something INSIDE it isn't ready
yet:

{{SuspenseFallbackExample.jsx}}

`fallback` can be ANY JSX, not just text -- a spinner, a skeleton
screen, or another component. Once the component inside (here,
`CourseDetails`) is ready, `fallback` is automatically REPLACED with
the real content.

## Nested Suspense Boundaries

Multiple `Suspense` boundaries can be nested at different levels:

{{NestedSuspenseExample.jsx}}

The outer `Suspense` shows a fallback for the WHOLE page until
`CourseHeader` loads. Once `CourseHeader` appears, the INNER `Suspense`
only covers `CourseReviews` -- the rest of the page does NOT go back to
a "loading" state. This gives users a smoother experience: instead of
everything disappearing and reappearing at once, only the part that's
still waiting shows "loading."

## Suspense with the use() Hook

The `use()` hook in React 19 can integrate a Promise DIRECTLY with
Suspense:

{{UsePromiseWithSuspenseExample.jsx}}

Unlike other hooks, `use()` can also be called CONDITIONALLY. Given a
Promise, if it hasn't RESOLVED yet, it tells React "I need to wait" --
this shows the nearest `Suspense`'s `fallback`; once the Promise
resolves, `use()` returns the actual value and the component renders
normally.

## What Suspense Doesn't Do Automatically

An important gotcha: not every asynchronous operation triggers
Suspense automatically:

{{SuspenseLimitationsExample.jsx}}

The `useEffect` + `fetch` pattern from API & Data Fetching does NOT
automatically trigger Suspense -- Suspense only works with a Promise
source that React DIRECTLY recognizes, like `use()`. A component using
`fetch` inside `useEffect` still needs to manage its own `loading`
state ITSELF.

## Summary and Glossary

`Suspense` shows a `fallback` while something inside it isn't ready
yet; once the content is ready, it's automatically replaced. Multiple
`Suspense` boundaries can be nested to show loading states at
different granularities. The `use()` hook in React 19 integrates a
Promise with Suspense. But "classic" data-fetching patterns like
`useEffect` + `fetch` do NOT automatically trigger Suspense -- only
sources React directly supports, like `use()`, do.

**Glossary**

**Suspense** — A React component that shows a fallback UI while a
resource inside it (a lazy component, a Promise) isn't ready yet.

**Suspense Boundary** — The area covered by a `<Suspense>` component,
with its own fallback.
