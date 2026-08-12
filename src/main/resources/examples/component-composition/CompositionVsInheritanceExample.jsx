// "Inheritance" (kalıtım), Object-Oriented Programming'de bir sınıfın başka
// bir sınıftan özellik devralmasıdır. React'te component'ler arasında böyle
// bir kalıtım YOKTUR -- bunun yerine "composition" (birleştirme) kullanılır:
// küçük component'leri, büyük bir component'in İÇİNE koyarak birleştirirsin.

// Composition -- bu projenin (ve React'in) kullandığı yol:
function Card({ children }) {
  return <div className="card">{children}</div>;
}

function ProfileCard() {
  return (
    <Card>
      <h3>Ayşe Yılmaz</h3>
      <p>Frontend Geliştirici</p>
    </Card>
  );
}

// "class ProfileCard extends Card { ... }" gibi bir kalıtım React'te
// YAZILMAZ -- React ekibi, composition'ın neredeyse her senaryo için
// yeterli ve daha basit olduğunu söylüyor.

console.log(ProfileCard());
