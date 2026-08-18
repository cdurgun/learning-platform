import { Component } from "react";

class ComponentDidCatchExample extends Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  // getDerivedStateFromError is used to SHOW the fallback UI;
  // componentDidCatch is used to SEND the error somewhere (e.g. to a
  // logging service) -- the two can work together.
  componentDidCatch(error, errorInfo) {
    console.error("Caught an error:", error, errorInfo.componentStack);
  }

  render() {
    if (this.state.hasError) {
      return <p>Something went wrong.</p>;
    }

    return this.props.children;
  }
}
