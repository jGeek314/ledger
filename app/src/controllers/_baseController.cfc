component name="_baseController" output="false"  accessors=true {

	property accountService;
	property alertService;
	property authorizerService;
	property categoryService;
	property checkbookSummaryService;
	property eventGeneratorService;
	property metaDataService;
    property transactionDataService;
    property transactionService;
    property transferService;
	property schedularService;
	property validatorService;
	
	public void function before( required struct rc ){
		runAuthorizer(rc);
	}
	
	private void function runAuthorizer(required struct rc) {
		var methodName = variables.fw.getItem();
		if (!metaDataService.methodHasAnnotation(this, methodName, "authorizer")) {
			throw(type="missingauthorizer", message="#methodName# of the transaction service is missing an authorizer");
			return;
		}

		var authorizer = metaDataService.getMethodAnnotation(this, methodName, "authorizer");
		var authorizerArguments = {rc:rc};
		if (metaDataService.methodHasAnnotation(this, methodName, "authorizerField")) {
			authorizerArguments.authorizerField =  metaDataService.getMethodAnnotation(this, methodName, "authorizerField");
		}
		invoke(this, authorizer, authorizerArguments);
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

	private void function runRenderData(required struct rc) {
		var methodName = variables.fw.getItem();
		if (metaDataService.methodHasAnnotation(this, methodName, "renderData")) {
			if (!rc.keyExists('response')) {
				throw(type="missingResponse", message="Response does not exist in request context.  Unable to render data");
			}
			variables.fw.renderData().data( rc.response ).type( metaDataService.getMethodAnnotation(this, methodName, "renderData"));
		}
	}

	private void function noAuthorizer() {
		return;
	}

	private void function authorizeByTransactionId( required struct rc ) {
		checkAuthKeyInRequest(rc, 'transactionId');
		authorizerService.authorizeByTransactionId(rc.transactionId);
	}
	
	private void function authorizeByAccountId (required struct rc, string authorizerField ) {
		var field = arguments.authorizerField ?: 'accountId';
		checkAuthKeyInRequest(rc, field);
        authorizerService.authorizeByAccountId(rc[field]);
	}

	private void function authorizeByEventGeneratorId (required struct rc ) {
		checkAuthKeyInRequest(rc, 'eventGeneratorId');
    	authorizerService.authorizeByEventGeneratorId(rc.eventGeneratorId);
	}
	
	private void function checkAuthKeyInRequest (required struct rc, required string varName) {
		if (!rc.keyExists(varName)){
			throw(type="missingAuthorizerKey", message="The variable #varname# is required to authorize the action but it was not provided in the request scope.");
		}
	}
}