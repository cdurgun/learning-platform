import { Component } from "react";

// ÖNEMLİ: Error boundary'ler, bu kursta gördüğümüz İLK class component.
// React'te error boundary'leri hook'larla (fonksiyon component'lerle)
// yazmanın bir yolu YOK -- yalnızca class component'ler
// `static getDerivedStateFromError` ile bunu yapabiliyor. Bu yüzden bu
// TEK konuda, istisnai olarak bir class component kullanıyoruz.
class BasicErrorBoundaryExample extends Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  // Bir child component render sırasında hata FIRLATTIĞINDA, React bu
  // metodu çağırır -- döndürdüğü değer, yeni state olur.
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
