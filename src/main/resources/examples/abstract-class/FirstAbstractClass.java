abstract class Animal {
    protected String name;

    Animal(String name) {
        this.name = name;
    }

    abstract void makeSound();

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

class FirstAbstractClassDemo {
    public static void main(String[] args) {
        // Animal animal = new Animal("Generic"); // compile error: Animal is abstract; cannot be instantiated

        Dog dog = new Dog("Rex");
        dog.makeSound(); // Rex says: Woof!
        dog.sleep();     // Rex is sleeping... Zzz -- inherited straight from Animal
    }
}
