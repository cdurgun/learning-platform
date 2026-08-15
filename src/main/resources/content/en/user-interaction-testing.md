# User Interaction Testing

In Component Testing, we learned to test that a component renders
CORRECTLY -- but most React apps are "static" until a user clicks
something, types something, or submits a form. This lesson covers
testing user INTERACTIONS.

## Realistic Interaction Simulation with user-event

Alongside React Testing Library, `@testing-library/user-event` is
used to simulate user interactions:

```bash
npm install -D @testing-library/user-event
```

RTL's own `fireEvent` API can also trigger a click/type, but
`fireEvent` dispatches a single DOM event (like `click`) directly.
`user-event` simulates the IN-BETWEEN steps a real user triggers
while clicking/typing too (hover, focus, pointer events) -- which is
why RTL's official docs now RECOMMEND `user-event` over `fireEvent`.

## Testing a Click

Let's test the `Counter` component from State & Events again, this
time by simulating a real click:

{{UserEventClickExample.jsx}}

`userEvent.setup()` creates a "user" object. This object's methods
(`click`, `type`, etc.) are ALWAYS asynchronous and must be
`await`ed -- forget to, and the test moves to the next line before
the click finishes, checking a stale DOM state.

## Testing Typing

The controlled-input pattern from Forms is tested with `user.type`:

{{UserEventTypingExample.jsx}}

`user.type(input, "Ada")` types the given text CHARACTER BY
CHARACTER -- each keystroke triggers the controlled component's
`onChange` much like typing on a real keyboard would. At the end of
the test, we check both the displayed text (`getByText`) and the
input's own value (`toHaveValue`).

## Testing Form Submission

Filling out and submitting a form is the most common scenario where
`user.type` and `user.click` are used together:

{{FormSubmissionTestExample.jsx}}

`vi.fn()` creates a FAKE function that stands in for a real prop --
without any real request leaving the component, we can verify what
ARGUMENTS this function was called with and how MANY times.
`toHaveBeenCalledWith(...)` and `toHaveBeenCalledTimes(...)` are
matchers specific to these mock functions.

## Testing Asynchronous UI Updates

With the `useEffect` pattern from Hooks, a component can update
ITSELF over time (like a fetch request finishing). Testing that kind
of update calls for the `findBy*` queries:

{{AsyncUiUpdateTestExample.jsx}}

`getByText` (and `queryByText`) check the DOM ONLY AT THAT MOMENT --
if the element isn't there yet, the test fails. `findByText` is
ASYNCHRONOUS instead: it doesn't throw if the element isn't there
immediately, it retries for a set amount of time (1000ms by default)
and continues once the element appears. This is the correct way to
test anything that changes the DOM over time (fetch, timers,
post-animation state); `waitFor(...)` can be used for the same
purpose.

## Summary and Glossary

`@testing-library/user-event` offers a MORE REALISTIC interaction
simulation than `fireEvent`; the `click`/`type` methods on the object
returned by `userEvent.setup()` must always be `await`ed. Mock
functions created with `vi.fn()` are used to verify that a callback
prop was called with the right arguments. Asynchronous DOM updates
(that change over time) are tested with `findByText`/`waitFor`
instead of `getByText`.

**Glossary**

**user-event** — A library that simulates user interactions
(clicking, typing) closer to real browser behavior.

**Mock Function** — A fake function created with `vi.fn()` that
stands in for a real function and records how it was called
(arguments, call count).

**Async Query** — A query type, like `findBy*`, that WAITS for an
element to appear in the DOM.

## Practical Project

There's a real, runnable example project combining the concepts from
this category (Component Testing, User Interaction Testing):
**[Testing Demo](https://github.com/cdurgun/react-course-projects/tree/main/projects/testing)**
-- a searchable course list and a signup form familiar from earlier
categories, but this time the focus is less on the app itself and
more on the real Vitest tests that verify it.

The project tests `SearchBar`, `CourseList`, and `EnrollForm` each in
their own `.test.jsx` file (`getByLabelText`+`userEvent.type`,
filtering with `getByText`/`queryByText`, form submission with
`vi.fn()`+`findByText`), and verifies the whole thing -- wired
together in `App` with lifting state up -- with a single integration
test (`App.test.jsx`). You can download it and run it yourself, and
read through the tests line by line:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/testing
npm test
```

The `react-course-projects` repo uses **npm workspaces** -- `npm install`
only needs to run once, at the repo root, and every project folder shares
the same dependencies (no separate `node_modules` per folder). If you've
already run `npm install` at the root, just `cd react-course-projects/projects/testing`
and run `npm test`.
