// Mini proje: yeniden kullanılabilir bir Card component'i. Bu dersteki üç
// fikri (children, nested component'ler, composition) tek bir örnekte
// birleştiriyor.
function Card({ children }) {
  return <div className="card" style={{ border: "1px solid #ddd", padding: "1rem" }}>{children}</div>;
}

function CardTitle({ children }) {
  return <h3>{children}</h3>;
}

function CardText({ children }) {
  return <p>{children}</p>;
}

export { Card, CardTitle, CardText };
