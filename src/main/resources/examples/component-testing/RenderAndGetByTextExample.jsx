import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";

// The component under test. In a real project this usually lives in its own
// file (Counter.jsx), with the test written in a separate file
// (Counter.test.jsx) -- here we've combined the two into a single readable example.
function Counter() {
  return (
    <div>
      <p>Count: 0</p>
    </div>
  );
}

describe("Counter", () => {
  it("renders the initial count", () => {
    // render() places the component into a real DOM (jsdom, a SIMULATED browser).
    render(<Counter />);

    // screen is used to QUERY the current DOM. If getByText can't find an
    // element containing exactly this text, it fails the test IMMEDIATELY.
    expect(screen.getByText("Count: 0")).toBeInTheDocument();
  });
});
