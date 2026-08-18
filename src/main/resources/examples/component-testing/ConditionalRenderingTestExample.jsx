import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";

// A tested version of the conditional rendering pattern from the State & Events lesson.
function StatusMessage({ status }) {
  if (status === "loading") return <p>Loading...</p>;
  if (status === "error") return <p>Something went wrong.</p>;
  return <p>Data loaded successfully.</p>;
}

describe("StatusMessage", () => {
  it("shows a loading message", () => {
    render(<StatusMessage status="loading" />);
    expect(screen.getByText("Loading...")).toBeInTheDocument();

    // Unlike getByText, queryByText does NOT THROW an error when it can't find
    // something -- it returns null. queryBy* is used to verify that something
    // is NOT ON THE SCREEN.
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
