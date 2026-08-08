import java.util.EnumMap;
import java.util.Map;

class EnumMapExample {
    public static void main(String[] args) {
        EnumMap<DayWithMethod, String> plan = new EnumMap<>(DayWithMethod.class);
        plan.put(DayWithMethod.MONDAY, "Spring Boot çalış");
        plan.put(DayWithMethod.SATURDAY, "Dinlen");

        for (Map.Entry<DayWithMethod, String> entry : plan.entrySet()) {
            System.out.println(entry.getKey() + " -> " + entry.getValue());
        }
    }
}
