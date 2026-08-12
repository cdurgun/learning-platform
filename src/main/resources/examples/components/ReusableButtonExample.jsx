// Bir component'in en büyük faydası: BİR KEZ yazıp İSTEDİĞİN KADAR kullanmak.
// Aynı Button component'ini, farklı yerlerde tekrar tekrar kullanabiliriz --
// aynı HTML/CSS'i her seferinde yeniden yazmaya gerek yok.
function Button() {
  return <button>Tıkla</button>;
}

function Toolbar() {
  return (
    <div>
      <Button />
      <Button />
      <Button />
    </div>
  );
}

console.log(Toolbar());
