// At its simplest, a component is a JavaScript function that returns JSX.
// The difference: its name starts with an UPPERCASE letter -- React treats
// names starting with a lowercase letter as normal HTML tags like "div",
// "h1", and recognizes names starting with an uppercase letter as a
// component you wrote.
function Welcome() {
  return <h1>Hello!</h1>;
}

console.log(Welcome());
