record Address(String city, String zip) {
}

record Employee(String name, Address address) {
}

class NestedPatternExample {

    static String describe(Object obj) {
        if (obj instanceof Employee(String name, Address(String city, String zip))) {
            return name + " - " + city + " (" + zip + ")";
        }
        return "unknown";
    }

    public static void main(String[] args) {
        Employee e = new Employee("Ada", new Address("Istanbul", "34000"));
        System.out.println(describe(e)); // Ada - Istanbul (34000)
    }
}
