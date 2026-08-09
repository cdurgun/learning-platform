interface Nameable {
    String name();
}

// An interface can extend another interface (or, unlike a class, several at
// once) — it inherits the abstract methods and adds its own.
interface Describable extends Nameable {
    String description();

    default String fullLabel() {
        return name() + " - " + description();
    }
}

class Product implements Describable {
    private final String name;
    private final String description;

    Product(String name, String description) {
        this.name = name;
        this.description = description;
    }

    @Override
    public String name() {
        return name;
    }

    @Override
    public String description() {
        return description;
    }
}

class InterfaceExtendsExample {
    public static void main(String[] args) {
        Describable product = new Product("Keyboard", "Mechanical, RGB");
        System.out.println(product.fullLabel()); // Keyboard - Mechanical, RGB

        // A Describable is also a Nameable, exactly like class inheritance.
        Nameable nameable = product;
        System.out.println(nameable.name()); // Keyboard
    }
}
