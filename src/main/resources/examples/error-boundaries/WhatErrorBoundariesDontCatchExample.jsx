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
    // Error boundary'ler yalnızca RENDER sırasındaki hataları yakalar --
    // bir event handler İÇİNDE (bir onClick gibi) fırlatılan bir hata,
    // error boundary tarafından YAKALANMAZ. Bunun için normal try/catch
    // kullanmak gerekir.
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
      {/* ErrorBoundary burada EventHandlerExample'ı sarmalıyor -- ama
          içindeki onClick hatası yine de YAKALANMAYACAK, çünkü o bir
          event handler'da oluyor, render sırasında değil. */}
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
