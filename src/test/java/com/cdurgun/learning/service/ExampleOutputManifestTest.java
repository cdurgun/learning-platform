package com.cdurgun.learning.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HexFormat;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * "Beklenen Çıktı" dosyalarının ({@code examples/{slug}/{Ad}.out}) bayatlık koruması. Hiçbir
 * örnek çalıştırılmaz; yalnızca dosyalar ve {@code scripts/example-outputs/manifest.tsv}
 * karşılaştırılır. Yayındaki her {@code .out} için:
 * <ul>
 *   <li>aynı adlı bir {@code .java} kardeşi vardır (yetim çıktı yok),</li>
 *   <li>manifest'te bir satırı vardır ve o satır insan incelemesinden geçmiştir
 *       ({@code review = approved}),</li>
 *   <li>{@code .java}'nın güncel hash'i, çıktı üretildiğindeki hash'le aynıdır -- kod
 *       değiştiyse eski çıktı geçersizdir: ya yeniden üretilip incelenir ya da silinir,</li>
 *   <li>{@code .out}'un güncel hash'i manifest'tekiyle aynıdır -- çıktı elle değiştirilmemiştir,</li>
 *   <li>örnekle birlikte derlenen dosyalar ({@code companions} sütunu) durur ve hash'leri aynıdır --
 *       çıktıyı onların kodu da üretir.</li>
 * </ul>
 * Manifest'te dosyası olmayan satır da hatadır. Bu test çıktının DOĞRU olduğunu kanıtlamaz;
 * o, inceleme adımının işidir.
 */
class ExampleOutputManifestTest {

    private static final Path EXAMPLES = Path.of("src/main/resources/examples");
    private static final Path MANIFEST = Path.of("scripts/example-outputs/manifest.tsv");
    private static final String HEADER =
            "slug\texample\tjava_sha256\tout_sha256\tjdk_image\torigin\treview\treviewer\treviewed_at\tnote\tcompanions";

    @Test
    void everyPublishedOutputIsReviewedAndMatchesItsSource() throws IOException {
        assertThat(problems(EXAMPLES, MANIFEST)).isEmpty();
    }

    @Test
    void manifestKeepsItsHeader() throws IOException {
        assertThat(Files.readAllLines(MANIFEST, StandardCharsets.UTF_8).get(0)).isEqualTo(HEADER);
    }

    // --- checker behaviour, against throwaway directories -------------------------------

    @Test
    void approvedOutputWithMatchingHashesPasses(@TempDir Path root) throws IOException {
        Fixture f = new Fixture(root);
        f.example("demo", "Hello", "class Hello {}", "hi\n");
        f.row("demo", "Hello", "approved");

        assertThat(f.problems()).isEmpty();
    }

    @Test
    void changedJavaSourceInvalidatesTheOutput(@TempDir Path root) throws IOException {
        Fixture f = new Fixture(root);
        f.example("demo", "Hello", "class Hello {}", "hi\n");
        f.row("demo", "Hello", "approved");
        Files.writeString(f.examples.resolve("demo/Hello.java"), "class Hello { int changed; }");

        assertThat(f.problems()).singleElement().asString().contains("demo/Hello").contains("java changed");
    }

    @Test
    void handEditedOutputIsDetected(@TempDir Path root) throws IOException {
        Fixture f = new Fixture(root);
        f.example("demo", "Hello", "class Hello {}", "hi\n");
        f.row("demo", "Hello", "approved");
        Files.writeString(f.examples.resolve("demo/Hello.out"), "hi \n");

        assertThat(f.problems()).singleElement().asString().contains("out changed");
    }

    @Test
    void outputWithoutAManifestRowIsRejected(@TempDir Path root) throws IOException {
        Fixture f = new Fixture(root);
        f.example("demo", "Hello", "class Hello {}", "hi\n");

        assertThat(f.problems()).singleElement().asString().contains("no manifest row");
    }

