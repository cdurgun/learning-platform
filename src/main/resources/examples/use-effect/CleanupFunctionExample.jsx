import { useState, useEffect } from "react";

function CleanupFunctionExample() {
  const [seconds, setSeconds] = useState(0);

  useEffect(() => {
    const intervalId = setInterval(() => {
      setSeconds((prev) => prev + 1);
    }, 1000);

    // Cleanup fonksiyonu: component ekrandan kalktığında (unmount) ya da
    // effect yeniden çalışmadan HEMEN ÖNCE React bunu otomatik çağırır.
    // Burada, interval'i temizlemezsek, component ekrandan kalktıktan
    // sonra bile arka planda çalışmaya devam eder -- bir "memory leak".
    return () => {
      clearInterval(intervalId);
    };
  }, []);

  return <p>Geçen süre: {seconds} saniye</p>;
}
