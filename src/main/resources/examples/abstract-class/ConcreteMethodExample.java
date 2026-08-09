abstract class Animal {
    protected String name;

    Animal(String name) {
        this.name = name;
    }

    abstract void makeSound();

    // A CONCRETE method -- it has a body right here in the abstract class.
    // Every subclass gets this behavior for free and never has to write it
    // again, unlike makeSound(), which each subclass MUST provide itself.
    void sleep() {
        System.out.println(name + " is sleeping... Zzz");
    }
}

class Dog extends Animal {
    Dog(String name) {
        super(name);
    }

    @Override
    void makeSound() {
        System.out.println(name + " says: Woof!");
    }
}

class Cat extends Animal {
    Cat(String name) {
        super(name);
    }

    @Override
    void makeSound() {
        System.out.println(name + " says: Meow!");
    }
}

class ConcreteMethodExample {
    public static void main(String[] args) {
        Dog dog = new Dog("Rex");
        Cat cat = new Cat("Whiskers");

        dog.makeSound(); // Rex says: Woof!
        cat.makeSound();  // Whiskers says: Meow!

        // Neither Dog nor Cat wrote a single line of sleep() -- both reuse
        // the exact same inherited implementation.
        dog.sleep(); // Rex is sleeping... Zzz
        cat.sleep(); // Whiskers is sleeping... Zzz
    }
}
