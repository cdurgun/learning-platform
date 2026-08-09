// Fields declared in an interface are implicitly `public static final` —
// writing those modifiers yourself is redundant (though legal).
interface PhysicsConstants {
    double GRAVITY = 9.81;          // really: public static final double GRAVITY = 9.81;
    double SPEED_OF_LIGHT = 299_792_458;
}

class FreeFall implements PhysicsConstants {
    double distanceAfter(double seconds) {
        return 0.5 * GRAVITY * seconds * seconds;
    }
}

class InterfaceConstantsExample {
    public static void main(String[] args) {
        System.out.println(PhysicsConstants.GRAVITY);           // 9.81 — accessible without an instance
        System.out.println(new FreeFall().distanceAfter(2));    // 19.62
    }
}
