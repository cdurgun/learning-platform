package com.cdurgun.learning.service.ai;

import java.util.List;
import java.util.Objects;

/** Modele sırasıyla gönderilecek mesajlar (sistem, ders bağlamı, geçmiş, yeni soru). */
public record TutorPrompt(List<Message> messages) {

    public TutorPrompt {
        Objects.requireNonNull(messages, "messages");
        if (messages.isEmpty()) {
            throw new IllegalArgumentException("messages must not be empty");
        }
        messages = List.copyOf(messages);
    }

    /** Araç (tool) rolü bilerek yok: Faz 1'de modele hiçbir araç verilmez. */
    public enum Role {
        SYSTEM, USER, ASSISTANT
    }

    public record Message(Role role, String content) {

        public Message {
            Objects.requireNonNull(role, "role");
            Objects.requireNonNull(content, "content");
        }
    }
}
