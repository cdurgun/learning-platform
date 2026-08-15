import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";

// State & Events dersindeki koşullu render deseninin test edilmiş hali.
function StatusMessage({ status }) {
  if (status === "loading") return <p>Loading...</p>;
  if (status === "error") return <p>Something went wrong.</p>;
  return <p>Data loaded successfully.</p>;
}

describe("StatusMessage", () => {
  it("shows a loading message", () => {
    render(<StatusMessage status="loading" />);
    expect(screen.getByText("Loading...")).toBeInTheDocument();

    // queryByText, getByText'in aksine bulamazsa HATA FIRLATMAZ -- null döner.
    // Bir şeyin EKRANDA OLMADIĞINI doğrulamak için queryBy* kullanılır.
    expect(screen.queryByText("Data loaded successfully.")).not.toBeInTheDocument();
  });

  it("shows an error message", () => {
    render(<StatusMessage status="error" />);
    expect(screen.getByText("Something went wrong.")).toBeInTheDocument();
  });

  it("shows the success message by default", () => {
    render(<StatusMessage status="success" />);
    expect(screen.getByText("Data loaded successfully.")).toBeInTheDocument();
  });
});
