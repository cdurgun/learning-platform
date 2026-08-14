import { useState } from "react";

// useState, React'in sana hazır sunduğu bir HOOK'tur -- "use" ile başlayan,
// function component'lere state gibi React özellikleri ekleyen bir fonksiyon.
function WhatIsAHookExample() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>useState bir hook'tur: {count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
