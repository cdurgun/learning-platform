import java.util.ArrayList;
import java.util.List;

public class ListBasicsExample {
    public static void main(String[] args) {
        List<String> fruits = new ArrayList<>();
        fruits.add("apple");
        fruits.add("pear");
        fruits.add("banana");
        fruits.add("apple"); // a List allows duplicate elements

        System.out.println("List: " + fruits);
        System.out.println("Size: " + fruits.size());
        System.out.println("index 0: " + fruits.get(0));
        System.out.println("Contains 'banana'? " + fruits.contains("banana"));
        System.out.println("First index of 'apple': " + fruits.indexOf("apple"));

        fruits.set(1, "cherry"); // overwrite index 1
        System.out.println("After set(1, cherry): " + fruits);

        fruits.remove("cherry"); // remove by value
        System.out.println("After remove(cherry): " + fruits);

        fruits.remove(0); // remove by index
        System.out.println("After remove(0): " + fruits);

        for (String fruit : fruits) {
            System.out.println("for-each: " + fruit);
        }
    }
}
