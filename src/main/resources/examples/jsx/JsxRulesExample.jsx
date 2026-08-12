// JSX'in birkaç basit ama kesin kuralı var:

// 1) Bir JSX bloğu, TEK bir kök (root) elemente sahip olmalı.
// Bu ÇALIŞMAZ: <h1>Başlık</h1><p>Metin</p>  (iki kardeş element, tek kök yok)
// Bunun yerine bir <div> ile (ya da aşağıdaki gibi <> </> ile) sarmalanır:
const withDiv = (
  <div>
    <h1>Başlık</h1>
    <p>Metin</p>
  </div>
);

// <> </> ("Fragment"), fazladan bir <div> eklemeden aynı işi yapar --
// DOM'a görünmeyen, yalnızca JSX kuralını karşılamak için var olan bir sarmalayıcı.
const withFragment = (
  <>
    <h1>Başlık</h1>
    <p>Metin</p>
  </>
);

// 2) Attribute isimleri camelCase yazılır: "onclick" değil "onClick",
// "tabindex" değil "tabIndex".

// 3) JavaScript'te "class" bir anahtar kelime olduğu için "className" kullanılır.

console.log(withDiv, withFragment);
