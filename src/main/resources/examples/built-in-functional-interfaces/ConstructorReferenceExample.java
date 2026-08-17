import java.util.ArrayList;
import java.util.List;
import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.function.Supplier;

record Point(int x, int y) {
}

// Class::new -- refers to a constructor. Which overload gets picked (no-arg, one-arg,
// two-arg...) is decided by target typing, exactly like any other method reference.
class ConstructorReferenceExample {
    public static void main(String[] args) {
        Supplier<List<String>> newList = ArrayList::new; // matches the no-arg constructor
        System.out.println(newList.get());

        Function<String, StringBuilder> newBuilder = StringBuilder::new; // one-arg constructor
        System.out.println(newBuilder.apply("hi"));

        // Works for user-defined types too -- a record's canonical constructor is
        // just a constructor, like any other.
        BiFunction<Integer, Integer, Point> newPoint = Point::new;
        System.out.println(newPoint.apply(3, 4));
    }
}
