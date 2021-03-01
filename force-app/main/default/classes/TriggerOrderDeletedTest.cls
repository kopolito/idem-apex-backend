@IsTest
private class TriggerOrderDeletedTest {
	/**
	 * TEST FOR ACCOUNTS WITH DELETED ORDER
	 */
	@IsTest
	static void test_accountActivatedWhenOrderDeleted() {
		Account testAccountWithOrder = TestDataFactory.createAccount('testAccountWithOrder');
		Account testAccountWithoutOrder = TestDataFactory.createAccount('testAccountWithoutOrder');
		Order testOrder = TestDataFactory.createOrderForAccount(testAccountWithOrder, 5);

		Test.startTest();
		List<Account> accountsToTest = [SELECT Id FROM Account WHERE Active__c = TRUE];
		System.assertEquals(1, accountsToTest.size(), 'Account should be Active');

		delete testOrder;
		Test.stopTest();

		accountsToTest = [SELECT Id FROM Account WHERE Active__c = TRUE];
		System.assertEquals(0, accountsToTest.size(), 'Account should be Inactive');
	}
}
