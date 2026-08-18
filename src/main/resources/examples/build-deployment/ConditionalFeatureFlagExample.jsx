// Environment variables aren't just for showing text/badges -- they're also
// used to behave differently depending on the environment (feature flags).
// It's important not to forget to convert the "true" string into an actual
// boolean -- every value in import.meta.env is a STRING, even "false" is truthy.
const showBetaBanner = import.meta.env.VITE_SHOW_BETA_BANNER === "true";

function BetaBanner() {
  if (!showBetaBanner) {
    return null;
  }

  return <div className="beta-banner">This is a beta build.</div>;
}

export default BetaBanner;
