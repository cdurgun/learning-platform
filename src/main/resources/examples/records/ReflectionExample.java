import java.lang.reflect.RecordComponent;

record Score2(String player, int points) {
}

class ReflectionExample {
    public static void main(String[] args) {
        Class<Score2> type = Score2.class;

        System.out.println(type.isRecord()); // true

        for (RecordComponent component : type.getRecordComponents()) {
            System.out.println(component.getName() + " : " + component.getType().getSimpleName());
        }
        // player : String
        // points : int
    }
}
