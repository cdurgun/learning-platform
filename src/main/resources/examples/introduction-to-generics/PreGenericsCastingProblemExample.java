import java.util.ArrayList;
import java.util.List;

public class PreGenericsCastingProblemExample {

    public static void main(String[] args) {
        // A raw (non-generic) List: the compiler has no idea what type of
        // element it's supposed to hold, so it accepts anything...
        List names = new ArrayList();
        names.add("Alice");
        names.add("Bob");
        names.add(42); // ...including something that clearly doesn't belong here.

        // Reading requires an explicit, unchecked cast -- the compiler
        // trusts you that the element really is a String.
        for (Object item : names) {
            String name = (String) item; // throws at runtime on the int 42
            System.out.println(name.toUpperCase());
        }
    }
}
