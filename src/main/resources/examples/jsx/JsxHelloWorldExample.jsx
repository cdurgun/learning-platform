// JSX, HTML'e benziyor ama aslında JavaScript'in bir uzantısı.
// Tarayıcı bunu doğrudan anlamaz -- bir derleyici (Babel/Vite) bunu
// arka planda normal bir JavaScript fonksiyon çağrısına çevirir.
const element = <h1>Merhaba, React!</h1>;

// Yukarıdaki satır, aşağıdakiyle aynı anlama gelir (JSX olmadan yazılsaydı):
// const element = React.createElement("h1", null, "Merhaba, React!");

console.log(element);
