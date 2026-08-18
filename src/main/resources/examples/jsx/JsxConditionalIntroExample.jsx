// You can't write "if" inside JSX (if is a statement, not an
// expression) -- but since you can put an "expression" inside { }, tools
// based on expressions like ternary (? :) or && come in handy here. We'll
// go into this topic in much more detail in the "Conditional Rendering"
// section (in the State & Events category) -- here we're just seeing why
// JSX does it this way.
const isLoggedIn = true;

const message = isLoggedIn ? <p>Welcome!</p> : <p>Please log in.</p>;

console.log(message);
