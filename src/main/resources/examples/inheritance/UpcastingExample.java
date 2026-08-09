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

    void bark() {
        System.out.println("Extra loud woof!");
    }
}

class UpcastingExample {
    public static void main(String[] args) {
        Animal animal = new Dog(); // upcasting -- implicit, always safe

        animal.makeSound(); // Woof! -- runtime type (Dog) decides, not the static type (Animal)
        // animal.bark();   // compile error: bark() is not visible through an Animal reference

        Animal[] animals = { new Animal(), new Dog() };
        for (Animal a : animals) {
            a.makeSound(); // each element uses ITS OWN real implementation
        }
    }
}
