import { useState } from "react";

function PreviousStateExample() {
  const [count, setCount] = useState(0);

  function incrementTwice() {
    // YANLIŞ: count burada hâlâ ESKİ değeri gösterir, iki satır da aynı
    // "eski değer + 1"i kullanır -- sonuçta yalnızca 1 artar, 2 değil.
    // setCount(count + 1);
    // setCount(count + 1);

    // DOĞRU: fonksiyon formu (prevCount => ...), her seferinde bir önceki
    // güncellemeden sonraki en güncel değeri kullanır.
    setCount((prevCount) => prevCount + 1);
    setCount((prevCount) => prevCount + 1);
  }

  return (
    <div>
      <p>Sayaç: {count}</p>
      <button onClick={incrementTwice}>2 Artır</button>
    </div>
  );
}
