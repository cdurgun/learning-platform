import java.lang.reflect.Method;

class Book {
    private String title;

    Book(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    private boolean isLong() {
        return title.length() > 50;
    }
}

class MethodsExample {
    public static void main(String[] args) {
        Class<Book> type = Book.class;

        System.out.println("getMethods() count: " + type.getMethods().length);
        // includes getTitle() plus everything inherited from Object (toString, equals, hashCode, ...)

        System.out.println("getDeclaredMethods():");
        for (Method m : type.getDeclaredMethods()) {
            System.out.println("  " + m.getName() + " -> " + m.getReturnType().getSimpleName());
        }
        // getTitle -> String, isLong -> boolean (declared here, private included, inherited excluded)
    }
}
