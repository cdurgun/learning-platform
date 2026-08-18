// The biggest benefit of a component: write it ONCE, use it AS MANY TIMES
// AS YOU WANT. We can reuse the same Button component in different places
// over and over -- no need to rewrite the same HTML/CSS each time.
function Button() {
  return <button>Click</button>;
}

function Toolbar() {
  return (
    <div>
      <Button />
      <Button />
      <Button />
    </div>
  );
}

console.log(Toolbar());
