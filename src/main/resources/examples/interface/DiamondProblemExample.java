interface Flyer {
    default String move() {
        return "flying";
    }
}

interface Swimmer {
    default String move() {
        return "swimming";
    }
}

// Duck inherits two DIFFERENT default implementations of move() from two
// unrelated interfaces — the compiler refuses to guess which one you meant,
// so overriding move() here is mandatory, not optional.
class Duck implements Flyer, Swimmer {
    @Override
    public String move() {
        // Explicitly picking (and combining) both parents' behavior via
        // InterfaceName.super.method() — plain super.method() does not
        // work here, it's ambiguous the same way the field would be.
        return Flyer.super.move() + " and " + Swimmer.super.move();
    }
}

class DiamondProblemExample {
    public static void main(String[] args) {
        Duck duck = new Duck();
        System.out.println(duck.move()); // flying and swimming
    }
}
