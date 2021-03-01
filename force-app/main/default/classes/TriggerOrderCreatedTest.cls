@IsTest
private class TriggerOrderCreatedTest {
	/**
	 * TEST FOR ACCOUNTS WITH CREATED ORDER
	 */
	@IsTest
	static void test_accountActivatedWhenOrderCreated() {
		Account testAccountWithOrder = TestDataFactory.createAccount('testAccountWithOrder');
		Account testAccountWithoutOrder = TestDataFactory.createAccount('testAccountWithoutOrder');

		Test.startTest();
		TestDataFactory.createOrderForAccount(testAccountWithoutOrder, 5);
		Test.stopTest();

		List<Account> accountsToTest = [SELECT Id FROM Account WHERE Active__c = TRUE];

		System.assertEquals(1, accountsToTest.size(), 'Account with Order should be Active');
	}
}
