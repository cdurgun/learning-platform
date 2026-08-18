import { Component } from "react";

// IMPORTANT: Error boundaries are the FIRST class component we've seen in
// this course. There is NO way to write error boundaries with hooks
// (function components) in React -- only class components can do this,
// via `static getDerivedStateFromError`. That's why, for this ONE topic,
// we use a class component as an exception.
class BasicErrorBoundaryExample extends Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  // WHEN a child component THROWS an error during render, React calls
  // this method -- the value it returns becomes the new state.
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
