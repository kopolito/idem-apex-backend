@IsTest
private class AccountInactiveBatchTest {
	private static Integer NB_TASKS = 5;
	@TestSetup
	static void makeData() {
		for (Integer i = 0; i < 5; i++) {
			TestDataFactory.createAccount('testAccount_' + i);
		}
	}
	/**
	 * POSITIVE TEST FOR ACCOUNT WITHOUT ORDER NEITHER RELATED TASK
	 */
	@IsTest
	static void test_AccountsInactive() {
		Test.startTest();
		Database.executeBatch(new AccountInactiveBatch());
		Test.stopTest();

		System.assertEquals(
			NB_TASKS,
			[SELECT COUNT() FROM Task WHERE Subject = 'Call'],
			'Reminder Tasks should have been created'
		);
	}

	/**
	 * NEGATIVE TEST FOR ACCOUNT WITH ORDER
	 */
	@IsTest
	static void test_AccountsWithOrder() {
		List<Account> accounts = [SELECT Id FROM Account];
		for (Account account : accounts) {
			TestDataFactory.createOrderForAccount(account, 5);
		}
		Test.startTest();
		Database.executeBatch(new AccountInactiveBatch());
		Test.stopTest();

		System.assertEquals(0, [SELECT COUNT() FROM Task WHERE Subject = 'Call'], 'Zero Reminder Tasks should exist');
	}
	/**
	 * NEGATIVE TEST FOR ACCOUNT WITH RELATED TASK
	 */
	@IsTest
	static void test_AccountsWithTask() {
		List<Account> accounts = [SELECT Id, OwnerId FROM Account];
		for (Account account : accounts) {
			TestDataFactory.createReminderTaskForAccount(account);
		}

		Test.startTest();
		Database.executeBatch(new AccountInactiveBatch());
		Test.stopTest();

		System.assertEquals(NB_TASKS, [SELECT COUNT() FROM Task], 'Bad Tasks count');
	}
}
