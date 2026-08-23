import java.util.List;

public class TypeInferenceExample {

    static <T> T firstElement(List<T> list) {
        return list.get(0);
    }

    public static void main(String[] args) {
        List<String> names = List.of("Alice", "Bob");

        // Normally, the compiler infers T entirely from the argument --
        // no need to spell it out.
        String inferred = firstElement(names);

        // The same call, but with an explicit TYPE WITNESS: the compiler
        // is told exactly what T is instead of figuring it out. This is
        // rarely necessary -- it exists for the (uncommon) cases where
        // there isn't enough information at the call site for inference
        // to work out T on its own.
        String explicit = TypeInferenceExample.<String>firstElement(names);

        System.out.println(inferred);
        System.out.println(explicit);
    }
}
