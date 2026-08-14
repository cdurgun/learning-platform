function TernaryConditionalExample({ isLoggedIn }) {
  // Ternary (? :) bir SONUÇ ÜRETİR, bu yüzden doğrudan { } içine yazılabilir.
  // IfConditionalExample'daki dört satırı tek satıra indiriyor.
  return <p>{isLoggedIn ? "Hoş geldin!" : "Lütfen giriş yap."}</p>;
}
