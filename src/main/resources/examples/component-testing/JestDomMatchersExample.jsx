import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";

function SubmitButton({ disabled }) {
  return <button disabled={disabled}>Submit</button>;
}

describe("SubmitButton", () => {
  it("is disabled when the disabled prop is true", () => {
    render(<SubmitButton disabled={true} />);

    // toBeDisabled/toBeEnabled/toBeInTheDocument, @testing-library/jest-dom'un
    // eklediği matcher'lardır -- düz Vitest'te yok, jsdom kullanan projelerde
    // ayrıca kurulur (setupFiles içinde "@testing-library/jest-dom/vitest").
    expect(screen.getByRole("button", { name: /submit/i })).toBeDisabled();
  });

  it("is enabled when the disabled prop is false", () => {
    render(<SubmitButton disabled={false} />);

    expect(screen.getByRole("button", { name: /submit/i })).toBeEnabled();
  });
});
