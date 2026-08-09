import java.lang.reflect.Field;

class Book {
    public static final String CATEGORY = "Literature";
    private String title;
    private String author;
    private int pages;

    Book(String title, String author, int pages) {
        this.title = title;
        this.author = author;
        this.pages = pages;
    }
}

class FieldsExample {
    public static void main(String[] args) throws Exception {
        Class<Book> type = Book.class;

        System.out.println("getFields():");
        for (Field f : type.getFields()) {
            System.out.println("  " + f.getName());
        }
        // getFields(): CATEGORY

        System.out.println("getDeclaredFields():");
        for (Field f : type.getDeclaredFields()) {
            System.out.println("  " + f.getName() + " : " + f.getType().getSimpleName());
        }
        // getDeclaredFields(): CATEGORY : String, title : String, author : String, pages : int

        Field categoryField = type.getField("CATEGORY");
        System.out.println(categoryField.get(null)); // Literature — static field, no instance needed
    }
}
