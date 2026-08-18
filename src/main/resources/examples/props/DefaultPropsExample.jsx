// What should happen if a prop is never passed at all? You can define a
// "default value" during destructuring -- exactly the same idea as default
// values for regular JavaScript function parameters.
function Greeting({ name = "Guest" }) {
  return <h1>Hello, {name}!</h1>;
}

console.log(Greeting({ name: "Emma" })); // Hello, Emma!
console.log(Greeting({}));               // Hello, Guest! (default was used)
