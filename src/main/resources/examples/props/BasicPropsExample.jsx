// Props (properties), bir component'e DIŞARIDAN veri göndermenin yoludur --
// tıpkı bir HTML etiketine attribute vermek gibi, ama burada değer, senin
// component fonksiyonuna bir parametre olarak ulaşır.
function Greeting(props) {
  return <h1>Merhaba, {props.name}!</h1>;
}

function App() {
  return <Greeting name="Ayşe" />;
}

console.log(App());
// Sonuç: <h1>Merhaba, Ayşe!</h1>
