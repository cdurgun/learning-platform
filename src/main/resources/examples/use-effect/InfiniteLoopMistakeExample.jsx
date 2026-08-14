import { useState, useEffect } from "react";

function InfiniteLoopMistakeExample() {
  const [count, setCount] = useState(0);

  // YANLIŞ: dependency array'siz bir useEffect, HER render'dan sonra çalışır.
  // İçinde state güncellenirse, bu güncelleme yeni bir render tetikler,
  // o render yine effect'i çalıştırır -- SONSUZ DÖNGÜ.
  // useEffect(() => {
  //   setCount(count + 1);
  // });

  // DOĞRU: dependency array'i [] yaparak yalnızca ilk render'da çalıştır.
  useEffect(() => {
    setCount((prev) => prev + 1);
  }, []);

  return <p>Sayaç (yalnızca 1 kez artmalı): {count}</p>;
}
