public class SwitchBasicsExample {
    public static void main(String[] args) {
        int day = 3;
        String name;

        switch (day) {
            case 1:
                name = "Monday";
                break;
            case 2:
                name = "Tuesday";
                break;
            case 3:
                name = "Wednesday";
                break;
            default:
                name = "Unknown";
                break;
        }

        System.out.println("Day " + day + " -> " + name);
    }
}
