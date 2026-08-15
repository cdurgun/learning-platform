import { useState } from "react";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect, vi } from "vitest";

function SignupForm({ onSubmitted }) {
  const [email, setEmail] = useState("");

  function handleSubmit(e) {
    e.preventDefault();
    onSubmitted(email);
  }

  return (
    <form onSubmit={handleSubmit}>
      <label htmlFor="email">Email</label>
      <input id="email" value={email} onChange={(e) => setEmail(e.target.value)} />
      <button type="submit">Sign Up</button>
    </form>
  );
}

describe("SignupForm submission", () => {
  it("calls onSubmitted with the typed email when the form is submitted", async () => {
    const user = userEvent.setup();

    // vi.fn(), gerçek bir prop yerine geçen SAHTE bir fonksiyondur -- hangi
    // argümanlarla, kaç kez çağrıldığını sonradan sorgulayabiliriz.
    const handleSubmitted = vi.fn();
    render(<SignupForm onSubmitted={handleSubmitted} />);

    await user.type(screen.getByLabelText("Email"), "ada@example.com");
    await user.click(screen.getByRole("button", { name: /sign up/i }));

    expect(handleSubmitted).toHaveBeenCalledWith("ada@example.com");
    expect(handleSubmitted).toHaveBeenCalledTimes(1);
  });
});
