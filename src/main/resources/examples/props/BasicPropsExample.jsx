// Props (properties) are a way to pass data INTO a component from the
// outside -- just like giving an HTML tag an attribute, except here the
// value reaches your component function as a parameter.
function Greeting(props) {
  return <h1>Hello, {props.name}!</h1>;
}

function App() {
  return <Greeting name="Emma" />;
}

console.log(App());
// Result: <h1>Hello, Emma!</h1>
