class Animal {
    String label = "Animal";
}

class Dog extends Animal {
    String label = "Dog"; // hides Animal's label, does NOT override it
}

class FieldHidingExample {
    public static void main(String[] args) {
        Dog dog = new Dog();
        Animal animal = dog; // same object, viewed through a different static type

        System.out.println(animal.label); // Animal -- resolved by the STATIC type (Animal)
        System.out.println(dog.label);    // Dog    -- resolved by the STATIC type (Dog)
    }
}
