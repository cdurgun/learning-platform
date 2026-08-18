// JSX looks like HTML, but it's actually an extension of JavaScript.
// The browser doesn't understand it directly -- a compiler (Babel/Vite)
// converts it into a regular JavaScript function call behind the scenes.
const element = <h1>Hello, React!</h1>;

// The line above means the same thing as the following (if it were
// written without JSX):
// const element = React.createElement("h1", null, "Hello, React!");

console.log(element);
