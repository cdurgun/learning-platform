# State

In Events, we learned how to catch a user's actions, but our handlers
only ever logged to `console.log` -- nothing changed on screen. This
lesson covers how to actually change the screen in React: **state**.

## What Is State?

State is data a component "remembers" that can change over time. When
state changes, React automatically re-renders that component -- it
redraws the screen to match the latest state. A counter, an input's
current value, whether a menu is open or closed -- all of these are
examples of state.

## Defining State with useState

You define state with the `useState` function:

{{UseStateBasicExample.jsx}}

`useState(0)` sets up state with an initial value of `0` and returns two
things: the current value (`count`) and a function to update it
(`setCount`). The `const [count, setCount] = ...` syntax is a
JavaScript feature (array destructuring) that splits these two values
into separate variables on one line -- similar to the object
destructuring we saw in Props, but for arrays.

## Updating State

You **can't** update state by writing `count = count + 1` directly --
you have to call the function `useState` gave you (`setCount`):

{{UpdatingStateExample.jsx}}

When `setCount(...)` is called, React does two things: it saves the new
value of the state, and it re-renders the component with that new
value. Directly assigning to a variable doesn't tell React "something
changed," so it doesn't update the screen -- we'll see this in State
vs. a Regular Variable.

## Updating Based on the Previous State

If calculating the new state needs the previous state, you should pass
`setCount` a FUNCTION instead of a direct value:

{{PreviousStateExample.jsx}}

Writing `setCount(count + 1)` isn't reliable if it's called more than
once within the same render -- the `count` variable stays fixed for
that entire render. Writing `setCount((prevCount) => prevCount + 1)`
tells React "whatever happens, calculate based on the MOST RECENT
value."

## State vs. a Regular Variable

Why not just use a regular variable with `let`? Because changing a
regular variable doesn't update the screen:

{{StateVsVariableExample.jsx}}

`plainCount` really does change (you can see it in the console), but
since React doesn't know about it, it doesn't re-render the component --
the screen keeps showing the same value. `useState` is special because
it tells React "let me know when this value changes."

## State Immutability

If state is an object or array, instead of directly changing (mutating)
it, you should always create a NEW object/array and pass that to the
setter function:

{{StateImmutabilityExample.jsx}}

Writing `user.age = user.age + 1` and passing back the same object
doesn't guarantee React notices the change -- React decides whether to
re-render partly by checking whether the state is "the same object or a
different one." The spread operator (`{ ...user, age: ... }`) copies all
the fields of the old object into a new one, changing only the field
you specify.

## Summary and Glossary

State is a component's data that can change over time and, when it
changes, automatically updates the screen. It's defined with `useState`
and can only be updated through its setter function -- direct
assignment doesn't work. When updating based on the previous state, use
the function form. Object/array state is never mutated directly -- a
new copy is always created.

**Glossary**

**State** — A component's data that can change over time and, when it
changes, triggers the component to re-render.

**`useState`** — The React function that lets you add state to a
component; it returns the current value and a function to update it.

**Re-render** — React re-running a component and updating the screen
when its state or props change.

**Immutability** — The principle of creating a new copy that includes
the change, instead of directly modifying an existing object/array.
