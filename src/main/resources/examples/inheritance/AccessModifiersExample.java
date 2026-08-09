class Base {
    public String publicField = "public";
    protected String protectedField = "protected";
    String packagePrivateField = "package-private"; // no modifier
    private String privateField = "private";

    private String getPrivateField() {
        return privateField;
    }

    protected String privateFieldViaGetter() {
        // A subclass cannot see privateField directly, but it CAN call this
        // protected getter, which is defined inside Base and has access.
        return getPrivateField();
    }
}

class Derived extends Base {
    void printAccessible() {
        System.out.println(publicField);              // OK -- public
        System.out.println(protectedField);            // OK -- protected, visible to subclasses
        System.out.println(packagePrivateField);       // OK -- same package (default package here)
        // System.out.println(privateField);           // compile error: privateField has private access in Base
        System.out.println(privateFieldViaGetter());   // OK -- goes through Base's own protected getter
    }
}

class AccessModifiersExample {
    public static void main(String[] args) {
        new Derived().printAccessible();
        // Note: if Derived lived in a DIFFERENT package than Base, packagePrivateField
        // would no longer compile -- package-private members are invisible across
        // package boundaries even to subclasses. protectedField would still work,
        // because `protected` is specifically designed to stay visible to subclasses
        // regardless of package.
    }
}
