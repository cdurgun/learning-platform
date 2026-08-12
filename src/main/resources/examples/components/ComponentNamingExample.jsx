// React, component ile normal HTML etiketini büyük/küçük harfe bakarak ayırır:
// - Küçük harfle başlıyorsa ("div", "button") -> normal HTML etiketi.
// - Büyük harfle başlıyorsa ("Welcome", "UserCard") -> senin component'in.

function userCard() {
  // Bu fonksiyon küçük harfle başladığı için, JSX içinde <userCard /> yazılsa
  // bile React bunu bir component olarak DEĞİL, bilinmeyen bir HTML etiketi
  // olarak yorumlamaya çalışır -- bu yüzden component isimleri HER ZAMAN
  // büyük harfle başlamalıdır.
  return <div>Yanlış isimlendirme örneği</div>;
}

function UserCard() {
  // Doğrusu bu: büyük harfle başlayan bir isim.
  return <div>Doğru isimlendirme örneği</div>;
}

console.log(userCard(), UserCard());
