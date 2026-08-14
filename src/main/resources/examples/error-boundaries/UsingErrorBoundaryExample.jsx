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
    // Render sırasında bilinçli olarak bir hata fırlatıyoruz -- gerçek bir
    // uygulamada bu, beklenmedik bir `undefined.someProperty` gibi bir hata
    // olurdu.
    throw new Error("Count reached 3!");
  }

  return <p>Count: {count}</p>;
}

function UsingErrorBoundaryExample() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      {/* ErrorBoundary, İÇİNDEKİ herhangi bir component render sırasında
          hata fırlatırsa, o hatayı YAKALAR ve normal render'ı fallback
          UI'la DEĞİŞTİRİR -- BuggyCounter'ın kendisi hatayı yönetmek
          zorunda değil. */}
      <ErrorBoundary>
        <BuggyCounter count={count} />
      </ErrorBoundary>
    </div>
  );
}
