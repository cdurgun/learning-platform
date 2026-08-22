public class MultipleVariablesForExample {
    public static void main(String[] args) {
        // A for loop's init and update sections can each hold more than one
        // statement, separated by commas -- useful for two variables that
        // move together, like scanning from both ends toward the middle.
        int[] numbers = {10, 20, 30, 40, 50, 60, 70};

        for (int left = 0, right = numbers.length - 1; left < right; left++, right--) {
            System.out.println("left=" + left + " (" + numbers[left] + "), right=" + right + " (" + numbers[right] + ")");
        }

        // Checking whether an array is a palindrome uses the exact same pattern.
        int[] palindrome = {1, 2, 3, 2, 1};
        boolean isPalindrome = true;

        for (int left = 0, right = palindrome.length - 1; left < right; left++, right--) {
            if (palindrome[left] != palindrome[right]) {
                isPalindrome = false;
                break;
            }
        }

        System.out.println("Is palindrome: " + isPalindrome);
    }
}
