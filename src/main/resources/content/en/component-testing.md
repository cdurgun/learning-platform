# Component Testing

So far we've checked every component by clicking around in the
browser by hand. That's fine for a handful of components, but as an
app grows, manually re-checking every screen after every change is
slow and unreliable. This lesson teaches you to verify that
components work correctly AUTOMATICALLY, with code.

## Setting Up Vitest and React Testing Library

We use two libraries in this course:

- **Vitest** — the tool that RUNS tests (it provides functions like
  `describe`, `it`, `expect`). Since it's built for Vite projects, it
  needs almost no extra configuration.
- **React Testing Library (RTL)** — the library that lets you MOUNT a
  component into a fake DOM (jsdom) and then QUERY that DOM the way a
  real user would see it.

To add them to a Vite project:

```bash
npm install -D vitest @testing-library/react @testing-library/jest-dom jsdom
```

Add a `test` block to `vite.config.js`:

```js
export default defineConfig({
  plugins: [react()],
  test: {
    environment: "jsdom",
    setupFiles: ["./src/setupTests.js"],
    globals: true,
  },
});
```

`environment: "jsdom"` makes tests run against a fake DOM inside
Node instead of a real browser. The setup file only needs one line:

```js
import "@testing-library/jest-dom/vitest";
```

This line ADDS extra assertions (like the `toBeInTheDocument()`
we'll see shortly) to Vitest's `expect`.

## Our First Test with render() and screen

The most basic test skeleton mounts a component into the fake DOM
and checks that something we expect is there:

{{RenderAndGetByTextExample.jsx}}

`describe` groups related tests together; `it` (or `test`) defines a
single test case. `render(<Counter />)` mounts the component into
jsdom. `screen` is used to QUERY that DOM -- `getByText` immediately
fails the test if it can't find an element containing the given
text.

## Querying with getByRole and getByLabelText

`getByText` isn't always the best query -- RTL offers queries that
are closer to how a real user (or a screen reader) PERCEIVES the
page:

{{GetByRoleAndLabelExample.jsx}}

`getByRole("button", { name: /log in/i })` finds a `<button>` by its
accessibility role and visible name -- RTL's official docs recommend
`getByRole` as the PREFERRED query whenever possible.
`getByLabelText("Name")` finds the input connected to
`<label htmlFor="name">`, with no need to add an id or a test-id.

## jest-dom Matchers

The `@testing-library/jest-dom/vitest` import we added during setup
adds new DOM-specific assertions to `expect`:

{{JestDomMatchersExample.jsx}}

`toBeDisabled()` and `toBeEnabled()` check an element's `disabled`
attribute; `toBeInTheDocument()` verifies whether an element exists
in the DOM at all. None of these exist in plain Vitest -- they're
matchers added by the jest-dom package specifically for testing the
DOM.

## Testing Conditional Rendering

The conditional-rendering pattern from State & Events is one of the
most commonly tested scenarios -- we verify that each state shows the
CORRECT text:

{{ConditionalRenderingTestExample.jsx}}

Three separate `it` blocks render the component with three different
values of the `status` prop and check that the right message shows
up each time. The first test also uses `queryByText`: unlike
`getByText`, it does NOT throw if the element isn't found -- it
returns `null` -- which is why `queryBy*` (not `getByText`) is used
to assert that something is ABSENT from the screen.

## Summary and Glossary

Vitest RUNS tests; React Testing Library lets you mount components
into a fake DOM and QUERY them. `render()` mounts a component into
the DOM; `screen` is used to query that DOM. `getByRole` /
`getByLabelText` / `getByText` throw if they can't find an element;
the `queryBy*` variants return `null` instead and are used to assert
that something is ABSENT. `@testing-library/jest-dom` adds
DOM-specific matchers like `toBeInTheDocument()`.

**Glossary**

**Test Runner** — The tool that discovers and runs tests and reports
the results (Vitest).

**jsdom** — A fake DOM environment that runs inside Node and
SIMULATES a real browser.

**Matcher** — A function chained after `expect(...)` that verifies a
specific condition (`toBeInTheDocument()`, `toHaveValue()`, etc.).
