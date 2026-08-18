// Inside curly braces { } you can write ANY JavaScript expression that
// produces a result: a variable, an addition operation, a function call...
const name = "Emma";
const greeting = <h1>Hello, {name}!</h1>;

const a = 5;
const b = 3;
const total = <p>Total: {a + b}</p>;

function shout(text) {
  return text.toUpperCase();
}
const loud = <p>{shout("i am learning react")}</p>;

console.log(greeting, total, loud);
