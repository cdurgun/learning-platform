import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";

function SubmitButton({ disabled }) {
  return <button disabled={disabled}>Submit</button>;
}

describe("SubmitButton", () => {
  it("is disabled when the disabled prop is true", () => {
    render(<SubmitButton disabled={true} />);

    // toBeDisabled/toBeEnabled/toBeInTheDocument are matchers added by
    // @testing-library/jest-dom -- they're not in plain Vitest, and are
    // installed separately in projects that use jsdom (via
    // "@testing-library/jest-dom/vitest" in setupFiles).
    expect(screen.getByRole("button", { name: /submit/i })).toBeDisabled();
  });

  it("is enabled when the disabled prop is false", () => {
    render(<SubmitButton disabled={false} />);

    expect(screen.getByRole("button", { name: /submit/i })).toBeEnabled();
  });
});
