import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

class Money implements Comparable<Money> {
    int cents;

    Money(int cents) {
        this.cents = cents;
    }

    @Override
    public int compareTo(Money other) {
        return Integer.compare(this.cents, other.cents);
    }

    @Override
    public String toString() {
        return cents + " cents";
    }
}

class ComparableExample {
    public static void main(String[] args) {
        List<Money> wallet = new ArrayList<>();
        wallet.add(new Money(500));
        wallet.add(new Money(100));
        wallet.add(new Money(250));

        Collections.sort(wallet); // sort() only relies on compareTo() -- doesn't know Money exists
        System.out.println(wallet); // [100 cents, 250 cents, 500 cents]
    }
}
