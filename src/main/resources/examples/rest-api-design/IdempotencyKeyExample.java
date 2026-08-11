import java.util.HashMap;
import java.util.Map;

// IdempotentMethodsExample showed POST creating a new resource on every call -- a
// real problem when a client retries a request after a timeout, unsure whether the
// first attempt actually succeeded. The fix: the client generates a unique
// Idempotency-Key per logical operation and sends it with every retry; the server
// remembers which keys it has already processed and returns the SAME result instead
// of creating a duplicate.
class IdempotencyKeyExample {

    record OrderResult(String orderId, String status) {
    }

    static final Map<String, OrderResult> processedKeys = new HashMap<>();
    static int nextOrderNumber = 1;

    static OrderResult createOrder(String idempotencyKey, String item) {
        OrderResult existing = processedKeys.get(idempotencyKey);
        if (existing != null) {
            return existing; // same key seen before -- return the original result, create nothing
        }

        OrderResult result = new OrderResult("order-" + nextOrderNumber++, "CREATED: " + item);
        processedKeys.put(idempotencyKey, result);
        return result;
    }

    public static void main(String[] args) {
        String key = "a1b2c3-client-generated-uuid";

        OrderResult first = createOrder(key, "Java Mug");
        System.out.println(first);
        // OrderResult[orderId=order-1, status=CREATED: Java Mug]

        // The client didn't get a response in time (network blip) and retries with
        // the SAME key:
        OrderResult retry = createOrder(key, "Java Mug");
        System.out.println(retry);
        // OrderResult[orderId=order-1, status=CREATED: Java Mug] -- identical, no duplicate order

        // A genuinely new order uses a fresh key, and does create a new resource:
        OrderResult secondOrder = createOrder("d4e5f6-different-uuid", "Mechanical Keyboard");
        System.out.println(secondOrder);
        // OrderResult[orderId=order-2, status=CREATED: Mechanical Keyboard]
    }
}
