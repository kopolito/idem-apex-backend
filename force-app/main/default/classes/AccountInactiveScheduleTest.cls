@IsTest
private class AccountInactiveScheduleTest {
	@IsTest
	static void testScheduledJob() {
		String cronExp = '0 0 0 3 9 ? 2099';
		// NB: test data not needed, because we're not testing Apex Batch results
		// That will be tested somewhere else

		// Verify that AsyncApexJob is empty
		// not strictly necessary but makes what is going on later clearer
		List<AsyncApexJob> jobsBefore = [SELECT Id FROM AsyncApexJob];
		System.assertEquals(0, jobsBefore.size(), 'not expecting any asyncjobs');

		Test.startTest();
		String jobId = System.schedule('AccountInactiveScheduleTest', cronExp, new AccountInactiveSchedule());
		Test.stopTest();

		// There will now be two things in AsyncApexJob - the Schedulable itself
		// and also the Batch Apex job. This code looks for both of them

		// Check schedulable is in the job list
		List<AsyncApexJob> jobsScheduled = [
			SELECT Id, ApexClass.Name
			FROM AsyncApexJob
			WHERE JobType = 'ScheduledApex'
		];
		System.assertEquals(1, jobsScheduled.size(), 'expecting one scheduled job');
		System.assertEquals(
			'AccountInactiveSchedule',
			jobsScheduled[0].ApexClass.Name,
			'expecting specific scheduled job'
		);

		// check apex batch is in the job list
		List<AsyncApexJob> jobsApexBatch = [SELECT Id, ApexClass.Name FROM AsyncApexJob WHERE JobType = 'BatchApex'];
		System.assertEquals(1, jobsApexBatch.size(), 'expecting one apex batch job');
		System.assertEquals('AccountInactiveBatch', jobsApexBatch[0].ApexClass.Name, 'expecting specific batch job');
	}
}
