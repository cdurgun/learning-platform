class RequestRouterDemo {
    public static void main(String[] args) {
        RequestRouterSimulation router = new RequestRouterSimulation();
        router.register(new HomeHandlers());
        router.register(new CartHandlers());

        System.out.println(router.dispatch("/"));
        // Welcome to the store
        System.out.println(router.dispatch("/cart"));
        // Your cart is empty
        System.out.println(router.dispatch("/cart/checkout"));
        // Redirecting to checkout
        System.out.println(router.dispatch("/unknown"));
        // 404 Not Found: /unknown

        System.out.println("Registered paths: " + router.registeredPaths().size());
        // Registered paths: 3
    }
}
