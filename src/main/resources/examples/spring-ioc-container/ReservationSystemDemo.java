import org.springframework.context.annotation.AnnotationConfigApplicationContext;

class ReservationSystemDemo {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        // ReservationRegistry ready, starting from ticket #1000

        ReservationTicket first = context.getBean(ReservationTicket.class);
        first.confirm("Ayse");
        // T-1000 confirmed for Ayse

        // A brand new ticket instance every time -- prototype scope in action.
        ReservationTicket second = context.getBean(ReservationTicket.class);
        second.confirm("Mehmet");
        // T-1001 confirmed for Mehmet

        System.out.println(first == second); // false

        context.close();
        // Shutting down -- 2 ticket(s) confirmed: [T-1000, T-1001]
    }
}
