import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;
import java.util.function.Supplier;

// Consumer<T>: accept(T) -> void -- represents a side effect performed WITH a value,
// no result comes back. Supplier<T>: get() -> T -- represents producing a value with
// NO input at all, evaluated only when get() is actually called.
class ConsumerSupplierExample {
    public static void main(String[] args) {
        Consumer<String> print = System.out::println;
        Consumer<String> printUpper = s -> System.out.println(s.toUpperCase());

        // andThen() chains two consumers -- both run, in order, on the SAME input.
        Consumer<String> printBoth = print.andThen(printUpper);
        printBoth.accept("hi");

        // Supplier defers work until get() is actually called -- useful for values
        // that are expensive to build and might not even be needed.
        Supplier<List<String>> newList = ArrayList::new;
        List<String> list = newList.get();
        list.add("a");
        System.out.println(list);
    }
}
