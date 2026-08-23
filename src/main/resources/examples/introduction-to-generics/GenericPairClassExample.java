public class GenericPairClassExample {

    // A generic class with TWO type parameters -- K and V here are just
    // names (by convention, K for "key", V for "value"); nothing forces
    // this specific naming beyond readability.
    static class Pair<K, V> {
        private final K key;
        private final V value;

        Pair(K key, V value) {
            this.key = key;
            this.value = value;
        }

        K getKey() {
            return key;
        }

        V getValue() {
            return value;
        }

        @Override
        public String toString() {
            return key + " = " + value;
        }
    }

    public static void main(String[] args) {
        Pair<String, Integer> ageEntry = new Pair<>("Alice", 30);
        Pair<Integer, String> idEntry = new Pair<>(101, "order-created");

        System.out.println(ageEntry);
        System.out.println(idEntry);
    }
}
