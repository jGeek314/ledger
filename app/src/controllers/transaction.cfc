component name="account" output="false"  accessors=true {

    property accountService;
    property transactionService;
    property transactionDataService;
    property categoryService;
    property transferService;
    property alertService;
    property checkbookSummaryService;
	property authorizerService;
	property metaDataService;
    
    public void function init(fw){
        variables.fw=arguments.fw;
    }

    public void function before( required struct rc ){
		param name="rc.returnTo" default="#variables.fw.getSectionAndItem()#";
		runAuthorizer(rc);
		updateLayoutAndView();
    }

    public void function after( struct rc = {} ){
        rc.accounts = accountService.getAccounts();
    }

	private void function runAuthorizer(required struct rc) {
		var methodName = variables.fw.getItem();
		if (!metaDataService.methodHasAnnotation(this, methodName, "authorizer")) {
			throw(type="missingauthorizer", message="#methodName# of the transaction service is missing an authorizer");
		}

		var authorizer = metaDataService.getMethodAnnotation(this, methodName, "authorizer");
		invoke(this, authorizer, {rc:rc});
	}

	private void function updateLayoutAndView(){
		var methodName = variables.fw.getItem();
		if (metaDataService.methodHasAnnotation(this, methodName, "layout")) {
			variables.fw.setLayout(metaDataService.getMethodAnnotation(this, methodName, "layout"));
		}
		if (metaDataService.methodHasAnnotation(this, methodName, "view")) {
			variables.fw.setView(metaDataService.getMethodAnnotation(this, methodName, "view"));
		}
	}

    /**
     * @authorizer "authorizeByAccountId"
     * @layout "account"
     */
    public void function newTransaction( struct rc = {} ){
        rc.account = accountService.getAccountByID(rc.accountid);
        rc.transaction = transactionService.createTransaction(rc.account);
        rc.transactions = transactionDataService.getTransactionData(rc.account);
        rc.categories = categoryService.getCategories();
        variables.update(rc);
    }

    /**
     * @authorizer "authorizeByAccountId"
     * @layout "account"
     */
    public void function edit( struct rc = {} ){
        rc.formAction = "transaction.edit";
        rc.transaction = transactionService.getTransactionById(rc.transactionid);
        rc.account = rc.transaction.getAccount();
        rc.categories = categoryService.getCategories(rc.transaction);
        variables.update(rc);
    }

    /**
     * @authorizer "authorizeByAccountId"
     * @layout "account"
     */
    public void function verify( struct rc = {} ){
        
        if (!rc.keyExists('includeSubaccounts') || !len(rc.includeSubaccounts)) {
            rc.includeSubaccounts = false;
        }
        rc.account = accountService.getAccountById(rc.accountid);
        rc.unverifiedTransactions = transactionService.getUnverifiedTransactions(rc.account, rc.includeSubaccounts);
        rc.verifiedTransactions = transactionService.getVerifiedTransactions(rc.account, rc.includeSubaccounts);
        rc.lastVerifiedId = transactionService.getLastVerifiedID(rc.account);
    }

    /**
     * @authorizer "authorizeByTransactionId"
     * @layout "account"
     */
    public void function deleteTransaction(required struct rc){
        var transaction = transactionService.getTransactionById(rc.transactionId);
        transactionService.deleteTransaction(transaction);
        checkbookSummaryService.transferSummaryRounding();
        variables.fw.redirect(action='transaction.#rc.returnTo#', append="accountid");
    }

    /**
     * @authorizer "authorizeByTransactionId"
     * @view "main.jsonresponse"
     */
    public void function clear( struct rc = {} ){
        var transaction = transactionService.getTransactionById(rc.transactionId);
        var account = transaction.getAccount();

        transactionService.verifyTransaction(transaction);

        rc.jsonResponse.verifiedLinkedBalance = account.getVerifiedLinkedBalance();
        rc.jsonResponse.lastVerifiedId = transactionService.getLastVerifiedID(account);
    }

    /**
     * @authorizer "authorizeByTransactionId"
     * @view "main.jsonresponse"
     */
    public void function undo( struct rc = {} ){
        var transaction = transactionService.getTransactionById(rc.transactionId);
        var account = transaction.getAccount();
        
        transactionService.unverifyTransaction(transaction);

        rc.jsonResponse.verifiedLinkedBalance = account.getVerifiedLinkedBalance();
        rc.jsonResponse.lastVerifiedId = transactionService.getLastVerifiedID(account);
    }



    private void function update( required struct rc ){
        var transaction = rc.transaction;
        var errors = [];

        if (StructKeyExists(rc,'submitTransaction')){
            variables.fw.populate(transaction);
            transaction.setCategory(categoryService.getCategoryById(rc.category));
            if (rc.keyExists('newAccountId')) {
                transaction.setAccount(accountService.getAccountById(rc.newAccountId));
            }
            errors = transaction.validate();

            if (arrayLen(errors)){
                alertService.setTitle("danger","Please correct the follow errors:");
                alertService.addMultiple("danger",errors);
            } else {
                transactionService.saveTransaction(transaction);
                checkbookSummaryService.transferSummaryRounding();
                rc.lastTransactionid = transaction.getid();
                variables.fw.redirect(action='transaction.#rc.returnTo#', append="lastTransactionid,accountid");
            }
        }
    }

    private void function authorizeByTransactionId( required struct rc ) {
        if(!rc.keyExists('transactionId')) {
            variables.fw.redirect('main.accountsList');
            return;
        }
        var transaction = transactionService.getTransactionById(rc.transactionId);
        authorizerService.authorizeByTransaction(transaction);
	}
	
	private void function authorizeByAccountId (required struct rc ) {
		if(!rc.keyExists('accountId')) {
            variables.fw.redirect('main.accountsList');
            return;
        }
        var account = accountService.getAccountById(rc.accountId);
        authorizerService.authorizeByAccount(account);
	}
}