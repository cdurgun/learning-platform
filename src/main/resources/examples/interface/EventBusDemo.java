class EventBusDemo {
    public static void main(String[] args) {
        EventBus bus = new EventBus();

        bus.subscribe(event -> System.out.println("[email] Order confirmed: " + event.orderId()));
        bus.subscribe(event -> {
            if (event.amount() > 500) {
                System.out.println("[fraud-check] High value order flagged: " + event.orderId());
            }
        });

        bus.publish(new OrderPlacedEvent("ORD-1001", 129.90));
        // [email] Order confirmed: ORD-1001

        bus.publish(new OrderPlacedEvent("ORD-1002", 899.00));
        // [email] Order confirmed: ORD-1002
        // [fraud-check] High value order flagged: ORD-1002
    }
}
