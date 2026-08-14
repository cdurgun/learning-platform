import { useState } from "react";

function WhyControlledMattersExample() {
  const [text, setText] = useState("");

  // Değer state'te olduğu için, kullanıcı her harf yazdığında ekranın
  // BAŞKA bir yerinde de anında kullanabiliyoruz -- örneğin karakter
  // sayısını ya da büyük harfli önizlemesini göstermek gibi.
  return (
    <div>
      <input
        type="text"
        value={text}
        onChange={(event) => setText(event.target.value)}
        placeholder="Bir şey yaz..."
      />
      <p>Karakter sayısı: {text.length}</p>
      <p>Büyük harf önizleme: {text.toUpperCase()}</p>
    </div>
  );
}
