import { useState, useMemo } from "react";

function ObjectMemoizationExample() {
  const [count, setCount] = useState(0);

  // useMemo olmadan, her render'da YENİ bir nesne oluşur -- içeriği aynı
  // olsa bile, iki farklı render'daki nesneler "aynı" (===) SAYILMAZ.
  const config = useMemo(
    () => ({ theme: "dark", fontSize: 16 }),
    [], // Bağımlılık yok -- nesne yalnızca İLK render'da oluşturulur.
  );

  return (
    <div>
      <p>Sayaç: {count}</p>
      <p>
        Tema: {config.theme}, Font Boyutu: {config.fontSize}
      </p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
