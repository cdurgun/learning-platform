import { createPortal } from "react-dom";

function Tooltip({ text }) {
  // document.body yerine, index.html'de özel olarak ayrılmış bir hedef
  // kullanmak daha yaygındır -- örneğin <div id="tooltip-root"></div>,
  // uygulamanın #root'una KARDEŞ (sibling) olarak eklenir. Bu, portal
  // içeriğinin kendi stillerini/konumunu yönetmesini kolaylaştırır.
  const target = document.getElementById("tooltip-root");

  if (!target) {
    return null;
  }

  return createPortal(<span className="tooltip">{text}</span>, target);
}

function PortalTargetSetupExample() {
  return (
    <div>
      <p>Hover for more info</p>
      <Tooltip text="This tooltip lives in its own DOM node." />
    </div>
  );
}
