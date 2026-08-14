import { useState, useEffect } from "react";

function BasicUseEffectExample() {
  const [count, setCount] = useState(0);

  // Bir SIDE EFFECT: component'in kendi render çıktısı (JSX) dışında
  // yaptığı bir şey -- burada tarayıcının sekme başlığını değiştiriyoruz.
  useEffect(() => {
    document.title = `Sayaç: ${count}`;
  });

  return (
    <div>
      <p>Sayaç: {count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
