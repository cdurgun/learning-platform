import { Component } from "react";

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
      return <p>{this.props.fallbackText}</p>;
    }

    return this.props.children;
  }
}

function BuggyWidget() {
  throw new Error("This widget is broken!");
}

function ErrorBoundaryScopeExample() {
  return (
    <div>
      {/* Two SEPARATE ErrorBoundaries wrap two SEPARATE sections -- even if
          the Sidebar crashes, the MainContent is NOT AFFECTED, the crash
          stays CONTAINED within its own ErrorBoundary. If we used a single
          large ErrorBoundary, any error could turn the ENTIRE page into a
          "Something went wrong" message. */}
      <ErrorBoundary fallbackText="Sidebar failed to load.">
        <BuggyWidget />
      </ErrorBoundary>
      <ErrorBoundary fallbackText="Main content failed to load.">
        <p>Main content (still works fine)</p>
      </ErrorBoundary>
    </div>
  );
}
