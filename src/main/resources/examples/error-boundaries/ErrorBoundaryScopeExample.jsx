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
      {/* İki AYRI ErrorBoundary, iki AYRI bölümü sarmalıyor -- Sidebar
          çökse bile, MainContent bundan ETKİLENMEZ, kendi ErrorBoundary'si
          İÇİNDE kalır. Tek bir büyük ErrorBoundary kullansaydık, herhangi
          bir hata TÜM sayfayı "Something went wrong" mesajına
          çevirebilirdi. */}
      <ErrorBoundary fallbackText="Sidebar failed to load.">
        <BuggyWidget />
      </ErrorBoundary>
      <ErrorBoundary fallbackText="Main content failed to load.">
        <p>Main content (still works fine)</p>
      </ErrorBoundary>
    </div>
  );
}
