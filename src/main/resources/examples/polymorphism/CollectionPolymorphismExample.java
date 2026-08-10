import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

class CollectionPolymorphismExample {
    // Declared with the INTERFACE type -- works with any List implementation
    static void printAll(List<String> list) {
        for (String s : list) {
            System.out.println(s);
        }
    }

    public static void main(String[] args) {
        List<String> arrayBacked = new ArrayList<>();
        arrayBacked.add("a");
        arrayBacked.add("b");

        List<String> linkedBacked = new LinkedList<>();
        linkedBacked.add("c");
        linkedBacked.add("d");

        printAll(arrayBacked);  // same method, different List implementation
        printAll(linkedBacked); // same method, different List implementation
    }
}
