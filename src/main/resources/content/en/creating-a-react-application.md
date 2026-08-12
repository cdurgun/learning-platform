# Creating a React Application

In "What Is React?" we saw what React actually is. In this lesson, we'll
look at how to create a real React project on your computer. We still
won't write any React code -- we're just learning how to set up and run a
project. We'll start writing code in the "JSX" lesson.

## What Are Node.js and npm?

React projects run on your computer first (during development), not just
in the browser. For that you need **Node.js** -- a program that lets you
run JavaScript outside the browser.

Node.js comes bundled with **npm** (Node Package Manager). npm lets you
add ready-made code packages ("libraries") written by other people to
your project -- React itself is one such package.

```bash
node --version
npm --version
```

These two commands show whether Node.js and npm are installed on your
computer, and which version.

## Creating a New Project with Vite

The easiest way to start a new React project is with **Vite**. Vite sets
up the project for you and runs fast during development.

```bash
npm create vite@latest my-first-app -- --template react
cd my-first-app
npm install
```

- The first line creates a new React project named `my-first-app`.
- The second line moves into that folder.
- The third line downloads all the packages the project needs.

> 💡 Tip An older tool called "Create React App" (CRA) used to be the
> standard way to do this. CRA is no longer maintained -- Vite is the
> right choice for a new project today.

## Project Structure

Once `npm create vite` finishes, you'll see a folder structure like this:

```text
my-first-app/
├── node_modules/     (all downloaded packages live here -- you never touch this)
├── public/           (files copied as-is, e.g. a favicon)
├── src/
│   ├── App.jsx       (the app's main component)
│   └── main.jsx       (the file where the app starts)
├── index.html         (the single HTML file the browser opens)
└── package.json       (the project's name, dependencies, and commands)
```

You'll spend most of your time in the `src/` folder -- that's where
you'll write your own components.

## What Is package.json?

`package.json` is like a React project's "ID card." It lists the
project's name, which packages it needs, and which commands it can run:

```json
{
  "name": "my-first-app",
  "scripts": {
    "dev": "vite",
    "build": "vite build"
  },
  "dependencies": {
    "react": "^19.0.0",
    "react-dom": "^19.0.0"
  }
}
```

The `react` and `react-dom` entries under `dependencies` are the two core
packages the project downloads to be able to use React. The `dev` and
`build` entries under `scripts` are shortcuts for the commands we'll see
below.

## Running the App: npm run dev

Once the project is set up, start the development server with:

```bash
npm run dev
```

This prints an address in the terminal (usually
`http://localhost:5173`). Open that address in your browser to see your
React app. When you change something in `src/App.jsx`, the browser
updates **automatically** -- you never need to refresh it by hand.

## Development vs. Production

The version you run with `npm run dev` is the **development** version --
it includes features that make development easier, like instant reloads,
but it isn't meant for real users (it's larger and slower).

When your app is ready for real users:

```bash
npm run build
```

This creates a `dist/` folder -- minified files, fast to load, ready for
**production**. We'll return to "production" and "deployment" with a real
example later in this course.

## Summary and Glossary

Setting up a React project needs Node.js/npm; you create the project with
Vite; `npm run dev` runs it during development; `npm run build` prepares
it for production.

**Glossary**

**Node.js** — A program that lets you run JavaScript outside the browser.

**npm (Node Package Manager)** — A tool for adding ready-made code
packages to your project.

**Vite** — A tool for creating a new React project and running it fast
during development.

**`package.json`** — The file that lists a project's name, dependencies,
and commands.

**Development** — The mode you use while writing code -- fast, but not
optimized.

**Production** — The minified, optimized version served to real users.
