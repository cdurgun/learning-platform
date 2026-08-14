import { createPortal } from "react-dom";

function BasicPortalExample() {
  // createPortal(child, container), `child`'ı normal React ağacındaki
  // YERİNE değil, DOM'daki farklı bir düğüme (`container`) render eder --
  // burada `document.body`'nin kendisine. Component ağacında (React
  // DevTools'ta) hâlâ BasicPortalExample'ın İÇİNDE görünür, ama gerçek
  // DOM'da tamamen farklı bir yerdedir.
  return createPortal(<p className="tooltip">I'm rendered directly on body!</p>, document.body);
}
