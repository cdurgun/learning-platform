import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.support.AbstractPlatformTransactionManager;
import org.springframework.transaction.support.DefaultTransactionStatus;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import java.util.ArrayList;
import java.util.List;

// A tiny in-memory "resource" standing in for a real database table, plus a
// custom PlatformTransactionManager that manages it. Real Spring Boot
// applications never write a class like this themselves -- Spring Boot's own
// auto-configuration registers a JpaTransactionManager/DataSourceTransactionManager
// for you (see the Auto-Configuration & Properties lesson). This project has no
// real database connection available in this environment, so instead we build
// the smallest possible *real* PlatformTransactionManager, purely so the
// examples in this lesson can genuinely run @Transactional/TransactionTemplate
// code with real commit/rollback/propagation behavior -- the same technique the
// Dependency Injection lesson used to hand-simulate a container before showing
// the real one.
//
// Writes made during an active transaction are buffered separately (never
// touching the committed state directly) and only merged in -- by appending,
// never by wholesale replacing -- when that specific transaction commits. This
// is what makes PROPAGATION_REQUIRES_NEW's independence actually work: a
// suspended outer transaction's own (still uncommitted) buffer is completely
// untouched by an inner transaction committing or rolling back, and vice versa.
class Ledger {
    private final List<String> committed = new ArrayList<>();

    void add(String entry) {
        currentBuffer().add(entry);
    }

    // Committed entries, plus whatever the CURRENT transaction (if any) has
    // written so far but not yet committed -- "read your own writes," the same
    // way a real database transaction sees its own uncommitted changes.
    List<String> entries() {
        List<String> visible = new ArrayList<>(committed);
        Object bound = TransactionSynchronizationManager.getResource(this);
        if (bound != null) {
            @SuppressWarnings("unchecked")
            List<String> buffer = (List<String>) bound;
            visible.addAll(buffer);
        }
        return List.copyOf(visible);
    }

    @SuppressWarnings("unchecked")
    private List<String> currentBuffer() {
        Object bound = TransactionSynchronizationManager.getResource(this);
        if (bound != null) {
            return (List<String>) bound;
        }
        // No active transaction -- write straight to the committed state.
        return committed;
    }

    // The following two methods are only ever called by LedgerTransactionManager.

    List<String> newBuffer() {
        return new ArrayList<>();
    }

    void applyBuffer(List<String> buffer) {
        committed.addAll(buffer);
    }
}

// Extending AbstractPlatformTransactionManager is the exact same extension
// point Spring's own DataSourceTransactionManager and JpaTransactionManager
// use -- we're just managing a plain in-memory list instead of a JDBC
// Connection/EntityManager. The pattern (bind a per-transaction buffer to the
// current thread via TransactionSynchronizationManager, keyed by the resource
// itself) mirrors how the real JDBC transaction manager tracks its Connection.
class LedgerTransactionManager extends AbstractPlatformTransactionManager {

    private final Ledger ledger;

    LedgerTransactionManager(Ledger ledger) {
        this.ledger = ledger;
    }

    // The "transaction object" -- created fresh for every getTransaction()
    // call, holding whatever this specific transaction needs to commit/detect
    // participation later.
    private static class LedgerTransaction {
        List<String> buffer;
        boolean newTransaction;
    }

    @Override
    protected Object doGetTransaction() {
        LedgerTransaction transaction = new LedgerTransaction();
        Object bound = TransactionSynchronizationManager.getResource(ledger);
        if (bound != null) {
            @SuppressWarnings("unchecked")
            List<String> existingBuffer = (List<String>) bound;
            transaction.buffer = existingBuffer;
        }
        return transaction;
    }

    @Override
    protected boolean isExistingTransaction(Object transaction) {
        // A thread already has a buffer bound -- REQUIRED will join it instead
        // of starting a new one.
        return ((LedgerTransaction) transaction).buffer != null;
    }

    @Override
    protected void doBegin(Object transactionObject, TransactionDefinition definition) {
        LedgerTransaction transaction = (LedgerTransaction) transactionObject;
        List<String> buffer = ledger.newBuffer();
        transaction.buffer = buffer;
        transaction.newTransaction = true;
        TransactionSynchronizationManager.bindResource(ledger, buffer);
    }

    @Override
    protected void doCommit(DefaultTransactionStatus status) {
        LedgerTransaction transaction = (LedgerTransaction) status.getTransaction();
        ledger.applyBuffer(transaction.buffer);
    }

    @Override
    protected void doRollback(DefaultTransactionStatus status) {
        // Nothing to do -- this transaction's buffer was never merged into the
        // committed state, so simply discarding it (in doCleanupAfterCompletion
        // below) is enough. Whatever other, independent transactions already
        // committed in the meantime (see PROPAGATION_REQUIRES_NEW) is untouched.
    }

    @Override
    protected void doCleanupAfterCompletion(Object transactionObject) {
        LedgerTransaction transaction = (LedgerTransaction) transactionObject;
        if (transaction.newTransaction) {
            TransactionSynchronizationManager.unbindResource(ledger);
        }
    }

    // REQUIRES_NEW needs to "suspend" whatever transaction is currently active
    // before starting a brand new one. Our resource is a single in-memory
    // object (not a pooled connection), so suspending is just unbinding the
    // current buffer -- there's no real external resource to detach.
    @Override
    protected Object doSuspend(Object transactionObject) {
        return TransactionSynchronizationManager.unbindResource(ledger);
    }

    @Override
    protected void doResume(Object transactionObject, Object suspendedResources) {
        TransactionSynchronizationManager.bindResource(ledger, suspendedResources);
    }
}
