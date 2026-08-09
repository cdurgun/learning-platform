abstract class Animal {
    protected String name;

    Animal(String name) {
        this.name = name;
    }

    abstract void makeSound();
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

class Bird extends Animal {
    Bird(String name) {
        super(name);
    }

    @Override
    void makeSound() {
        System.out.println(name + " says: Tweet!");
    }
}

class OverridingAndPolymorphismExample {
    public static void main(String[] args) {
        // Polymorphism through the abstract type reference: the loop below
        // never needs to know whether each element is a Dog, a Cat, or a
        // Bird -- it only knows it's holding an Animal.
        Animal[] animals = { new Dog("Rex"), new Cat("Whiskers"), new Bird("Tweety") };

        for (Animal animal : animals) {
            animal.makeSound();
        }
        // Rex says: Woof!
        // Whiskers says: Meow!
        // Tweety says: Tweet!
    }
}
