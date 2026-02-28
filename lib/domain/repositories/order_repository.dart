import 'package:dual_role_delivery_app/domain/models/order.dart';

/// Abstract repository to define the contract for fetching order data.
/// This allows the business logic to be decoupled from the data source.
abstract class OrderRepository {
  /// Fetches a list of delivery orders.
  ///
  /// In a real application, this would fetch data from a remote API
  /// or a local database.
  Future<List<Order>> getOrders();

  /// Persists the provided orders.
  Future<void> saveOrders(List<Order> orders);

  /// Updates a single order.
  Future<void> updateOrder(Order order);
}
