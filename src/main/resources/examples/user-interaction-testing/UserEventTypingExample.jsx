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

    // user.type, verilen metni HARF HARF yazar -- her tuş vuruşu, controlled
    // component'teki onChange'i gerçek yazmaya çok benzer şekilde tetikler.
    await user.type(input, "Ada");

    expect(screen.getByText("You typed: Ada")).toBeInTheDocument();
    expect(input).toHaveValue("Ada");
  });
});
