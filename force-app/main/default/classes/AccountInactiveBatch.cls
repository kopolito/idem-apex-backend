/**
 * Traitement par lot pour signaler les comptes sans activité
 *
 */
global class AccountInactiveBatch implements Database.Batchable<sObject> {
	global Database.QueryLocator start(Database.BatchableContext info) {
		// List Inactive Accounts (without Order)
		return Database.getQueryLocator(
			'SELECT Id, OwnerId, (SELECT Id FROM Tasks WHERE Subject = \'Call\') FROM Account WHERE Active__c = false'
		);
	}

	global void execute(Database.BatchableContext info, List<Account> accountsToCheck) {
		// List Account without related Task
		List<Account> accountsWithoutTask = new List<Account>();
		for (Account account : accountsToCheck) {
			if (account.Tasks.size() == 0) {
				accountsWithoutTask.add(account);
			}
		}
		if (accountsWithoutTask.size() != 0) {
			// Create a reminder Task for eash Inactive Account
			List<Task> tasksToCreate = new List<Task>();
			for (Account account : accountsWithoutTask) {
				tasksToCreate.add(
					new Task(
						WhatId = account.Id,
						OwnerId = account.OwnerId,
						Subject = 'Call',
						Status = 'Not Started',
						Priority = 'Normal',
						IsReminderSet = true,
						ReminderDateTime = Date.today().addDays(5)
					)
				);
			}
			Database.insert(tasksToCreate);
		}
	}

	global void finish(Database.BatchableContext info) {
	}
}
