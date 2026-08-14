import { useState } from "react";
import { createPortal } from "react-dom";

function Popup() {
  return createPortal(<button>Click me (rendered in document.body)</button>, document.body);
}

function EventBubblingThroughPortalExample() {
  const [clicks, setClicks] = useState(0);

  return (
    // ÖNEMLİ: Popup, DOM'da bu <div>'in DIŞINDA (document.body'de)
    // render ediliyor. Ama içindeki <button>'a tıklandığında, onClick
    // yine de BURADA (React ağacındaki gerçek konumunda) çalışır --
    // React, event'leri gerçek DOM ağacına göre değil, KENDİ component
    // ağacına göre "bubble" ettirir. Bu, Portal'ların en şaşırtıcı ama en
    // kullanışlı özelliği.
    <div onClick={() => setClicks(clicks + 1)}>
      <p>Clicks: {clicks}</p>
      <Popup />
    </div>
  );
}
