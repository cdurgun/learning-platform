import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

import java.util.ArrayList;
import java.util.List;

// Combines everything from this lesson into one small system: a SINGLETON
// registry (shared state, seeded on startup via @PostConstruct, summarized on
// shutdown via @PreDestroy) handing out PROTOTYPE tickets -- a fresh,
// independent instance every time one is requested.
class ReservationRegistry {
    private final List<String> confirmedTickets = new ArrayList<>();
    private int nextTicketNumber;

    @PostConstruct
    void seed() {
        nextTicketNumber = 1000;
        System.out.println("ReservationRegistry ready, starting from ticket #" + nextTicketNumber);
    }

    synchronized int nextTicketNumber() {
        return nextTicketNumber++;
    }

    synchronized void confirm(String ticketId) {
        confirmedTickets.add(ticketId);
    }

    @PreDestroy
    void summarize() {
        System.out.println("Shutting down -- " + confirmedTickets.size() + " ticket(s) confirmed: " + confirmedTickets);
    }
}

class ReservationTicket {
    private final int ticketNumber;
    private final ReservationRegistry registry;

    ReservationTicket(ReservationRegistry registry) {
        this.registry = registry;
        this.ticketNumber = registry.nextTicketNumber();
    }

    void confirm(String customerName) {
        String ticketId = "T-" + ticketNumber;
        registry.confirm(ticketId);
        System.out.println(ticketId + " confirmed for " + customerName);
    }
}

@Configuration
class AppConfig {
    @Bean
    ReservationRegistry reservationRegistry() {
        return new ReservationRegistry();
    }

    @Bean
    @Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
    ReservationTicket reservationTicket(ReservationRegistry reservationRegistry) {
        return new ReservationTicket(reservationRegistry);
    }
}
