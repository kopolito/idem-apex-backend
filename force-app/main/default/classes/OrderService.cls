global without sharing class OrderService {
	global static void checkActivatedOrders(List<Order> ordersToCheck) {
		Map<Id, Order> orders = new Map<Id, Order>(
			[SELECT Id, (SELECT Id FROM OrderItems) FROM Order WHERE Id IN :ordersToCheck]
		);
		for (Order order : ordersToCheck) {
			if (orders.get(order.id).OrderItems.size() == 0) {
				order.addError('You must add Order Products');
			}
		}
	}

	global static void setOrdersAccountsActive(List<Order> createdOrders) {
		Set<Id> accountsIds = new Set<Id>();
		for (Order order : createdOrders) {
			accountsIds.add(order.AccountId);
		}
		List<Account> accountsToActivate = new List<Account>(
			[SELECT Id FROM Account WHERE Id IN :accountsIds AND Active__c = FALSE]
		);
		if (accountsToActivate.size() != 0) {
			for (Account account : accountsToActivate) {
				account.Active__c = true;
			}
			update accountsToActivate;
		}
	}

	global static void checkAccountsForOrders(List<Order> deletedOrders) {
		Set<Id> accountsIds = new Set<Id>();
		for (Order order : deletedOrders) {
			accountsIds.add(order.AccountId);
		}
		List<Account> accountsToCheck = new List<Account>(
			[SELECT Id, (SELECT Id FROM Orders) FROM Account WHERE Id IN :accountsIds]
		);
		List<Account> accountsToUpdate = new List<Account>();
		for (Account account : accountsToCheck) {
			if (account.Orders.size() == 0) {
				account.Active__c = false;
				accountsToUpdate.add(account);
			}
		}
		if (accountsToUpdate.size() != 0) {
			Database.update(accountsToUpdate);
		}
	}
}
