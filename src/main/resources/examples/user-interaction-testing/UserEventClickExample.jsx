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
    // userEvent.setup(), gerçek bir kullanıcının tıklamasına fireEvent'ten
    // daha yakın davranan bir "kullanıcı" nesnesi oluşturur (hover, focus gibi
    // ara adımları da simüle eder). Bu yüzden RTL artık userEvent'i ÖNERİYOR.
    const user = userEvent.setup();
    render(<Counter />);

    expect(screen.getByText("Count: 0")).toBeInTheDocument();

    // userEvent'in metotları ASENKRON'dur -- her zaman await edilmeli.
    await user.click(screen.getByRole("button", { name: /increment/i }));

    expect(screen.getByText("Count: 1")).toBeInTheDocument();
  });
});
