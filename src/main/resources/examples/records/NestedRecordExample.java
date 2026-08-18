record Address(String city, String zip) {
}

record Employee(String name, Address address) {
}

class NestedRecordExampleUsage {
    public static void main(String[] args) {
        Employee e1 = new Employee("Ada", new Address("Istanbul", "34000"));
        Employee e2 = new Employee("Ada", new Address("Istanbul", "34000"));

        System.out.println(e1);              // Employee[name=Ada, address=Address[city=Istanbul, zip=34000]]
        System.out.println(e1.equals(e2));    // true — the nested Address.equals() is used too
        System.out.println(e1.address().city()); // Istanbul
    }
}
