function IfConditionalExample({ isLoggedIn }) {
  // if, bir SONUÇ ÜRETMEZ, bu yüzden doğrudan JSX'in { } içine yazılamaz.
  // Bunun yerine, return'den ÖNCE normal bir değişkene karar veriyoruz.
  let message;

  if (isLoggedIn) {
    message = "Hoş geldin!";
  } else {
    message = "Lütfen giriş yap.";
  }

  return <p>{message}</p>;
}
