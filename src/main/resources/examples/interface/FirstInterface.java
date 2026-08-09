interface Payable {
    double calculatePayment();
}

class Invoice implements Payable {
    private final double amount;

    Invoice(double amount) {
        this.amount = amount;
    }

    @Override
    public double calculatePayment() {
        return amount;
    }
}

class FirstInterfaceDemo {
    public static void main(String[] args) {
        Payable invoice = new Invoice(199.90);
        System.out.println(invoice.calculatePayment()); // 199.9
    }
}
