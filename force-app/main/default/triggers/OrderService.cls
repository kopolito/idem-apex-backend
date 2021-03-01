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
}