    @Test
    void unreviewedOutputIsRejected(@TempDir Path root) throws IOException {
        Fixture f = new Fixture(root);
        f.example("demo", "Hello", "class Hello {}", "hi\n");
        f.row("demo", "Hello", "pending");

        assertThat(f.problems()).singleElement().asString().contains("not approved");
    }

    @Test
    void orphanOutputIsRejected(@TempDir Path root) throws IOException {
        Fixture f = new Fixture(root);
        Files.createDirectories(f.examples.resolve("demo"));
        Files.writeString(f.examples.resolve("demo/Ghost.out"), "boo\n");

        assertThat(f.problems()).anySatisfy(p -> assertThat(p).contains("demo/Ghost").contains("no Ghost.java"));
    }

    @Test
    void manifestRowWithoutItsOutputIsRejected(@TempDir Path root) throws IOException {
        Fixture f = new Fixture(root);
        f.example("demo", "Hello", "class Hello {}", "hi\n");
        f.row("demo", "Hello", "approved");
        Files.delete(f.examples.resolve("demo/Hello.out"));

        assertThat(f.problems()).singleElement().asString().contains("manifest row without");
    }

    @Test
    void outputWithItsCompanionPasses(@TempDir Path root) throws IOException {
        Fixture f = new Fixture(root);
        f.example("demo", "Usage", "class Usage {}", "hi\n");
        f.companion("demo", "Day", "enum Day { MON }");
        f.row("demo", "Usage", "approved", "Day");

        assertThat(f.problems()).isEmpty();
    }

    @Test
    void changedCompanionInvalidatesTheOutput(@TempDir Path root) throws IOException {
        Fixture f = new Fixture(root);
        f.example("demo", "Usage", "class Usage {}", "hi\n");
        f.companion("demo", "Day", "enum Day { MON }");
        f.row("demo", "Usage", "approved", "Day");
        Files.writeString(f.examples.resolve("demo/Day.java"), "enum Day { MON, TUE }");

        assertThat(f.problems()).singleElement().asString()
                .contains("demo/Usage").contains("companion Day.java changed");
    }

    @Test
    void missingCompanionIsRejected(@TempDir Path root) throws IOException {
        Fixture f = new Fixture(root);
        f.example("demo", "Usage", "class Usage {}", "hi\n");
        f.companion("demo", "Day", "enum Day { MON }");
        f.row("demo", "Usage", "approved", "Day");
        Files.delete(f.examples.resolve("demo/Day.java"));

        assertThat(f.problems()).singleElement().asString().contains("companion Day.java is missing");
    }

    @Test
    void malformedCompanionCellIsRejected(@TempDir Path root) throws IOException {
        Fixture f = new Fixture(root);
        f.example("demo", "Usage", "class Usage {}", "hi\n");
        f.row("demo", "Usage", "approved");
        f.replaceLastCell("Day.java");

        assertThat(f.problems()).singleElement().asString().contains("malformed companions");
    }

    @Test
    void rowWithoutTheCompanionsColumnIsRejected(@TempDir Path root) throws IOException {
        Fixture f = new Fixture(root);
        f.example("demo", "Usage", "class Usage {}", "hi\n");
        f.row("demo", "Usage", "approved");
        f.dropLastCell();

        assertThat(f.problems()).singleElement().asString().contains("expected 11 columns");
    }

    // --- checker -----------------------------------------------------------------------

