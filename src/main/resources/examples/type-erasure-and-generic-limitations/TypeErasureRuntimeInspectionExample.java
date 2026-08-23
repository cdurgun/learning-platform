import java.util.ArrayList;
import java.util.List;

public class TypeErasureRuntimeInspectionExample {

    public static void main(String[] args) {
        List<String> strings = new ArrayList<>();
        List<Integer> integers = new ArrayList<>();

        // At runtime, the type argument is GONE -- both lists share the
        // exact same runtime class, ArrayList, with no trace of String or
        // Integer left anywhere in that Class object.
        System.out.println(strings.getClass());
        System.out.println(integers.getClass());
        System.out.println("same runtime class? " + (strings.getClass() == integers.getClass()));

        Object value = strings;

        // if (value instanceof List<String>) { } // would NOT compile --
        //     there is no such runtime information as "a List of String"
        //     to check against; the type argument was erased.
        if (value instanceof List<?>) { // only the RAW type can be checked
            System.out.println("it's some kind of List, element type unknown at runtime");
        }
    }
}
