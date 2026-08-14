import { useState, useEffect, useRef } from "react";

function PreviousValueWithRefExample() {
  const [count, setCount] = useState(0);
  const previousCountRef = useRef(undefined);

  useEffect(() => {
    // Her render'dan SONRA, mevcut değeri ref'e kaydediyoruz -- bir sonraki
    // render'da "bir önceki değer" olarak okuyabilmek için. Bunun için
    // state değil ref kullanıyoruz, çünkü bu kaydı ekranı yeniden
    // render etmeden yapmak istiyoruz.
    previousCountRef.current = count;
  });

  return (
    <div>
      <p>
        Şimdiki: {count}, Önceki: {previousCountRef.current}
      </p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