    static List<String> problems(Path examples, Path manifest) throws IOException {
        Map<String, String[]> rows = new HashMap<>();
        List<String> lines = Files.readAllLines(manifest, StandardCharsets.UTF_8);
        for (String line : lines.subList(1, lines.size())) {
            if (!line.isBlank()) {
                String[] cols = line.split("\t", -1);
                rows.put(cols[0] + "/" + cols[1], cols);
            }
        }

        List<String> problems = new ArrayList<>();
        List<Path> outputs;
        try (Stream<Path> files = Files.walk(examples)) {
            outputs = files.filter(p -> p.getFileName().toString().endsWith(".out")).sorted().toList();
        }
        for (Path out : outputs) {
            String name = out.getFileName().toString().replaceFirst("\\.out$", "");
            String key = out.getParent().getFileName() + "/" + name;
            Path java = out.resolveSibling(name + ".java");
            String[] row = rows.remove(key);
            if (!Files.isRegularFile(java)) {
                problems.add(key + ": no " + name + ".java next to the output");
            }
            if (row == null) {
                problems.add(key + ": no manifest row");
                continue;
            }
            if (row.length != 11) {
                problems.add(key + ": expected 11 columns, found " + row.length);
                continue;
            }
            if (!"approved".equals(row[6])) {
                problems.add(key + ": not approved (review = " + row[6] + ")");
            }
            if (Files.isRegularFile(java) && !sha256(java).equals(row[2])) {
                problems.add(key + ": java changed since the output was generated -- regenerate and review, or delete the .out");
            }
            if (!sha256(out).equals(row[3])) {
                problems.add(key + ": out changed since it was reviewed");
            }
            problems.addAll(companionProblems(key, out, row[10]));
        }
        rows.keySet().forEach(key -> problems.add(key + ": manifest row without a .out file"));
        return problems;
    }

    private static List<String> companionProblems(String key, Path out, String cell) throws IOException {
        List<String> problems = new ArrayList<>();
        if (cell.isEmpty()) {
            return problems;
        }
        for (String entry : cell.split(",", -1)) {
            String[] parts = entry.split(":", -1);
            if (parts.length != 2 || parts[0].isEmpty() || parts[1].isEmpty()) {
                problems.add(key + ": malformed companions entry '" + entry + "'");
                continue;
            }
            Path companion = out.resolveSibling(parts[0]);
            if (!Files.isRegularFile(companion)) {
                problems.add(key + ": companion " + parts[0] + " is missing");
            } else if (!sha256(companion).equals(parts[1])) {
                problems.add(key + ": companion " + parts[0]
                        + " changed since the output was generated -- regenerate and review, or delete the .out");
            }
        }
        return problems;
    }

    private static String sha256(Path file) throws IOException {
        try {
            return HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256").digest(Files.readAllBytes(file)));
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(e);
        }
    }

    private static final class Fixture {
        final Path examples;
        final Path manifest;
        final List<String> rows = new ArrayList<>(List.of(HEADER));

        Fixture(Path root) {
            this.examples = root.resolve("examples");
            this.manifest = root.resolve("manifest.tsv");
        }

        void example(String slug, String name, String java, String out) throws IOException {
            Path dir = Files.createDirectories(examples.resolve(slug));
            Files.writeString(dir.resolve(name + ".java"), java);
            Files.writeString(dir.resolve(name + ".out"), out);
        }

        void companion(String slug, String name, String java) throws IOException {
            Files.writeString(Files.createDirectories(examples.resolve(slug)).resolve(name + ".java"), java);
        }

        void row(String slug, String name, String review, String... companions) throws IOException {
            Path dir = examples.resolve(slug);
            List<String> cells = new ArrayList<>();
            for (String companion : companions) {
                cells.add(companion + ".java:" + sha256(dir.resolve(companion + ".java")));
            }
            rows.add(String.join("\t", slug, name, sha256(dir.resolve(name + ".java")),
                    sha256(dir.resolve(name + ".out")), "image", "generated", review, "reviewer", "2026-10-18", "",
                    String.join(",", cells)));
        }

        void replaceLastCell(String value) {
            String last = rows.remove(rows.size() - 1);
            rows.add(last.substring(0, last.lastIndexOf('\t') + 1) + value);
        }

        void dropLastCell() {
            String last = rows.remove(rows.size() - 1);
            rows.add(last.substring(0, last.lastIndexOf('\t')));
        }

        List<String> problems() throws IOException {
            Files.writeString(manifest, String.join("\n", rows) + "\n");
            return ExampleOutputManifestTest.problems(examples, manifest);
        }
    }
}
