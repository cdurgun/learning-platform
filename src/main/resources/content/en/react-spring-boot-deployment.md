# React + Spring Boot Deployment

In Build & Deployment, we deployed a React app to Vercel -- but that app
had no backend at all. This lesson covers a React app connected to a REAL
Spring Boot backend, deployed to two SEPARATE platforms.

## Why Two Separate Platforms?

Vercel is designed for static sites and short-lived serverless
functions -- it supports runtimes like Node.js/Python, but it can't host
the CONTINUOUSLY RUNNING Java server process (embedded Tomcat) that Spring
Boot needs. So a common real-world pattern is: deploy React to Vercel, and
deploy the Spring Boot backend SEPARATELY to a platform built for
long-running servers (**Render**, in this lesson).

## Reading the Backend Address from an Environment Variable

The same pattern from Build & Deployment, this time for the backend's
address:

{{ApiBaseUrlFromEnvExample.jsx}}

Locally, `VITE_API_BASE_URL` points at Spring Boot running on
`localhost:8080`; in production (Vercel's environment variables) it points
at the REAL address Render gives you. The code itself never changes.

## Fetching from a Deployed Backend

The `useEffect`+`fetch`+loading/error pattern from API & Data Fetching, now
running against a real deployment:

{{FetchFromDeployedBackendExample.jsx}}

This component's behavior is completely unaffected by the switch from
`json-server` to a real Spring Boot app on the other end -- all `fetch`
sees is a URL and a JSON response.

## CORS: Allowing a Deployed Frontend

In Advanced Spring MVC, we wrote a GLOBAL CORS configuration with
`addCorsMappings`. In a real deployment, this reads from an environment
variable instead of a hardcoded domain:

{{DeploymentCorsConfigExample.java}}

`allowedOrigin` comes from the `CORS_ALLOWED_ORIGIN` environment variable
via `application.properties` -- filling in that variable on the Render
Dashboard with the REAL address Vercel gave you is enough, the code never
changes. If the origin doesn't match EXACTLY (including `https://`, with
NO trailing `/`), the browser blocks the request with a CORS error.

## Deploy Order: The Chicken-and-Egg Problem

Since React needs to know the backend's address, and the backend needs to
know React's address, the order matters:

1. **Deploy the backend to Render first** -- it gives you a URL.
2. **Then deploy React to Vercel**, filling `VITE_API_BASE_URL` with the URL
   from step 1 -- it gives you ANOTHER URL.
3. **Go back to Render**, and fill `CORS_ALLOWED_ORIGIN` with the URL from
   step 2. This automatically restarts the backend.

Skip this order (e.g. never fill in the CORS variable) and the frontend
reaches the backend, but the browser REFUSES to hand the response to
JavaScript -- you'll see a successful (200) request in the Network tab, but
a CORS error in the console.

## Summary and Glossary

React and Spring Boot are deployed SEPARATELY, to different platforms
(Vercel + Render) -- each knows the other's address through an environment
variable. The backend's CORS configuration reads from an environment
variable instead of a hardcoded domain, so which frontend is allowed can be
changed without touching the code. Deploy order matters: backend first,
then frontend, then update the backend's CORS setting.

**Glossary**

**CORS (Cross-Origin Resource Sharing)** — The mechanism that lets a
browser hand a response from a server on a different origin (domain) to
JavaScript.

**Origin** — The scheme + host + port triple (e.g.
`https://example.vercel.app`).

## Practical Project

There's a project using the concepts from this lesson that's ACTUALLY been
deployed:

- Backend (Render): **[fullstack-deployment-backend-zst1.onrender.com](https://fullstack-deployment-backend-zst1.onrender.com/api/health)**
- Frontend (Vercel): **[React + Spring Boot Deployment Demo](https://react-course-projects-components-pr.vercel.app/)**
- Source code: **[fullstack-deployment (React)](https://github.com/cdurgun/react-course-projects/tree/main/projects/fullstack-deployment)**
  and **[backend/fullstack-deployment (Spring Boot)](https://github.com/cdurgun/react-course-projects/tree/main/backend/fullstack-deployment)**

Open the live page and you'll see the "Java", "React", "Spring Boot" list
coming from `GET /api/courses` -- since CORS is configured correctly, the
browser lets the response from a different domain (`onrender.com`) reach
the React code.

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects

# Backend (requires Java 21 + Maven)
cd backend/fullstack-deployment
mvn spring-boot:run

# In a separate terminal: the frontend
cd ../../
npm install
cp projects/fullstack-deployment/.env.example projects/fullstack-deployment/.env
cd projects/fullstack-deployment
npm run dev
```
