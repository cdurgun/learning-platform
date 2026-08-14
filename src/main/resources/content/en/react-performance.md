# React Performance

This category is our introduction to React's "advanced" topics -- now
that you know the fundamentals (state, hooks, forms, routing, fetching
data, sharing state), we can focus on using them MORE EFFICIENTLY.
First stop: preventing unnecessary re-renders.

## Unnecessary Re-renders

When a parent component re-renders, React by default re-renders ALL of
its children too -- even if the child's props haven't changed:

{{UnnecessaryRerenderExample.jsx}}

Every time `count` increases, `ExpensiveList` re-renders even though
`items` NEVER changed. This isn't a problem for small components, but
in large lists or complex calculations it can cause noticeable
slowdowns.

## Skipping Unnecessary Renders with React.memo

`memo()` wraps a component so it will NOT re-render unless its props
change:

{{ReactMemoExample.jsx}}

Before re-rendering a `memo`-wrapped component, React COMPARES the new
props with the props from the last render (a shallow comparison); if
they're the same, it skips the render.

## memo + useCallback: Function Props

`memo` alone isn't enough -- you need to be careful with function
props:

{{ReactMemoWithCallbackExample.jsx}}

WITHOUT the `useCallback` we saw in the Hooks lesson, a NEW function is
created on every render -- since functions are values too, `memo`
treats this as "the props changed" and re-renders anyway. `useCallback`
keeps the SAME function reference as long as its dependencies haven't
changed.

## Caching Expensive Calculations with useMemo

Let's revisit the `useMemo` we saw in Hooks, this time directly in a
performance context:

{{UseMemoForExpensiveCalculationExample.jsx}}

`sortAlphabetically` only runs when `courses` CHANGES -- the component
re-rendering for some other reason (like `count` changing) does NOT
re-trigger this expensive operation.

## React DevTools Profiler and \<Profiler\>

To MEASURE how long a component takes to render, React's own
`<Profiler>` component can be used:

{{ProfilerComponentExample.jsx}}

The `onRender` callback is called every time the wrapped tree renders,
giving you the render duration in milliseconds. This is the same
mechanism behind the "Profiler" tab in the React DevTools browser
extension -- in real applications it's usually added TEMPORARILY while
investigating a performance issue, not left in as permanent code.

## Summary and Glossary

When a parent re-renders, React by default renders all of its children
too; `memo()` lets you skip this as long as props haven't changed --
but it needs to be paired with `useCallback` for function props.
`useMemo` caches the result of an expensive calculation as long as its
dependencies haven't changed. React's `<Profiler>` component or React
DevTools can be used to measure a component's render time.

**Glossary**

**Re-render** — A component being rendered again as a result of a
state or props change.

**Memoization** — Storing the result of a calculation or component
render and reusing that stored result instead of recomputing it, as
long as the inputs haven't changed.
