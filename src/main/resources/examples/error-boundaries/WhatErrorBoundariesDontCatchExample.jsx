import { Component, useState } from "react";

class ErrorBoundary extends Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  render() {
    if (this.state.hasError) {
      return <p>Something went wrong.</p>;
    }

    return this.props.children;
  }
}

function EventHandlerExample() {
  function handleClick() {
    // Error boundaries only catch errors during RENDER -- an error thrown
    // INSIDE an event handler (like an onClick) is NOT CAUGHT by an error
    // boundary. A regular try/catch is needed for that.
    try {
      throw new Error("Button click failed!");
    } catch (error) {
      console.error("Caught manually:", error.message);
    }
  }

  return <button onClick={handleClick}>Click me</button>;
}

function WhatErrorBoundariesDontCatchExample() {
  const [showInfo, setShowInfo] = useState(false);

  return (
    <div>
      {/* The ErrorBoundary here wraps EventHandlerExample -- but the onClick
          error inside it will still NOT BE CAUGHT, because it happens in
          an event handler, not during render. */}
      <ErrorBoundary>
        <EventHandlerExample />
      </ErrorBoundary>
      <button onClick={() => setShowInfo(true)}>Show limitations</button>
      {showInfo && (
        <p>
          Error boundaries do NOT catch: event handler errors, errors in
          asynchronous code (setTimeout, fetch callbacks), errors during
          server-side rendering, or errors thrown in the boundary itself.
        </p>
      )}
    </div>
  );
}
