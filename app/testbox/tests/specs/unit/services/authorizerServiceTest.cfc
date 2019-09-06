/**
 * Question... 
 * Why do i have to sent the return type to any (3rd parameter = false) for these methods?  
 * Why does it think the return type should be a string?
 * Am I missing something when I set up my models? I tried setting the type attribute but, no dice.
 */
component extends="testbox.system.BaseSpec" {
	function run() {

		describe("The authorizer service", function() {
			beforeEach(function(){
				authorizerService = createMock("services.authorizerService");
			});

			describe("checks if the current user", function() {
				beforeEach(function(){
					currentUser = createMock("beans.user")
						.$("getId",1)
						.$("getUserName", "testUser");
					otherUser = createMock("beans.user")
						.$("getId",2)
						.$("getUserName", "otherUser");
					authorizerService.$("getUserService",
						createMock("services.user")
							.$("getCurrentUser", currentUser, false), false);
				});

				describe("is authorized to access a given transaction", function() {
					beforeEach( function() {
						account = createMock("beans.account");
						transaction = createMock("beans.transaction")
							.$("getAccount",account, false);
					});

					it("throws an error if they do not have access to the transaction", function() {
						account.$("getUser", otherUser, false);
						expect(function(){
							authorizerService.authorizeByTransaction(transaction);
						}).toThrow("UnauthorizedUser");
					});

					it("does not throw and error if they do have access to the transaction", function() {
						account.$("getUser", currentUser, false);
						authorizerService.authorizeByTransaction(transaction);
					});

				});

				describe("is authorized to access a given account", function() {
					beforeEach( function() {
						account = createMock("beans.account");
					});

					it("throws an error if they do not have access to the account", function() {
						account.$("getUser", otherUser, false);
						expect(function(){
							authorizerService.authorizeByAccount(account);
						}).toThrow("UnauthorizedUser");
					});

					it("does not throw and error if they do have access to the account", function() {
						account.$("getUser", currentUser, false);
						authorizerService.authorizeByAccount(account);
					});
				});
				
			});
		});
	}
}
