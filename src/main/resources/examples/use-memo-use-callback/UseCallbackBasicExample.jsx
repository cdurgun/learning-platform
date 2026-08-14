import { useState, useCallback } from "react";

function UseCallbackBasicExample() {
  const [count, setCount] = useState(0);

  // useCallback olmadan, her render'da handleClick YENİ bir fonksiyon olarak
  // oluşturulur -- iki farklı render'daki fonksiyonlar "aynı" sayılmaz.
  // useCallback, dependency array değişmediği sürece AYNI fonksiyon
  // referansını korur.
  const handleClick = useCallback(() => {
    console.log("Tıklandı, count:", count);
  }, [count]);

  return (
    <div>
      <p>Sayaç: {count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
      <button onClick={handleClick}>Console'a Yaz</button>
    </div>
  );
}
