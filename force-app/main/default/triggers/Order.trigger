trigger Order on Order(after insert, before update, after delete) {
	if (Trigger.isAfter && Trigger.isInsert) {
		// Process after insert
		OrderService.setOrdersAccountsActive(Trigger.new);
	} else if (Trigger.isAfter && Trigger.isDelete) {
		// Process after delete
		OrderService.checkAccountsForOrders(Trigger.old);
	} else if (Trigger.isBefore && Trigger.isUpdate) {
		// Process before update
		List<Order> ordersToCheck = new List<Order>();
		for (Order updatedOrder : Trigger.new) {
			if (updatedOrder.Status == 'Activated' && Trigger.oldMap.get(updatedOrder.id).Status != 'Activated') {
				ordersToCheck.add(updatedOrder);
			}
		}
		if (ordersToCheck.size() != 0) {
			OrderService.checkActivatedOrders(ordersToCheck);
		}
	}
}
