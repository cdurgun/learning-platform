class DiscountStrategyDemo {
    public static void main(String[] args) {
        System.out.println(LegacyDiscountCalculator.calculateDiscountWithIfElse("VIP", 200)); // 40.0

        DiscountStrategy[] strategies = {
            new PercentageDiscount(0.20), // VIP-style
            new FlatDiscount(10),         // coupon-style
            new NoDiscount()              // no discount
        };

        for (DiscountStrategy strategy : strategies) {
            System.out.println(strategy.apply(200)); // 40.0 / 10.0 / 0.0
        }
    }
}
