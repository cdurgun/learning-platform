// Mini project, part 2/2: calls IdempotentOrderController.createOrder directly --
// once, then a "retry" with the same Idempotency-Key -- and shows the status code
// difference (201 vs. 200) alongside the identical order id.
class IdempotentOrderDemo {

    public static void main(String[] args) {
        IdempotentOrderController controller = new IdempotentOrderController();
        var request = new IdempotentOrderController.CreateOrderRequest("Java Mug");

        var first = controller.createOrder("a1b2c3-client-generated-uuid", request);
        System.out.println(first.getStatusCode() + " " + first.getBody());
        // 201 CREATED OrderResponse[orderId=order-1, item=Java Mug]

        var retry = controller.createOrder("a1b2c3-client-generated-uuid", request);
        System.out.println(retry.getStatusCode() + " " + retry.getBody());
        // 200 OK OrderResponse[orderId=order-1, item=Java Mug]  -- same order, not a duplicate

        var secondOrder = controller.createOrder("d4e5f6-different-uuid",
                new IdempotentOrderController.CreateOrderRequest("Mechanical Keyboard"));
        System.out.println(secondOrder.getStatusCode() + " " + secondOrder.getBody());
        // 201 CREATED OrderResponse[orderId=order-2, item=Mechanical Keyboard]
    }
}
