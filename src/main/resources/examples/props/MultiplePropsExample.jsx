// Bir component'e istediğin kadar prop gönderebilirsin -- her biri
// props nesnesinin ayrı bir alanı olarak fonksiyona ulaşır.
function UserCard(props) {
  return (
    <div>
      <h2>{props.name}</h2>
      <p>Yaş: {props.age}</p>
      <p>Şehir: {props.city}</p>
    </div>
  );
}

function App() {
  return <UserCard name="Ayşe" age={28} city="İzmir" />;
}

console.log(App());
