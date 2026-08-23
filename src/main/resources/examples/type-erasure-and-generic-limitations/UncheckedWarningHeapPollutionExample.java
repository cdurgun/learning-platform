import java.util.ArrayList;
import java.util.List;

public class UncheckedWarningHeapPollutionExample {

    @SuppressWarnings({"unchecked", "rawtypes"})
    static void pollute(List list) { // a RAW type parameter -- no type
        // argument at all, so the compiler applies none of the checking
        // covered throughout this series to this method.
        list.add("not an Integer");
    }

    public static void main(String[] args) {
        List<Integer> numbers = new ArrayList<>();
        numbers.add(1);
        numbers.add(2);

        pollute(numbers); // compiles, because raw List accepts anything --
        //     this is exactly the pre-generics behavior "Introduction to
        //     Generics" opened with, still reachable today through a raw type.

        try {
            for (int n : numbers) { // fails here, not where the bad value
                //     was actually inserted -- the runtime cast happens at
                //     this read, far from the real mistake.
                System.out.println(n);
            }
        } catch (ClassCastException e) {
            System.out.println("blew up at read time: " + e.getMessage());
        }
    }
}
