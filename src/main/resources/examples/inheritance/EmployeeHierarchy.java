class Employee {
    String name;
    double baseSalary;

    Employee(String name, double baseSalary) {
        this.name = name;
        this.baseSalary = baseSalary;
    }

    double calculateSalary() {
        return baseSalary;
    }

    String describe() {
        return name + ": base salary " + baseSalary;
    }
}

class Manager extends Employee {
    double teamBonus;

    Manager(String name, double baseSalary, double teamBonus) {
        super(name, baseSalary);
        this.teamBonus = teamBonus;
    }

    @Override
    double calculateSalary() {
        return baseSalary + teamBonus;
    }

    @Override
    String describe() {
        return super.describe() + ", team bonus " + teamBonus + ", total " + calculateSalary();
    }
}

class Developer extends Employee {
    int overtimeHours;
    static final double OVERTIME_RATE = 50.0;

    Developer(String name, double baseSalary, int overtimeHours) {
        super(name, baseSalary);
        this.overtimeHours = overtimeHours;
    }

    @Override
    double calculateSalary() {
        return baseSalary + (overtimeHours * OVERTIME_RATE);
    }

    @Override
    String describe() {
        return super.describe() + ", overtime " + overtimeHours + "h, total " + calculateSalary();
    }
}
