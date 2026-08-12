// Component'ler iç içe kullanılabilir -- bir component başka component'ler
// içerebilir, onlar da kendi içlerinde başka component'ler içerebilir. Küçük
// parçalardan büyük bir arayüz kurmanın yolu budur.
function Avatar() {
  return <img src="/avatar.png" alt="Profil resmi" />;
}

function UserName() {
  return <span>Ayşe Yılmaz</span>;
}

function UserProfile() {
  return (
    <div>
      <Avatar />
      <UserName />
    </div>
  );
}

function App() {
  return <UserProfile />;
}

console.log(App());
