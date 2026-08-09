class Book {
    private String title;
    private String author;
    private int pages;

    Book(String title, String author, int pages) {
        this.title = title;
        this.author = author;
        this.pages = pages;
    }

    String getTitle() {
        return title;
    }
}

class ObjectInspectorDemo {
    public static void main(String[] args) throws IllegalAccessException {
        Book book = new Book("Clean Architecture", "Robert C. Martin", 432);
        ObjectInspector.inspect(book);
    }
}
