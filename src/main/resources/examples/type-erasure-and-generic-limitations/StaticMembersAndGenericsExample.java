import java.util.ArrayList;
import java.util.List;

public class StaticMembersAndGenericsExample {

    static class Container<T> {
        // private static T sharedDefault; // would NOT compile -- a static
        //     field belongs to the CLASS, shared across every instance,
        //     but T is only known per INSTANCE (Container<String> vs
        //     Container<Integer> could coexist) -- there is no single T
        //     a static field could consistently hold.

        // static void printDefault(T value) { } // would NOT compile for
        //     the same reason -- a static method has no particular
        //     instance, so it has no T to refer to either.

        // A static method CAN declare its own, independent type
        // parameter, exactly as covered in "Generic Methods" -- this one
        // has nothing to do with Container's T.
        static <U> List<U> singletonList(U value) {
            List<U> list = new ArrayList<>();
            list.add(value);
            return list;
        }
    }

    public static void main(String[] args) {
        System.out.println(Container.<String>singletonList("hello"));
        System.out.println(Container.<Integer>singletonList(42));
    }
}
