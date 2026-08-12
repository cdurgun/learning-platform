// Süslü parantez { } içine, sonuç üreten HERHANGİ bir JavaScript ifadesi
// yazabilirsin: bir değişken, bir toplama işlemi, bir fonksiyon çağrısı...
const name = "Ayşe";
const greeting = <h1>Merhaba, {name}!</h1>;

const a = 5;
const b = 3;
const total = <p>Toplam: {a + b}</p>;

function shout(text) {
  return text.toUpperCase();
}
const loud = <p>{shout("react öğreniyorum")}</p>;

console.log(greeting, total, loud);
