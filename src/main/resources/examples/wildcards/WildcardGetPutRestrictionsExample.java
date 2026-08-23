import java.util.List;

public class WildcardGetPutRestrictionsExample {

    // A side-by-side look at exactly what each wildcard form allows,
    // using the SAME two operations (read an element, add an element) on
    // each -- this is the "get and put" rule the rest of this lesson
    // builds on.
    static void demonstrate(List<? extends Number> producer,
                             List<? super Integer> consumer,
                             List<?> unknown) {

        // GET is safe on "? extends" -- every element really is at least a Number.
        Number value = producer.get(0);
        // producer.add(1); // NOT allowed -- the real type could be narrower than Integer

        // PUT is safe on "? super" -- Integer fits into any supertype of Integer.
        consumer.add(99);
        // Integer fromConsumer = consumer.get(0); // NOT allowed -- could only be read as Object

        // Neither is reliably safe on "?" -- only Object-level reads, and
        // no inserts at all (except the literal null, which fits every type).
        Object anything = unknown.get(0);
        unknown.add(null); // the one and only value that fits ANY element type
        // unknown.add("x"); // NOT allowed -- the real element type is unknown
    }

    public static void main(String[] args) {
        List<Integer> ints = new java.util.ArrayList<>(List.of(1, 2, 3));
        List<Number> nums = new java.util.ArrayList<>(List.of(1, 2, 3));
        demonstrate(ints, nums, ints);
        System.out.println(ints);
        System.out.println(nums);
    }
}
