import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order_item.dart';

import '../models/orders_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<OrdersList>(context, listen: false).loadOrders().then((_) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrdersList orders = Provider.of(context);
    Future<void> _refreshOrders(BuildContext context) {
      return Provider.of<OrdersList>(context, listen: false)
          .loadOrders()
          .then((_) {
        setState(() => _isLoading = false);
      });
    }

    return RefreshIndicator(
      onRefresh: () => _refreshOrders(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pedidos'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        drawer: const AppDrawer(),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (ctx, i) => OrderItem(order: orders.items[i]),
              ),
      ),
    );
  }
}
