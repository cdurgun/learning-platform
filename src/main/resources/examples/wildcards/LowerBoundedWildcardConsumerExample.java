import java.util.ArrayList;
import java.util.List;

public class LowerBoundedWildcardConsumerExample {

    // List<? super Integer> accepts a List of Integer OR any of its
    // SUPERTYPES -- List<Integer>, List<Number>, List<Object> all qualify.
    // This method only ever WRITES into the list -- it CONSUMES values
    // from the caller -- which is exactly what "super" is for.
    static void addOneToFive(List<? super Integer> list) {
        for (int i = 1; i <= 5; i++) {
            list.add(i); // always safe: whatever the real type is, it can hold an Integer
        }

        // Integer first = list.get(0); // would NOT compile -- the
        //     compiler only knows the list holds SOME supertype of
        //     Integer, which could be as broad as Object.
        Object first = list.get(0); // reading back is only safe as Object
        System.out.println("first element read back as Object: " + first);
    }

    public static void main(String[] args) {
        List<Number> numbers = new ArrayList<>();
        addOneToFive(numbers); // List<Number> is a valid "supertype of Integer" list

        List<Object> objects = new ArrayList<>();
        addOneToFive(objects); // List<Object> works too

        System.out.println(numbers);
        System.out.println(objects);
    }
}
