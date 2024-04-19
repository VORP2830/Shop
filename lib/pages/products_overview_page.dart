import 'package:flutter/material.dart';
import 'package:shop/components/product_grid.dart';
class ProductsOverViewPage extends StatelessWidget {
  ProductsOverViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha loja'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ProductGrid(),
    );
  }
}
