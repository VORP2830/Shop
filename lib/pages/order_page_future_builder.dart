import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';

import '../components/order_item.dart';
import '../models/orders_list.dart';
class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrdersList>(context, listen: false).loadOrders(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(
              child: Text('Ocorreu um erro!'),
            );
          } else {
            return Consumer<OrdersList>(
              builder: (ctx, orders, child) => ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (ctx, i) => OrderItem(order: orders.items[i]),
              ),
            );
          }
        }),
      ),
    );
  }
}
