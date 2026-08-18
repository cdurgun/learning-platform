// USING (rendering) a component means writing it into JSX like an HTML tag:
// <Welcome />. A component can also be used inside another component --
// just like App uses Welcome here.
function Welcome() {
  return <h1>Hello!</h1>;
}

function App() {
  return (
    <div>
      <Welcome />
      <p>This is my first page built with React.</p>
    </div>
  );
}

console.log(App());
