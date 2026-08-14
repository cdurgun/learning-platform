import { useState, useEffect } from "react";

// useEffect + useState'i tekrar tekrar yazmak yerine, "veri çekme" mantığını
// yeniden kullanılabilir bir custom hook'a çıkarıyoruz. (Basitleştirilmiş
// bir örnek -- hata yönetimi ve yarış durumları gibi konular "API & Data
// Fetching" kategorisinde daha detaylı işlenecek.)
function useFetch(url) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch(url)
      .then((response) => response.json())
      .then((json) => {
        setData(json);
        setLoading(false);
      });
  }, [url]);

  return { data, loading };
}

function UseFetchExample() {
  const { data, loading } = useFetch("https://api.example.com/users");

  if (loading) {
    return <p>Yükleniyor...</p>;
  }

  return <p>{data.length} kullanıcı bulundu.</p>;
}
