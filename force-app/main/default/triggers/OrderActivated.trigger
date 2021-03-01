trigger OrderActivated on Order(before update) {
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
