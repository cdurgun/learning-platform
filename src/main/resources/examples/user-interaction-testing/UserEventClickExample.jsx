import { useState } from "react";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect } from "vitest";

function Counter() {
  const [count, setCount] = useState(0);
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}

describe("Counter interaction", () => {
  it("increments the count when the button is clicked", async () => {
    // userEvent.setup() creates a "user" object that behaves closer to a
    // real user's click than fireEvent (it also simulates intermediate steps
    // like hover and focus). That's why RTL now RECOMMENDS userEvent.
    const user = userEvent.setup();
    render(<Counter />);

    expect(screen.getByText("Count: 0")).toBeInTheDocument();

    // userEvent's methods are ASYNCHRONOUS -- they must always be awaited.
    await user.click(screen.getByRole("button", { name: /increment/i }));

    expect(screen.getByText("Count: 1")).toBeInTheDocument();
  });
});
