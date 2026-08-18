// Vite only embeds environment variables that start with "VITE_" into the
// client code -- they're read via import.meta.env at build time. The value
// comes from the .env file (local development) or from Vercel's "Environment
// Variables" setting (production); if it's undefined, `??` falls back to a default.
const appVersion = import.meta.env.VITE_APP_VERSION ?? "dev";

function VersionBadge() {
  return <span className="badge">v{appVersion}</span>;
}

export default VersionBadge;
