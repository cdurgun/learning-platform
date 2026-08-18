import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.util.Scanner;

public class ScannerVsBufferedReaderPerformanceExample {
    public static void main(String[] args) throws IOException {
        int lineCount = 50_000;
        StringBuilder textBuilder = new StringBuilder();
        for (int i = 0; i < lineCount; i++) {
            textBuilder.append("line-").append(i).append('\n');
        }
        String text = textBuilder.toString();

        // Warm-up -- run both paths a lot before measuring.
        for (int i = 0; i < 50; i++) {
            readWithScanner(text);
            readWithBufferedReader(text);
        }

        long scannerStart = System.nanoTime();
        int scannerLines = readWithScanner(text);
        long scannerNanos = System.nanoTime() - scannerStart;

        long readerStart = System.nanoTime();
        int readerLines = readWithBufferedReader(text);
        long readerNanos = System.nanoTime() - readerStart;

        System.out.println("Reading " + lineCount + " lines:");
        System.out.println("  Scanner.nextLine(): " + (scannerNanos / 1_000_000) + " ms (" + scannerLines + " lines)");
        System.out.println("  BufferedReader.readLine(): " + (readerNanos / 1_000_000) + " ms (" + readerLines + " lines)");
        System.out.println("(Scanner does regex-based token matching under the hood -- convenient for parsing");
        System.out.println(" typed tokens (nextInt(), nextDouble()...), but that flexibility costs raw speed.");
        System.out.println(" BufferedReader.readLine() just reads raw lines, with no parsing -- much faster");
        System.out.println(" when all you need is the text itself.)");
    }

    private static int readWithScanner(String text) {
        int lines = 0;
        Scanner scanner = new Scanner(text);
        while (scanner.hasNextLine()) {
            scanner.nextLine();
            lines++;
        }
        scanner.close();
        return lines;
    }

    private static int readWithBufferedReader(String text) throws IOException {
        int lines = 0;
        try (BufferedReader reader = new BufferedReader(new StringReader(text))) {
            while (reader.readLine() != null) {
                lines++;
            }
        }
        return lines;
    }
}
