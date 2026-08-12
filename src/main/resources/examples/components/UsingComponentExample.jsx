// Bir component'i KULLANMAK (render etmek), onu bir HTML etiketi gibi
// JSX içine yazmak demektir: <Welcome />. Bir component, başka bir
// component'in içinde de kullanılabilir -- tıpkı burada App'in Welcome'ı
// kullanması gibi.
function Welcome() {
  return <h1>Merhaba!</h1>;
}

function App() {
  return (
    <div>
      <Welcome />
      <p>Bu, React ile yapılmış ilk sayfam.</p>
    </div>
  );
}

console.log(App());
