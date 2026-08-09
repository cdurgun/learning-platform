class Animal {
    String name;

    Animal(String name) {
        this.name = name;
    }

    void eat() {
        System.out.println(name + " is eating");
    }
}

class Dog extends Animal {
    Dog(String name) {
        super(name);
    }

    void bark() {
        System.out.println(name + " says: Woof!");
    }
}

class FirstInheritanceExample {
    public static void main(String[] args) {
        Dog dog = new Dog("Rex");
        dog.eat();  // inherited from Animal
        dog.bark(); // Dog's own method
    }
}
