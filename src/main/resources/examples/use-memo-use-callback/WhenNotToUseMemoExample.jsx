import { useState, useMemo } from "react";

function WhenNotToUseMemoExample() {
  const [count, setCount] = useState(0);

  // GEREKSİZ: Bu toplama işlemi zaten çok hızlı -- useMemo'nun kendi
  // maliyeti (karşılaştırma yapmak, sonucu hafızada tutmak), kazandırdığından
  // daha pahalı olabilir.
  // const doubled = useMemo(() => count * 2, [count]);

  // DAHA İYİ: Basit, hızlı hesaplamalar için useMemo'ya gerek yok.
  const doubled = count * 2;

  return (
    <div>
      <p>
        {count} x 2 = {doubled}
      </p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
