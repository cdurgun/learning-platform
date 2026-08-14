function Level1({ user }) {
  return <Level2 user={user} />;
}

function Level2({ user }) {
  return <Level3 user={user} />;
}

function Level3({ user }) {
  return <Level4 user={user} />;
}

function Level4({ user }) {
  return <p>Logged in as {user}</p>;
}

function WhyPropsDrillingHurtsExample() {
  // Level1, Level2, Level3'ün HİÇBİRİ `user`'ı kullanmıyor -- yalnızca bir
  // sonraki seviyeye AKTARIYORLAR. Yalnızca en dipteki Level4 gerçekten
  // kullanıyor. Ağaç derinleştikçe (ya da her seviyeye yeni prop'lar
  // eklendikçe) bu, hem yazması yorucu hem de hataya açık bir hal alır --
  // bir sonraki derste (Context API), bunu çözen bir yöntem göreceğiz.
  return <Level1 user="Ada" />;
}
