class Animal {
}

class Dog extends Animal {
    void bark() {
        System.out.println("Woof!");
    }
}

class Cat extends Animal {
    void meow() {
        System.out.println("Meow!");
    }
}

class DowncastingExample {
    public static void main(String[] args) {
        Animal animal = new Dog(); // upcast first, as in the previous section

        if (animal instanceof Dog dog) {
            // pattern matching -- checks the type AND casts into `dog` in one step
            dog.bark(); // Woof!
        }

        Animal other = new Cat();
        if (other instanceof Dog otherDog) {
            otherDog.bark(); // never runs -- `other` is really a Cat
        } else {
            System.out.println("other is not a Dog"); // this branch runs instead
        }

        // Dog forced = (Dog) other; // compiles, but throws ClassCastException at runtime
    }
}
