import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/cart_item.dart';
import 'package:shop/utils/constants.dart';
import 'cart.dart';
import 'order.dart';

class OrdersList with ChangeNotifier {
  final List<Order> _items = [];
  List<Order> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response =
        await http.post(Uri.parse('${Constants.ORDER_BASE_URL}.json'),
            body: jsonEncode({
              'total': cart.totalAmount.toString(),
              'date': date.toIso8601String(),
              'products': cart.items.values
                  .map((cartItem) => {
                        'id': cartItem.id,
                        'productId': cartItem.productId,
                        'title': cartItem.name,
                        'quantity': cartItem.quantity,
                        'price': cartItem.price,
                      })
                  .toList(),
            }));
    _items.insert(
        0,
        Order(
          id: jsonDecode(response.body)['name'],
          total: cart.totalAmount,
          products: cart.items.values.toList(),
          date: date,
        ));
    notifyListeners();
  }

  Future<void> loadOrders() async {
    final response = await http.get(
      Uri.parse('${Constants.ORDER_BASE_URL}.json'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    _items.clear();
    data.forEach(
      (orderId, orderData) {
        _items.add(
          Order(
            id: orderId,
            total: double.parse(orderData['total']),
            date: DateTime.parse(orderData['date']),
            products: (orderData['products'] as List<dynamic>).map((item) {
              return CartItem(
                id: item['id'],
                productId: item['productId'],
                name: item['title'],
                quantity: item['quantity'],
                price: item['price'],
              );
            }).toList(),
          ),
        );
      },
    );
    notifyListeners();
    return Future.value();
  }
}
