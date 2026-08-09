interface Invoice {
    double subtotal();

    double taxRate();

    // Two default methods share the same rounding logic. Extracting that
    // logic into a `private` method (Java 9+) lets them reuse it without
    // exposing it as part of the interface's public API.
    default double totalWithTax() {
        return round(subtotal() * (1 + taxRate()));
    }

    default double taxAmount() {
        return round(subtotal() * taxRate());
    }

    private double round(double value) {
        return Math.round(value * 100.0) / 100.0;
    }
}

class SimpleInvoice implements Invoice {
    private final double subtotal;
    private final double taxRate;

    SimpleInvoice(double subtotal, double taxRate) {
        this.subtotal = subtotal;
        this.taxRate = taxRate;
    }

    @Override
    public double subtotal() {
        return subtotal;
    }

    @Override
    public double taxRate() {
        return taxRate;
    }
}

class PrivateMethodExample {
    public static void main(String[] args) {
        Invoice invoice = new SimpleInvoice(199.99, 0.18);
        System.out.println(invoice.taxAmount());    // 36.0
        System.out.println(invoice.totalWithTax()); // 236.0
    }
}
