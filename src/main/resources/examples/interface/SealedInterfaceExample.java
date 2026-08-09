// A sealed interface names, up front, the complete and closed set of types
// allowed to implement it — no unknown fourth implementer can ever show up
// at runtime from some other package.
sealed interface PaymentMethod permits CreditCard, BankTransfer, CashOnDelivery {
}

record CreditCard(String cardNumber) implements PaymentMethod {
}

record BankTransfer(String iban) implements PaymentMethod {
}

final class CashOnDelivery implements PaymentMethod {
}

class SealedInterfaceExample {
    static String describe(PaymentMethod method) {
        // Because PaymentMethod is sealed, the compiler knows these three
        // branches are the ONLY possibilities — no `default` branch needed,
        // and adding a fourth implementer elsewhere would fail to compile
        // here until this switch is updated.
        return switch (method) {
            case CreditCard creditCard -> "Card ending in " + creditCard.cardNumber().substring(
                    creditCard.cardNumber().length() - 4);
            case BankTransfer bankTransfer -> "Transfer to " + bankTransfer.iban();
            case CashOnDelivery ignored -> "Cash on delivery";
        };
    }

    public static void main(String[] args) {
        System.out.println(describe(new CreditCard("4111111111111234")));
        System.out.println(describe(new BankTransfer("TR330006100519786457841326")));
        System.out.println(describe(new CashOnDelivery()));
    }
}
