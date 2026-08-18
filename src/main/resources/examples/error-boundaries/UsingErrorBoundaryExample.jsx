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

function BuggyCounter({ count }) {
  if (count === 3) {
    // We deliberately throw an error during render -- in a real app this
    // would be an unexpected error, like `undefined.someProperty`.
    throw new Error("Count reached 3!");
  }

  return <p>Count: {count}</p>;
}

function UsingErrorBoundaryExample() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      {/* If any component INSIDE it throws an error during render, the
          ErrorBoundary CATCHES that error and REPLACES the normal render
          with the fallback UI -- BuggyCounter itself doesn't have to
          handle the error. */}
      <ErrorBoundary>
        <BuggyCounter count={count} />
      </ErrorBoundary>
    </div>
  );
}
