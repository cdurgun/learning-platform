class EmployeeHierarchyDemo {
    public static void main(String[] args) {
        Employee[] employees = {
            new Employee("Ada", 4000),
            new Manager("Grace", 6000, 1500),
            new Developer("Linus", 5000, 10)
        };

        for (Employee e : employees) {
            System.out.println(e.describe());
        }
        // Ada: base salary 4000.0
        // Grace: base salary 6000.0, team bonus 1500.0, total 7500.0
        // Linus: base salary 5000.0, overtime 10h, total 5500.0
    }
}
