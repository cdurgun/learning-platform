// Bir prop hiç gönderilmezse ne olsun? Destructuring sırasında bir
// "varsayılan değer" (default value) tanımlayabilirsin -- normal JavaScript
// fonksiyon parametrelerindeki varsayılan değerlerle tamamen aynı fikir.
function Greeting({ name = "Misafir" }) {
  return <h1>Merhaba, {name}!</h1>;
}

console.log(Greeting({ name: "Ayşe" })); // Merhaba, Ayşe!
console.log(Greeting({}));               // Merhaba, Misafir! (varsayılan kullanıldı)
