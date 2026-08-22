public class ElseIfChainExample {
    public static void main(String[] args) {
        printGrade(95);
        printGrade(82);
        printGrade(71);
        printGrade(65);
        printGrade(40);
    }

    // Note: repeating this for a list of scores with a loop is exactly what
    // you'll learn in the "for Loop" lesson -- this topic keeps it loop-free.
    private static void printGrade(int score) {
        String grade;

        if (score >= 90) {
            grade = "A";
        } else if (score >= 80) {
            grade = "B";
        } else if (score >= 70) {
            grade = "C";
        } else if (score >= 60) {
            grade = "D";
        } else {
            grade = "F";
        }

        System.out.println("Score " + score + " -> Grade " + grade);
    }
}
