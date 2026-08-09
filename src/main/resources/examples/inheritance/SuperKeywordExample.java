class Employee {
    protected String name;
    protected double baseSalary;

    Employee(String name, double baseSalary) {
        this.name = name;
        this.baseSalary = baseSalary;
    }

    String describe() {
        return name + " earns " + baseSalary;
    }
}

class Manager extends Employee {
    double bonus;

    Manager(String name, double baseSalary, double bonus) {
        super(name, baseSalary); // super(...) -- calls Employee's constructor
        this.bonus = bonus;
    }

    @Override
    String describe() {
        // super.describe() -- calls Employee's original describe(), builds on top of it
        return super.describe() + " plus a bonus of " + bonus;
    }

    double totalCompensation() {
        // super.baseSalary -- direct access to the inherited field
        return super.baseSalary + bonus;
    }
}

class SuperKeywordExample {
    public static void main(String[] args) {
        Manager manager = new Manager("Ada", 5000, 1000);
        System.out.println(manager.describe());           // Ada earns 5000.0 plus a bonus of 1000.0
        System.out.println(manager.totalCompensation());  // 6000.0
    }
}
