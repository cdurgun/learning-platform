import { memo, useState } from "react";

// memo(), bir component'i "hatırlanan" (memoized) bir versiyona sarmalar --
// React, yeniden render etmeden ÖNCE, props'ların bir öncekiyle AYNI olup
// olmadığını kontrol eder; aynıysa, render'ı ATLAR.
const ExpensiveList = memo(function ExpensiveList({ items }) {
  console.log("ExpensiveList render edildi");

  return (
    <ul>
      {items.map((item) => (
        <li key={item}>{item}</li>
      ))}
    </ul>
  );
});

// `items`'ı component'in DIŞINDA tanımlıyoruz -- component'in içine
// koysaydık, her render'da YENİ bir dizi oluşturulur, referansı değişir ve
// memo hiçbir zaman render'ı atlayamazdı (bkz. bir sonraki ders,
// "ReactMemoWithCallbackExample").
const items = ["Java", "React", "Spring Boot"];

function ReactMemoExample() {
  const [count, setCount] = useState(0);

  return (
    <div>
      {/* `count` arttığında ReactMemoExample yeniden render olur, ama
          `items`'ın İÇERİĞİ aynı kaldığı için (aynı dizi elemanları),
          memo artık ExpensiveList'in yeniden render edilmesini ATLAR. */}
      <button onClick={() => setCount(count + 1)}>Count: {count}</button>
      <ExpensiveList items={items} />
    </div>
  );
}
