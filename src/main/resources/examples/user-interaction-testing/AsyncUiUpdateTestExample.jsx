import { useEffect, useState } from "react";
import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";

// Hooks dersindeki useEffect deseni -- component mount olduktan bir süre
// sonra kendi state'ini güncelliyor (gerçek bir uygulamada bu, bir fetch
// isteğinin tamamlanması olurdu; burada basit tutmak için setTimeout).
function DelayedGreeting() {
  const [ready, setReady] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => setReady(true), 50);
    return () => clearTimeout(timer);
  }, []);

  if (!ready) return <p>Loading...</p>;
  return <p>Welcome!</p>;
}

describe("DelayedGreeting async update", () => {
  it("shows loading first, then the greeting once ready", async () => {
    render(<DelayedGreeting />);

    // İlk render'da hâlâ "Loading..." görünüyor.
    expect(screen.getByText("Loading...")).toBeInTheDocument();

    // findByText, getByText'in ASENKRON hâlidir: eleman hemen yoksa hata
    // fırlatmaz, belirli bir süre (varsayılan 1000ms) boyunca tekrar tekrar
    // dener. DOM'u zamanla değişen (fetch, timer, animasyon sonrası) her şeyi
    // test etmenin doğru yolu budur -- waitFor de aynı amaçla kullanılabilir.
    const greeting = await screen.findByText("Welcome!");
    expect(greeting).toBeInTheDocument();
  });
});
