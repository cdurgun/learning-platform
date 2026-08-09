interface Auditable {
    String auditTrail();
}

// Combines an abstract class (shared state + a fixed charging algorithm)
// with an interface (an unrelated "can-do" contract, Auditable) --
// PaymentProcessor implements Auditable but, like Document in
// AbstractImplementsInterfaceExample.java, leaves it to its own concrete
// subclasses to actually provide auditTrail().
abstract class PaymentProcessor implements Auditable {
    protected double totalProcessed = 0;

    // final: every processor charges the exact same way -- amount plus
    // whatever fee its own calculateFee() decides on -- only the fee
    // formula itself varies per processor.
    final double charge(double amount) {
        double fee = calculateFee(amount);
        totalProcessed += amount;
        return amount + fee;
    }

    abstract double calculateFee(double amount);
}

class CreditCardProcessor extends PaymentProcessor {
    @Override
    double calculateFee(double amount) {
        return amount * 0.029;
    }

    @Override
    public String auditTrail() {
        return "CreditCard: total processed = " + totalProcessed;
    }
}

class BankTransferProcessor extends PaymentProcessor {
    @Override
    double calculateFee(double amount) {
        return 1.50; // flat fee, regardless of amount
    }

    @Override
    public String auditTrail() {
        return "BankTransfer: total processed = " + totalProcessed;
    }
}
