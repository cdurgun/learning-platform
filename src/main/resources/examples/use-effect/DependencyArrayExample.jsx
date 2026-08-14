import { useState, useEffect } from "react";

function DependencyArrayExample() {
  const [count, setCount] = useState(0);
  const [name, setName] = useState("Ayşe");

  useEffect(() => {
    console.log("count değişti:", count);
  }, [count]); // Yalnızca count değiştiğinde çalışır -- name değişse de çalışmaz.

  return (
    <div>
      <p>
        {name}, sayaç: {count}
      </p>
      <button onClick={() => setCount(count + 1)}>Sayacı Artır</button>
      <button onClick={() => setName(name === "Ayşe" ? "Mehmet" : "Ayşe")}>
        İsmi Değiştir
      </button>
    </div>
  );
}
