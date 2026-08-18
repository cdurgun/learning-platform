import { useState } from "react";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect } from "vitest";

function NameInput() {
  const [name, setName] = useState("");
  return (
    <div>
      <label htmlFor="name">Name</label>
      <input id="name" value={name} onChange={(e) => setName(e.target.value)} />
      <p>You typed: {name}</p>
    </div>
  );
}

describe("NameInput interaction", () => {
  it("updates the displayed text as the user types", async () => {
    const user = userEvent.setup();
    render(<NameInput />);

    const input = screen.getByLabelText("Name");

    // user.type types the given text CHARACTER BY CHARACTER -- each
    // keystroke triggers the onChange on the controlled component in a way
    // that closely resembles real typing.
    await user.type(input, "Ada");

    expect(screen.getByText("You typed: Ada")).toBeInTheDocument();
    expect(input).toHaveValue("Ada");
  });
});
