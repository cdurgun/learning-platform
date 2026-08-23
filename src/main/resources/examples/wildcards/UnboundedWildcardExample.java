import java.util.List;

public class UnboundedWildcardExample {

    // List<?> -- an UNBOUNDED wildcard -- accepts a List of ANY element
    // type. It's the right choice when the method genuinely doesn't care
    // what the element type is, and only needs operations every List
    // supports regardless of what it holds.
    static void printSize(List<?> list) {
        System.out.println("size: " + list.size());
        for (Object item : list) { // elements can only be read as Object
            System.out.println(" - " + item);
        }
    }

    public static void main(String[] args) {
        printSize(List.of("a", "b", "c"));
        printSize(List.of(1, 2, 3));
        printSize(List.of(true, false));
    }
}
