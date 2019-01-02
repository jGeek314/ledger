component displayName="Account Balance Calculations" extends="testbox.system.BaseSpec" {
    
    private component function setupTestTransactionsAndGetAccount() {
        var transactionGenerator = new generators.transaction(); 
        var parentAccount = new generators.account();
        var subAccount = new generators.account({linkedAccount: parentAccount});
        parentAccount.addTransactions( transactionGenerator.generateTransaction( {amount: '1.01', verifiedDate:'2000-01-01' } ));
        parentAccount.addTransactions( transactionGenerator.generateTransaction( {amount: '2.06', verifiedDate:'2000-01-01' } ));
        parentAccount.addTransactions( transactionGenerator.generateTransaction( {amount: '3.00'} ));
        subAccount.addTransactions( transactionGenerator.generateTransaction( {amount: '10.50', verifiedDate:'2000-01-01' } ));
        subAccount.addTransactions( transactionGenerator.generateTransaction( {amount: '12.51', verifiedDate:'2000-01-01' } ));
        subAccount.addTransactions( transactionGenerator.generateTransaction( {amount: '13.11'} ));
        ormFlush();
        return parentAccount;
    }

    function getBalanceTest() {
        transaction {
            var account = setupTestTransactionsAndGetAccount();
            $assert.isEqual(-6.07, account.getBalance());
            transaction action="rollback";
        }
    }

    function getVerifiedBalanceTest() {
        transaction {
            var account = setupTestTransactionsAndGetAccount();
            $assert.isEqual(-3.07, account.getVerifiedBalance());
            transaction action="rollback";
        }
    }

    function getLinkedBalanceTest() {
        transaction {
            var account = setupTestTransactionsAndGetAccount();
            $assert.isEqual(-42.19, account.getLinkedBalance());
            transaction action="rollback";
        }
    }

    function getVerifiedLinkedBalanceTest() {
        transaction {
            var account = setupTestTransactionsAndGetAccount();
            $assert.isEqual(-26.08, account.getVerifiedLinkedBalance());
            transaction action="rollback";
        }
    }

}