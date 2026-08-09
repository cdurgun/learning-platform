class PaymentProcessorDemo {
    public static void main(String[] args) {
        PaymentProcessor creditCard = new CreditCardProcessor();
        System.out.println(creditCard.charge(100)); // 102.9
        System.out.println(creditCard.auditTrail()); // CreditCard: total processed = 100.0

        PaymentProcessor bankTransfer = new BankTransferProcessor();
        System.out.println(bankTransfer.charge(500)); // 501.5
        System.out.println(bankTransfer.auditTrail()); // BankTransfer: total processed = 500.0

        // Both are used purely through the PaymentProcessor/Auditable
        // contracts here -- neither variable's declared type ever mentions
        // CreditCardProcessor or BankTransferProcessor directly.
    }
}
