// JSX'te attribute'lar HTML'e çok benzer, ama birkaç fark var:
// 1) "class" yerine "className" kullanılır (class, JavaScript'te ayrı bir anlam taşıyor).
// 2) Attribute değerleri de { } ile bir JavaScript değişkeni olabilir.
const userName = "ayse";

const avatar = (
  <img className="avatar" src={`/images/${userName}.png`} alt="Kullanıcı avatarı" />
);

// Etiketin kendisi kapanmıyorsa (örn. <img>, <input>, <br>), JSX'te
// "self-closing" olmak ZORUNDADIR -- sonuna / eklenir.
const divider = <hr />;

console.log(avatar, divider);
