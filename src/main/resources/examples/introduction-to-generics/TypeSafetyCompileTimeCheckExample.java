import java.util.ArrayList;
import java.util.List;

public class TypeSafetyCompileTimeCheckExample {

    public static void main(String[] args) {
        List<String> names = new ArrayList<>();
        names.add("Alice");
        names.add("Bob");

        // names.add(42); // does NOT compile -- int cannot be used where
        //                   the compiler expects a String. This line is
        //                   commented out only because it wouldn't compile
        //                   otherwise; uncomment it to see the real error.

        // Reading back requires no cast at all -- the compiler already
        // knows every element is a String, because that's the only thing
        // this particular List<String> was ever allowed to accept.
        for (String name : names) {
            System.out.println(name.toUpperCase());
        }
    }
}
