class Animal {
    String name;

    Animal(String name) {
        this.name = name;
    }

    String describe() {
        return name + " makes some sound";
    }
}

class Dog extends Animal {
    Dog(String name) {
        super(name);
    }

    @Override
    String describe() {
        return name + " barks";
    }
}

class Cat extends Animal {
    Cat(String name) {
        super(name);
    }

    @Override
    String describe() {
        return name + " meows";
    }
}

class InstanceofDesignExample {
    // Brittle: every new Animal subtype means editing this method again
    static String describeWithInstanceof(Animal animal) {
        if (animal instanceof Dog dog) {
            return dog.name + " barks";
        } else if (animal instanceof Cat cat) {
            return cat.name + " meows";
        } else {
            return animal.name + " makes some sound";
        }
    }

    // Polymorphic: adding a new subtype never requires touching this method
    static String describeWithPolymorphism(Animal animal) {
        return animal.describe();
    }

    public static void main(String[] args) {
        Animal[] animals = { new Dog("Rex"), new Cat("Whiskers") };

        for (Animal a : animals) {
            System.out.println(describeWithInstanceof(a));
            System.out.println(describeWithPolymorphism(a));
        }
    }
}
