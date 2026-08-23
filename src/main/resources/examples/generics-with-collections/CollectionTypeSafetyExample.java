import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CollectionTypeSafetyExample {

    public static void main(String[] args) {
        List<String> names = new ArrayList<>();
        names.add("Alice");
        // names.add(42); // would NOT compile -- List<String> only accepts String

        String first = names.get(0); // no cast needed -- the compiler already knows it's a String

        Map<String, Integer> ages = new HashMap<>();
        ages.put("Alice", 30);
        // ages.put("Alice", "thirty"); // would NOT compile -- the value must be an Integer
        // ages.put(42, 30);            // would NOT compile -- the key must be a String

        int age = ages.get("Alice"); // no cast needed here either

        System.out.println(first + " is " + age);
    }
}
