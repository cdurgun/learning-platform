import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";

// Test edilecek component. Gerçek bir projede bu genelde ayrı bir dosyada
// (Counter.jsx) olur, testi de ayrı bir dosyada (Counter.test.jsx) yazılır --
// burada tek bir okunabilir örnek olması için ikisini birleştirdik.
function Counter() {
  return (
    <div>
      <p>Count: 0</p>
    </div>
  );
}

describe("Counter", () => {
  it("renders the initial count", () => {
    // render(), component'i gerçek bir DOM'a (jsdom, tarayıcı SİMÜLASYONU) yerleştirir.
    render(<Counter />);

    // screen, o anki DOM'u SORGULAMAK için kullanılır. getByText, tam olarak bu
    // metni içeren bir eleman bulamazsa testi ANINDA başarısız yapar.
    expect(screen.getByText("Count: 0")).toBeInTheDocument();
  });
});
