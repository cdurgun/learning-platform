// "children" is a special prop that every component automatically has.
// Whatever you write between a component's OPENING and CLOSING tags becomes
// that content, reaching the component as props.children.
function Box({ children }) {
  return <div className="box">{children}</div>;
}

function App() {
  return (
    <Box>
      <p>This text is Box's children.</p>
    </Box>
  );
}

console.log(App());
