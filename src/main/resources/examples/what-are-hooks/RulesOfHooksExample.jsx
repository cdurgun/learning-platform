import { useState } from "react";

function RulesOfHooksExample({ showExtra }) {
  // DOĞRU: Hook'lar HER ZAMAN component'in EN ÜST seviyesinde çağrılır.
  const [count, setCount] = useState(0);

  // YANLIŞ: Bir hook'u koşullu çağırmak (bunu asla yapma).
  // if (showExtra) {
  //   const [extra, setExtra] = useState(0); // Kurallara aykırı!
  // }
  //
  // Neden? React, hook'ların HER RENDER'DA AYNI SIRADA çağrıldığını
  // varsayarak her birini takip eder. Koşullu bir hook, bazı render'larda
  // çağrılıp bazılarında çağrılmayarak bu sırayı bozar -- React hangi
  // state'in hangi hook'a ait olduğunu şaşırır.

  return <p>Sayaç: {count}</p>;
}
