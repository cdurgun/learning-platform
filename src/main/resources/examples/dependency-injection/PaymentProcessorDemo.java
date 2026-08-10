class PaymentProcessorDemo {
    public static void main(String[] args) {
        // With fraud checking enabled.
        PaymentProcessor guarded = new PaymentProcessor(new CreditCardGateway(), new ThresholdFraudChecker(5000));
        guarded.process("4242424242424242", 250.00);
        // [credit card] Charged 250.00 TL to card ending in 4242
        guarded.process("4242424242424242", 8000.00);
        // [fraud-check] Blocked a suspicious payment of 8000.0 TL

        // Without a fraud checker at all -- perfectly legal, since it is optional.
        PaymentProcessor unguarded = new PaymentProcessor(new CreditCardGateway(), null);
        unguarded.process("4242424242424242", 8000.00);
        // [credit card] Charged 8000.00 TL to card ending in 4242

        // A fake gateway swapped in, exactly like "Dependency Injection ve Test
        // Edilebilirlik" -- no real payment provider involved.
        PaymentGateway fakeGateway = (cardNumber, amount) -> {
            System.out.println("[fake] Pretending to charge " + amount + " TL, no real network call made.");
            return true;
        };
        PaymentProcessor testable = new PaymentProcessor(fakeGateway, null);
        testable.process("4242424242424242", 100.00);
        // [fake] Pretending to charge 100.0 TL, no real network call made.
    }
}
