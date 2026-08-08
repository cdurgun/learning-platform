package com.cdurgun.learning.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Bir kod örneğinin metadata'sı. Dosya yolu DB'de saklanmaz — convention ile bulunur:
 * {@code examples/{topic.slug}/{exampleName}.java}. Markdown içinde
 * {@code {{exampleName.java}}} yazılarak dosyanın içeriği sayfaya gömülür.
 */
@Entity
@Table(name = "code_example", uniqueConstraints = @UniqueConstraint(columnNames = {"topic_id", "example_name"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CodeExample {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "topic_id", nullable = false)
    private Topic topic;

    @Column(nullable = false)
    private String title;

    @Column(name = "example_name", nullable = false)
    private String exampleName;

    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder;
}
