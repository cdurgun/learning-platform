class PluginRegistryDemo {
    public static void main(String[] args) {
        PluginRegistry registry = new PluginRegistry();
        registry.register("email", new EmailChannel());
        registry.register("sms", new SmsChannel());

        // A lambda works too — a functional interface plugin, registered
        // right at the call site, no separate class required.
        registry.register("console", message -> System.out.println("[console] " + message));

        registry.broadcast("Server restarting in 5 minutes");
        // [email] Server restarting in 5 minutes
        // [sms] Server restarting in 5 minutes
        // [console] Server restarting in 5 minutes

        registry.sendVia("sms", "Restart complete");
        // [sms] Restart complete
    }
}
