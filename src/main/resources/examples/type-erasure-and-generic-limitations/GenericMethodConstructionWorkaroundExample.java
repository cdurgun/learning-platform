import java.util.function.Supplier;

public class GenericMethodConstructionWorkaroundExample {

    // static <T> T createDefault() {
    //     return new T(); // would NOT compile -- because of erasure, at
    //         runtime the JVM has no idea what T actually is, so "new T()"
    //         has no real class to call a constructor on.
    // }

    // The common workaround: have the CALLER supply a way to create a T,
    // since only the caller actually knows what T is at that point.
    static <T> T createDefault(Supplier<T> factory) {
        return factory.get();
    }

    public static void main(String[] args) {
        String s = createDefault(String::new);
        StringBuilder sb = createDefault(StringBuilder::new);

        System.out.println("'" + s + "'");
        System.out.println("'" + sb + "'");
    }
}
