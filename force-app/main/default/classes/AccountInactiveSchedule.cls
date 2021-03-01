global without sharing class AccountInactiveSchedule implements Schedulable {
	global void execute(SchedulableContext ctx) {
		AccountInactiveBatch accountCheckBatch = new AccountInactiveBatch();
		Id batchId = Database.executeBatch(accountCheckBatch);
	}
}
