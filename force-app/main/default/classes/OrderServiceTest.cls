@IsTest
private class OrderServiceTest {
	// POSITIVE TEST FOR ACTIVATED ORDERS CHECK
	@IsTest
	static void test_checkActivatedOrdersWithProducts() {
		Account testAccount = TestDataFactory.createAccount('testAccount');
		List<Order> ordersToCheck = new List<Order>();
		for (Integer i = 0; i < 5; i++) {
			ordersToCheck.add(TestDataFactory.createOrderForAccount(testAccount, 5));
		}
		for (Order order : ordersToCheck) {
			order.Status = 'Activated';
		}

		Test.startTest();
		OrderService.checkActivatedOrders(ordersToCheck);
		Test.stopTest();

		for (Order order : ordersToCheck) {
			System.assertEquals(false, order.hasErrors(), 'Order should not have error');
		}
	}
	// NEGATIVE TEST FOR ACTIVATED ORDERS CHECK
	@IsTest
	static void test_checkActivatedOrdersWithoutProducts() {
		Account testAccount = TestDataFactory.createAccount('testAccount');
		List<Order> ordersToCheck = new List<Order>();
		for (Integer i = 0; i < 5; i++) {
			ordersToCheck.add(TestDataFactory.createOrderForAccount(testAccount, 0));
		}
		for (Order order : ordersToCheck) {
			order.Status = 'Activated';
		}

		Test.startTest();
		OrderService.checkActivatedOrders(ordersToCheck);
		Test.stopTest();

		for (Order order : ordersToCheck) {
			System.assertEquals(true, order.hasErrors(), 'Order should have error');
			System.assertEquals('You must add Order Products', order.getErrors()[0].message, 'Bad error message');
		}
	}
	/**
	 * TEST FOR ACCOUNTS WITH CREATED ORDERS CHECK
	 */
	@IsTest
	static void test_accountActivatedWhenOrderCreated() {
		Account testAccountWithOrder = TestDataFactory.createAccount('testAccountWithOrder');
		Account testAccountWithoutOrder = TestDataFactory.createAccount('testAccountWithoutOrder');

		List<Order> ordersToCheck = new List<Order>();
		for (Integer i = 0; i < 5; i++) {
			ordersToCheck.add(TestDataFactory.createOrderForAccount(testAccountWithOrder, 5));
		}

		Test.startTest();
		OrderService.setOrdersAccountsActive(ordersToCheck);
		Test.stopTest();

		List<Account> accountsToTest = [SELECT Id FROM Account WHERE Active__c = TRUE];

		System.assertEquals(1, accountsToTest.size(), 'Account shoud be Active');
	}
}
