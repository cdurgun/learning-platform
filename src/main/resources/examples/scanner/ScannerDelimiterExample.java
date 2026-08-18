import java.util.Scanner;

public class ScannerDelimiterExample {
    public static void main(String[] args) {
        // By default the delimiter is whitespace -- useDelimiter() lets you
        // change it to any regex, which turns Scanner into a simple tokenizer
        // for structured text like CSV.
        String csvLine = "apple, banana,  cherry ,date";
        Scanner csvScanner = new Scanner(csvLine);
        csvScanner.useDelimiter("\\s*,\\s*"); // comma, optionally surrounded by spaces

        System.out.print("CSV fields: ");
        while (csvScanner.hasNext()) {
            System.out.print("[" + csvScanner.next() + "] ");
        }
        System.out.println();
        csvScanner.close();

        // A regex delimiter can be much richer than a single character -- here,
        // any run of non-digit characters separates the numbers.
        String messyNumbers = "12abc34##56   78xyz90";
        Scanner numberScanner = new Scanner(messyNumbers);
        numberScanner.useDelimiter("[^0-9]+");

        System.out.print("Extracted numbers: ");
        while (numberScanner.hasNextInt()) {
            System.out.print(numberScanner.nextInt() + " ");
        }
        System.out.println();
        numberScanner.close();
    }
}
