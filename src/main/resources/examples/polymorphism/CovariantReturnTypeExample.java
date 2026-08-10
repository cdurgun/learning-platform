class Animal {
    Animal reproduce() {
        return new Animal();
    }
}

class Dog extends Animal {
    @Override
    Dog reproduce() { // covariant return type -- Dog is a subtype of Animal, this is legal
        return new Dog();
    }
}

class CovariantReturnTypeExample {
    public static void main(String[] args) {
        Dog dog = new Dog();
        Dog puppy = dog.reproduce(); // no cast needed -- reproduce() already returns Dog here
        System.out.println(puppy.getClass().getSimpleName()); // Dog
    }
}
