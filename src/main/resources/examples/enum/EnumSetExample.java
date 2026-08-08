import java.util.EnumSet;

class EnumSetExample {
    public static void main(String[] args) {
        EnumSet<DayWithMethod> weekend = EnumSet.of(DayWithMethod.SATURDAY, DayWithMethod.SUNDAY);
        EnumSet<DayWithMethod> weekdays = EnumSet.complementOf(weekend);

        System.out.println("Hafta sonu: " + weekend);
        System.out.println("Hafta içi: " + weekdays);
    }
}
