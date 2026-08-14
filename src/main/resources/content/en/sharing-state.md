# Sharing State

So far, we've always used `useState` inside a SINGLE component. This
lesson covers situations where more than one component needs the same
state -- and the "props drilling" problem that comes along with it.

## When Two Components Need the Same State

Picture a search box (`SearchBox`) and a results list (`ResultsList`)
-- both need the SAME search text. What happens if the `query` state
lives inside `SearchBox`?

{{SeparateStateProblemExample.jsx}}

`ResultsList` has no way to access `SearchBox`'s state -- each
component's own state is trapped INSIDE it; sibling components can't
see each other's state DIRECTLY.

## Lifting State Up

The fix is to move the state to a place that's the COMMON ancestor of
both components:

{{LiftingStateUpExample.jsx}}

The `query` state now lives in the shared parent; both children receive
it via props -- `SearchBox` gets `query` and `onQueryChange`,
`ResultsList` gets just `query`. This pattern is called **lifting state
up** -- it's the most fundamental way to manage shared state in React.

## Seeing the Same Pattern in a Different Scenario

Lifting state up isn't limited to filtering a list -- it also applies
to components that show the SAME value in TWO DIFFERENT ways:

{{SyncedSiblingsExample.jsx}}

A slider and a text display share the SAME `rating` value -- since the
state lives in the shared parent, when one changes, the other stays
instantly in sync.

## Props Drilling: Passing Through Intermediate Layers

As the component tree gets deeper, DELIVERING a prop to the component
that needs it may require the components in between to also accept
that prop:

{{PropsDrillingExample.jsx}}

`ResultsPanel` never uses `query` ITSELF -- it only accepts it to pass
along to `ResultsList`. This is called **props drilling** -- being
forced to pass a prop through intermediate layers that don't use it.

## Why Props Drilling Hurts

This problem grows as the tree gets deeper:

{{WhyPropsDrillingHurtsExample.jsx}}

NONE of `Level1`, `Level2`, `Level3` use `user` -- they just pass it
along. Only `Level4`, at the very bottom, actually uses it. Every new
level, or every new shared value, stretches this chain further --
making the code tedious to write and fragile to change. In the next
lesson (Context API), we'll see a way to solve this.

## Summary and Glossary

When more than one component needs the same state, it needs to be
moved to their COMMON ancestor (lifting state up) -- each child
receives it via props. As the tree gets deeper, being forced to pass a
prop through intermediate components that don't use it creates the
"props drilling" problem -- making code tedious to write and fragile
to change.

**Glossary**

**Lifting State Up** — Moving state shared by multiple components to
their COMMON ancestor.

**Props Drilling** — Being forced to pass a prop through intermediate
layer components that don't use it.
