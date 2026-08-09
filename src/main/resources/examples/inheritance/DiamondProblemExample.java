interface Flyer {
    default String move() {
        return "flying";
    }
}

interface Swimmer {
    default String move() {
        return "swimming";
    }
}

// A class implementing both would inherit two conflicting move() defaults.
// Java refuses to guess -- it forces the class to resolve the conflict itself.
class Multi implements Flyer, Swimmer {
    @Override
    public String move() {
        // Flyer.super.move() / Swimmer.super.move() let you reach either default explicitly
        return Flyer.super.move() + " and " + Swimmer.super.move();
    }
}

class DiamondProblemExample {
    public static void main(String[] args) {
        Multi multi = new Multi();
        System.out.println(multi.move()); // flying and swimming
    }
}
