public class MultipleTypeParametersMethodExample {

    // A method can declare as many type parameters as it needs, separated
    // by commas, exactly like a generic class can -- K and V here are
    // completely independent of each other and get deduced separately.
    static <K, V> String describeEntry(K key, V value) {
        return key + " -> " + value;
    }

    public static void main(String[] args) {
        System.out.println(describeEntry("age", 30));         // K=String, V=Integer
        System.out.println(describeEntry(101, "order-created")); // K=Integer, V=String
        System.out.println(describeEntry(true, 3.14));         // K=Boolean, V=Double
    }
}
