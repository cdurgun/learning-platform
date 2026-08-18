// The same pattern as in the Build & Deployment lesson -- except this time
// the value is the REAL address of a deployed Spring Boot API. Locally
// (against the backend running on localhost:8080) and in production
// (against the address Render provides), the SAME code works with a
// different .env / Vercel environment variable value.
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL ?? "http://localhost:8080";

function ApiAddress() {
  return (
    <p>
      Data from <code>{API_BASE_URL}</code>
    </p>
  );
}

export default ApiAddress;
