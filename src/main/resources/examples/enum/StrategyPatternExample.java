enum ShippingStrategy {
    STANDARD {
        @Override
        public double calculate(double weightKg) {
            return weightKg * 2.5;
        }
    },
    EXPRESS {
        @Override
        public double calculate(double weightKg) {
            return weightKg * 5.0 + 10;
        }
    },
    SAME_DAY {
        @Override
        public double calculate(double weightKg) {
            return weightKg * 8.0 + 25;
        }
    };

    public abstract double calculate(double weightKg);
}
