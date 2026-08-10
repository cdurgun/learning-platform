class Animal {
    void makeSound() {
        System.out.println("Some generic animal sound");
    }
}

class Dog extends Animal {
    @Override
    void makeSound() {
        System.out.println("Woof!");
    }
}

class PolymorphismOverviewExample {
    // Compile-time polymorphism: the compiler picks ONE of these based on the argument's type
    static void print(String value) {
        System.out.println("String: " + value);
    }

    static void print(int value) {
        System.out.println("int: " + value);
    }

    public static void main(String[] args) {
        print("hello"); // resolved at COMPILE time -- calls print(String)
        print(42);      // resolved at COMPILE time -- calls print(int)

        Animal animal = new Dog();
        animal.makeSound(); // resolved at RUNTIME -- calls Dog's makeSound(), based on the real object
    }
}
