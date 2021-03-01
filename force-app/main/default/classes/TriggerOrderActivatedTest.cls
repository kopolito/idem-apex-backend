@IsTest
private class TriggerOrderActivatedTest {
	/**
	 * POSITIVE TEST FOR ACTIVATED ORDER TRIGGER
	 */
	@IsTest
	static void test_activatedOrdersWithProducts() {
		Account testAccount = TestDataFactory.createAccount('testAccount');
		Order testOrder = TestDataFactory.createOrderForAccount(testAccount, 5);
		testOrder.Status = 'Activated';

		Test.startTest();
		Database.SaveResult result = Database.update(testOrder);
		Test.stopTest();

		System.assertEquals(true, result.isSuccess(), 'update must be successful');
		System.assertEquals(0, result.getErrors().size(), 'must get no error');
	}
	/**
	 * NEGATIVE TEST FOR ACTIVATED ORDER TRIGGER
	 */
	@IsTest
	static void test_activatedOrdersWithoutProducts() {
		Account testAccount = TestDataFactory.createAccount('testAccount');
		Order testOrder = TestDataFactory.createOrderForAccount(testAccount, 0);
		testOrder.Status = 'Activated';

		Boolean success = false;
		Test.startTest();
		try {
			Database.SaveResult result = Database.update(testOrder);
		} catch (Exception z) {
			System.Assert(z.getMessage().contains('You must add Order Products'), 'euhhh');
			success = true;
		}
		Test.stopTest();

		System.assertEquals(true, success, 'update should have failed');
	}
	/**
	 * NEGATIVE TEST FOR UNACTIVATED ORDER TRIGGER
	 */
	@IsTest
	static void test_unactivatedOrders() {
		Account testAccount = TestDataFactory.createAccount('testAccount');
		Order testOrder = TestDataFactory.createOrderForAccount(testAccount, 0);
		testOrder.EffectiveDate = Date.today().addDays(5);

		Test.startTest();
		Database.SaveResult result = Database.update(testOrder);
		Test.stopTest();

		System.assertEquals(true, result.isSuccess(), 'update must be successful');
		System.assertEquals(0, result.getErrors().size(), 'must get no error');
	}
}
