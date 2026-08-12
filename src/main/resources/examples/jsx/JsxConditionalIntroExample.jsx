// JSX içinde "if" yazamazsın (if bir ifade/expression değil, bir statement'tır) --
// ama { } içine bir "expression" koyabildiğin için, ternary (? :) ya da && gibi
// expression tabanlı araçlar burada işe yarar. Bu konuya "Conditional Rendering"
// bölümünde (State & Events kategorisinde) çok daha detaylı gireceğiz -- burada
// yalnızca JSX'in bunu neden bu şekilde yaptığını görüyoruz.
const isLoggedIn = true;

const message = isLoggedIn ? <p>Hoş geldin!</p> : <p>Lütfen giriş yap.</p>;

console.log(message);
