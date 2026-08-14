import { Component } from "react";

class ComponentDidCatchExample extends Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  // getDerivedStateFromError, fallback UI'ı GÖSTERMEK için kullanılır;
  // componentDidCatch ise hatayı bir yere GÖNDERMEK (örneğin bir loglama
  // servisine) için kullanılır -- ikisi birlikte çalışabilir.
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
