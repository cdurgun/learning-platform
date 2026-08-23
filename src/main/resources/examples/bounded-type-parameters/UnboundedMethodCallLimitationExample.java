public class UnboundedMethodCallLimitationExample {

    // With an UNBOUNDED type parameter, the compiler only knows T could be
    // literally anything -- so the only methods it will let you call on a
    // T value are the ones every single Object has (toString, equals,
    // hashCode, ...). Nothing more specific is available.
    static <T> String describe(T value) {
        return value.toString(); // fine -- toString() belongs to Object

        // return value.doubleValue(); // would NOT compile -- the compiler
        //                                 has no idea T even has a
        //                                 doubleValue() method, because an
        //                                 unbounded T might not.
    }

    public static void main(String[] args) {
        System.out.println(describe(42));
        System.out.println(describe("hello"));
        System.out.println(describe(3.14));
    }
}
