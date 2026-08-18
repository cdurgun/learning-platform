import { useEffect, useState } from "react";
import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";

// The useEffect pattern from the Hooks lesson -- the component updates its
// own state a while after mounting (in a real app this would be a fetch
// request completing; here we use setTimeout to keep it simple).
function DelayedGreeting() {
  const [ready, setReady] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => setReady(true), 50);
    return () => clearTimeout(timer);
  }, []);

  if (!ready) return <p>Loading...</p>;
  return <p>Welcome!</p>;
}

describe("DelayedGreeting async update", () => {
  it("shows loading first, then the greeting once ready", async () => {
    render(<DelayedGreeting />);

    // On the first render, "Loading..." is still shown.
    expect(screen.getByText("Loading...")).toBeInTheDocument();

    // findByText is the ASYNC version of getByText: if the element isn't
    // there right away, it doesn't throw immediately -- it keeps retrying
    // for a given period (1000ms by default). This is the right way to test
    // anything in the DOM that changes over time (fetch, timers, after an
    // animation) -- waitFor can be used for the same purpose.
    const greeting = await screen.findByText("Welcome!");
    expect(greeting).toBeInTheDocument();
  });
});
