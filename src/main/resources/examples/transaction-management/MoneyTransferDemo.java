import org.springframework.context.annotation.AnnotationConfigApplicationContext;

class MoneyTransferDemo {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(MoneyTransferConfig.class);
        AccountRepository accounts = context.getBean(AccountRepository.class);
        MoneyTransferService transferService = context.getBean(MoneyTransferService.class);

        System.out.println(accounts.balanceOf("A") + " / " + accounts.balanceOf("B"));
        // 500 / 100

        transferService.transfer("A", "B", 200);
        System.out.println(accounts.balanceOf("A") + " / " + accounts.balanceOf("B"));
        // 300 / 300

        try {
            transferService.transfer("A", "B", 10_000);
        } catch (InsufficientFundsException e) {
            System.out.println("Failed: " + e.getMessage());
        }
        System.out.println(accounts.balanceOf("A") + " / " + accounts.balanceOf("B"));
        // 300 / 300  -- unchanged, debit(...) itself rolled back before credit
        // ever ran

        try {
            transferService.transferViaSelfInvocation("A", "B", 50);
        } catch (IllegalStateException e) {
            System.out.println("Failed: " + e.getMessage());
        }
        // Both debit and credit survive -- self-invocation meant
        // transferInternal's own @Transactional never actually applied (it was
        // called via `this`), so there was no outer transaction to roll back.
        // debit(...) and credit(...) still ran as their own, separate,
        // already-committed transactions (they were called on the injected
        // accountRepository bean, a real proxy, not via `this`).
        System.out.println(accounts.balanceOf("A") + " / " + accounts.balanceOf("B"));
        // 250 / 350

        context.close();
    }
}
