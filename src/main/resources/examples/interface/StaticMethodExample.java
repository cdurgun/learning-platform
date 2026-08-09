interface DiscountPolicy {
    double apply(double price);

    // A static method belongs to the interface itself, not to any
    // implementer — it can never be overridden and is always called as
    // DiscountPolicy.xxx(), never through an instance.
    static DiscountPolicy percentageOff(double percent) {
        return price -> price * (1 - percent / 100);
    }

    static DiscountPolicy none() {
        return price -> price;
    }
}

class StaticMethodExample {
    public static void main(String[] args) {
        DiscountPolicy blackFriday = DiscountPolicy.percentageOff(30);
        System.out.println(blackFriday.apply(100.0)); // 70.0

        DiscountPolicy noDiscount = DiscountPolicy.none();
        System.out.println(noDiscount.apply(100.0)); // 100.0
    }
}
