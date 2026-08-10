import java.util.Objects;

// A second, different domain to show the same ideas hold generally -- not
// just for notifications. PaymentProcessor requires a PaymentGateway
// (constructor injection, see "Neden Constructor Injection Öneriliyor?"),
// and accepts an OPTIONAL FraudChecker that may legitimately be null -- a
// reminder that not every collaborator needs Objects.requireNonNull.
interface PaymentGateway {
    boolean charge(String cardNumber, double amount);
}

class CreditCardGateway implements PaymentGateway {
    @Override
    public boolean charge(String cardNumber, double amount) {
        System.out.printf("[credit card] Charged %.2f TL to card ending in %s%n",
                amount, cardNumber.substring(cardNumber.length() - 4));
        return true;
    }
}

interface FraudChecker {
    boolean looksSuspicious(double amount);
}

class ThresholdFraudChecker implements FraudChecker {
    private final double threshold;

    ThresholdFraudChecker(double threshold) {
        this.threshold = threshold;
    }

    @Override
    public boolean looksSuspicious(double amount) {
        return amount > threshold;
    }
}

class PaymentProcessor {
    private final PaymentGateway gateway;
    private final FraudChecker fraudChecker; // may be null -- genuinely optional

    PaymentProcessor(PaymentGateway gateway, FraudChecker fraudChecker) {
        this.gateway = Objects.requireNonNull(gateway, "gateway must not be null");
        this.fraudChecker = fraudChecker;
    }

    boolean process(String cardNumber, double amount) {
        if (fraudChecker != null && fraudChecker.looksSuspicious(amount)) {
            System.out.println("[fraud-check] Blocked a suspicious payment of " + amount + " TL");
            return false;
        }
        return gateway.charge(cardNumber, amount);
    }
}
