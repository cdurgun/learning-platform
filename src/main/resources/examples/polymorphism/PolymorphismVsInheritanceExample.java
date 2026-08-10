class Animal {
    void makeSound() {
        System.out.println("Some generic animal sound");
    }
}

class Cat extends Animal {
    // inherits makeSound() as-is -- no override, so no real polymorphism here
}

class Dog extends Animal {
    @Override
    void makeSound() {
        System.out.println("Woof!"); // overridden -- this IS polymorphism
    }
}

class PolymorphismVsInheritanceExample {
    public static void main(String[] args) {
        Animal cat = new Cat();
        cat.makeSound(); // Some generic animal sound -- inheritance without polymorphism

        Animal dog = new Dog();
        dog.makeSound(); // Woof! -- inheritance WITH polymorphism
    }
}
