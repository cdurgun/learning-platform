import { useState, useMemo } from "react";

function slowSquare(n) {
  // Kasıtlı olarak YAVAŞ bir hesaplama -- gerçek bir "pahalı hesaplama"yı
  // simüle etmek için.
  let result = 0;
  for (let i = 0; i < 100000000; i++) {
    result = n * n;
  }
  return result;
}

function UseMemoBasicExample() {
  const [number, setNumber] = useState(5);
  const [theme, setTheme] = useState("light");

  // useMemo, `number` değişmediği sürece slowSquare'i TEKRAR ÇALIŞTIRMAZ --
  // önceki sonucu hafızada tutar (memoize eder) ve onu döndürür.
  const squared = useMemo(() => slowSquare(number), [number]);

  return (
    <div>
      <p>
        {number} karesi: {squared}
      </p>
      <button onClick={() => setNumber(number + 1)}>Sayıyı Artır</button>
      <button onClick={() => setTheme(theme === "light" ? "dark" : "light")}>
        Temayı Değiştir ({theme})
      </button>
    </div>
  );
}
