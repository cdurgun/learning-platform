abstract class Employee {
    // `protected` -- visible to subclasses (even in other packages), but not
    // part of the public API. This is the access level abstract classes
    // typically use for state that subclasses are expected to read directly.
    protected String name;
    protected double baseSalary;

    Employee(String name, double baseSalary) {
        this.name = name;
        this.baseSalary = baseSalary;
    }

    abstract double calculateSalary();
}

class Manager extends Employee {
    private final double bonus;

    Manager(String name, double baseSalary, double bonus) {
        super(name, baseSalary);
        this.bonus = bonus;
    }

    @Override
    double calculateSalary() {
        // Reads baseSalary directly -- it's inherited state, not something
        // Manager has to ask for through a getter.
        return baseSalary + bonus;
    }
}

class FieldsExample {
    public static void main(String[] args) {
        Manager manager = new Manager("Ada", 5000, 1500);
        System.out.println(manager.calculateSalary()); // 6500.0
    }
}
