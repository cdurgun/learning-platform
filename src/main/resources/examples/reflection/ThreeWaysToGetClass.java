class Book {
    private String title;
    private String author;
    private int pages;

    Book() {
        this("Untitled", "Unknown", 0);
    }

    Book(String title, String author, int pages) {
        this.title = title;
        this.author = author;
        this.pages = pages;
    }

    @Override
    public String toString() {
        return "Book{title='" + title + "', author='" + author + "', pages=" + pages + "}";
    }
}

class ThreeWaysToGetClass {
    public static void main(String[] args) throws ClassNotFoundException {
        Book book = new Book("Effective Java", "Joshua Bloch", 412);

        Class<?> fromInstance = book.getClass();
        Class<?> fromLiteral = Book.class;
        Class<?> fromName = Class.forName("Book");

        System.out.println(fromInstance.getName());       // Book
        System.out.println(fromInstance == fromLiteral);  // true
        System.out.println(fromInstance == fromName);     // true
    }
}
