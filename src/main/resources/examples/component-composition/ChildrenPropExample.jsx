// "children", her component'in otomatik olarak sahip olduğu özel bir prop.
// Bir component'in AÇILIŞ ve KAPANIŞ etiketi arasına ne yazarsan, o içerik
// props.children olarak o component'e ulaşır.
function Box({ children }) {
  return <div className="box">{children}</div>;
}

function App() {
  return (
    <Box>
      <p>Bu metin, Box'un children'ı.</p>
    </Box>
  );
}

console.log(App());
