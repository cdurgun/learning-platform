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

    // getByRole, elemanları GÖRÜNEN metinden değil, ERİŞİLEBİLİRLİK rolünden
    // bulur -- bir <button>, "button" rolüne sahiptir. Bu, gerçek kullanıcıların
    // (ve ekran okuyucuların) sayfayı nasıl algıladığına en yakın sorgu şeklidir.
    expect(screen.getByRole("button", { name: /log in/i })).toBeInTheDocument();
  });

  it("finds a form field by its connected label", () => {
    render(<NameField />);

    // getByLabelText, <label htmlFor="..."> ile eşleşen input'u bulur --
    // input'un id'sini veya bir test-id eklemeye gerek kalmaz.
    expect(screen.getByLabelText("Name")).toHaveValue("Ada");
  });
});
