function LoadingMessage() {
  return <p>Yükleniyor...</p>;
}

function WelcomeMessage({ name }) {
  return <p>Hoş geldin, {name}!</p>;
}

function ConditionalComponentExample({ isLoading, name }) {
  // Koşula göre tek bir metin değil, tamamen FARKLI bir component
  // döndürebilirsin -- her ikisi de kendi başına anlamlı bir component.
  if (isLoading) {
    return <LoadingMessage />;
  }

  return <WelcomeMessage name={name} />;
}
