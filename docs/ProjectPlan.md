# 🚀 Java Learning Platform Roadmap

## Phase 1 — Foundation

**Goal:** Build a working Spring Boot infrastructure.

### 1.1 Project Foundation

- Spring Boot 3.5
- Java 21
- Maven
- `com.cdurgun.learning`
- `.editorconfig`
- `.gitattributes`
- `.gitignore`
- `LICENSE`
- `README.md`
- Docker Compose (PostgreSQL)
- `application.yml`
- `application-dev.yml`
- `application-test.yml`
- `application-prod.yml`
- `HomeController`
- Thymeleaf
- Bootstrap
- Home page

### 1.2 Database

- Flyway
- PostgreSQL connection
- `Course` Entity
- `Category` Entity
- `Topic` Entity
- `TopicTranslation` Entity
- `CodeExample` Entity
- Repository layer

### 1.3 Layout

- Navbar
- Sidebar
- Footer
- Bootstrap layout
- Responsive design

### 1.4 Markdown

- CommonMark
- Markdown → HTML conversion
- Content directory

```text
content/
├── tr/
└── en/
```

### 1.5 Code Examples

```text
examples/
└── enum/
    └── BasicEnum.java
```

- Read Java source files and display them on the page.

### 1.6 Syntax Highlighting

Use **Highlight.js** so Java code blocks are automatically highlighted.

````markdown
```java
// Java code
```
````

---

## Phase 2 — Java Content

The first topic will be completed in full.

### Enum (~20 sections)

- What is Enum
- Enum vs String
- Basic Enum
- Constructor
- Fields
- Methods
- `values()`
- `valueOf()`
- `name()`
- `ordinal()`
- `switch`
- Interface
- Abstract Method
- EnumSet
- EnumMap
- Singleton
- Strategy Pattern
- Real World Examples
- Interview Questions

Languages:

- 🇹🇷 Turkish
- 🇬🇧 English

---

## Phase 3 — Navigation

- Breadcrumb
- Previous Topic
- Next Topic
- Category Navigation
- Estimated Reading Time
- Difficulty

---

## Phase 4 — Search

A search bar at the top of the page that can search:

- Topics
- Categories
- Code examples

---

## Phase 5 — Admin Panel

`/admin`

- Create Course
- Create Category
- Create Topic
- Create Translation
- Create Code Example

---

## Phase 6 — Multi-language

Supported languages:

- 🇹🇷 Turkish
- 🇬🇧 English

Planned:

- 🇷🇺 Russian
- 🇩🇪 German

---

## Phase 7 — User System

- Login
- Register
- Progress Tracking
- Last Read
- Completed Topics

---

## Phase 8 — Favorites

- ⭐ Favorite Topics

---

## Phase 9 — Notes

Users can write personal notes for each topic.

---

## Phase 10 — Quiz

Example:

> **What is an Enum?**

- ○ Class
- ○ Interface
- ○ Special Type

---

## Phase 11 — Flashcards

Learning flashcards.

---

## Phase 12 — AI Assistant

An **Ask AI** button on every topic page.

---

## Phase 13 — Videos

- YouTube videos

---

## Phase 14 — Export

- PDF
- Markdown
- Print

---

## Phase 15 — Statistics

- Number of topics read
- Most viewed topic
- Learning progress
- Dashboard
