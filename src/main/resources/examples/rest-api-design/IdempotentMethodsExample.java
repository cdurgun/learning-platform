import java.util.HashMap;
import java.util.Map;

// An operation is idempotent when calling it once has the same effect as calling it
// N times. Mapping Annotations and HTTP Methods already introduced idempotent
// as a property of GET/PUT/DELETE -- this example proves it by actually calling each
// operation twice and checking the store ends up in the same state either way.
class IdempotentMethodsExample {

    static final Map<String, String> store = new HashMap<>();

    static void put(String key, String value) {
        store.put(key, value); // PUT: replaces whatever was there -- same result every time
    }

    static void delete(String key) {
        store.remove(key); // DELETE: removing something already gone is still "gone" -- same result
    }

    static String post(String value) {
        // POST: creates a NEW resource every time -- calling it twice is NOT the same
        // as calling it once.
        String id = "id-" + (store.size() + 1);
        store.put(id, value);
        return id;
    }

    public static void main(String[] args) {
        store.clear();

        put("topic-1", "Advanced Spring MVC");
        put("topic-1", "Advanced Spring MVC"); // calling PUT again
        System.out.println(store);
        // {topic-1=Advanced Spring MVC} -- calling it twice left the exact same state

        delete("topic-1");
        delete("topic-1"); // calling DELETE on something already gone
        System.out.println(store.containsKey("topic-1"));
        // false either way -- both calls end in the same state

        store.clear();
        String firstId = post("REST API Design");
        String secondId = post("REST API Design"); // calling POST again
        System.out.println(firstId + " != " + secondId + " -> " + store);
        // id-1 != id-2 -> {id-1=REST API Design, id-2=REST API Design}
        // two calls created two resources -- POST is NOT idempotent by default
    }
}
