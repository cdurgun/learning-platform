interface Flyable {
    void fly();
}

interface Swimmable {
    void swim();
}

// A class can implement any number of interfaces — this is Java's answer to
// "multiple inheritance of type" (it only forbids multiple inheritance of
// STATE via `extends`, which classes are limited to one of).
class Duck implements Flyable, Swimmable {
    @Override
    public void fly() {
        System.out.println("The duck is flying");
    }

    @Override
    public void swim() {
        System.out.println("The duck is swimming");
    }
}

class MultipleInterfaceExample {
    public static void main(String[] args) {
        Duck duck = new Duck();
        duck.fly();
        duck.swim();

        // Each interface reference only sees its own contract.
        Flyable flyable = duck;
        flyable.fly();
    }
}
