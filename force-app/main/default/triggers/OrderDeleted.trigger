trigger OrderDeleted on order(after delete) {
	OrderService.checkAccountsForOrders(Trigger.old);
}
