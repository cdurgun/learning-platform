class LegacyDiscountCalculator {
    // The brittle version: every new customer type means editing this method
    static double calculateDiscountWithIfElse(String customerType, double amount) {
        if (customerType.equals("VIP")) {
            return amount * 0.20;
        } else if (customerType.equals("REGULAR")) {
            return amount * 0.05;
        } else {
            return 0.0;
        }
    }
}

interface DiscountStrategy {
    double apply(double amount);
}

class PercentageDiscount implements DiscountStrategy {
    private double percentage;

    PercentageDiscount(double percentage) {
        this.percentage = percentage;
    }

    @Override
    public double apply(double amount) {
        return amount * percentage;
    }
}

class FlatDiscount implements DiscountStrategy {
    private double flatAmount;

    FlatDiscount(double flatAmount) {
        this.flatAmount = flatAmount;
    }

    @Override
    public double apply(double amount) {
        return Math.min(flatAmount, amount);
    }
}

class NoDiscount implements DiscountStrategy {
    @Override
    public double apply(double amount) {
        return 0.0;
    }
}
