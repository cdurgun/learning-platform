// Bir component, en basit hâliyle JSX döndüren bir JavaScript fonksiyonudur.
// Farkı: adı BÜYÜK harfle başlar -- React, küçük harfle başlayan isimleri
// "div", "h1" gibi normal HTML etiketi sanır, büyük harfle başlayanları ise
// senin yazdığın bir component olarak tanır.
function Welcome() {
  return <h1>Merhaba!</h1>;
}

console.log(Welcome());
