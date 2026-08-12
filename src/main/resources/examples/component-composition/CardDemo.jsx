// CardBase.jsx'teki üç küçük component'i (Card, CardTitle, CardText),
// composition ile birleştirerek iki FARKLI kart oluşturuyoruz -- her ikisi
// de aynı parçaları kullanıyor, ama içerikleri (children) farklı.
import { Card, CardTitle, CardText } from "./CardBase";

function App() {
  return (
    <div>
      <Card>
        <CardTitle>Ayşe Yılmaz</CardTitle>
        <CardText>Frontend Geliştirici</CardText>
      </Card>

      <Card>
        <CardTitle>React Kursu</CardTitle>
        <CardText>Components & Props kategorisi</CardText>
      </Card>
    </div>
  );
}

console.log(App());
