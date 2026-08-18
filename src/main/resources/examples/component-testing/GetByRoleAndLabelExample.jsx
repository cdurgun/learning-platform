import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";

function LoginButton() {
  return <button>Log In</button>;
}

function NameField() {
  return (
    <div>
      <label htmlFor="name">Name</label>
      <input id="name" defaultValue="Ada" />
    </div>
  );
}

describe("Querying elements", () => {
  it("finds a button by its accessible role and name", () => {
    render(<LoginButton />);

    // getByRole finds elements by their ACCESSIBILITY role, not by their
    // VISIBLE text -- a <button> has the "button" role. This is the query
    // style that most closely matches how real users (and screen readers)
    // perceive the page.
    expect(screen.getByRole("button", { name: /log in/i })).toBeInTheDocument();
  });

  it("finds a form field by its connected label", () => {
    render(<NameField />);

    // getByLabelText finds the input that matches a <label htmlFor="...">
    // -- there's no need to add the input's id or a test-id.
    expect(screen.getByLabelText("Name")).toHaveValue("Ada");
  });
});
