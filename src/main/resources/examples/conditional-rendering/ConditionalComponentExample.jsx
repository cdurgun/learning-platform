function LoadingMessage() {
  return <p>Loading...</p>;
}

function WelcomeMessage({ name }) {
  return <p>Welcome, {name}!</p>;
}

function ConditionalComponentExample({ isLoading, name }) {
  // Instead of just a single piece of text, you can return an entirely
  // DIFFERENT component depending on the condition -- both are meaningful
  // components in their own right.
  if (isLoading) {
    return <LoadingMessage />;
  }

  return <WelcomeMessage name={name} />;
}
