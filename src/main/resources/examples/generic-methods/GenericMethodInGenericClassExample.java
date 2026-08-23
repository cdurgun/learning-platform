public class GenericMethodInGenericClassExample {

    // Container<T> is a generic CLASS -- T belongs to the class itself,
    // fixed once for the whole instance (Container<String> means every T
    // in this instance is a String).
    static class Container<T> {
        private final T value;

        Container(T value) {
            this.value = value;
        }

        T getValue() {
            return value;
        }

        // combineWith declares its OWN type parameter, U -- completely
        // separate from the class's T. A single Container<String> instance
        // can call combineWith with an Integer, a Boolean, anything --
        // U is decided fresh on every call, independent of what T is.
        <U> String combineWith(U other) {
            return value + " + " + other;
        }
    }

    public static void main(String[] args) {
        Container<String> box = new Container<>("hello");

        System.out.println(box.combineWith(42));     // U = Integer
        System.out.println(box.combineWith(true));    // U = Boolean
        System.out.println(box.combineWith("world")); // U = String, unrelated to T being String too
    }
}
