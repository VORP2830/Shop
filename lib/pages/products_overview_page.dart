import 'package:flutter/material.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/data/dummy_data.dart';

import '../models/product.dart';

class ProductsOverViewPage extends StatelessWidget {
  final List<Product> loadedProducts = dummyProducts;
  ProductsOverViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha loja'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      //Aqui estamos utilizando o GridView.builder para exibir os produtos
      //em uma grade. O GridView.builder é uma versão otimizada do GridView
      //que cria os itens conforme eles são exibidos na tela.
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: loadedProducts.length,
        itemBuilder: (ctx, i) => ProductItem(loadedProducts[i]),
        //Aqui estamos definindo a quantidade de itens que serão exibidos
        //por linha. No caso, estamos definindo que serão exibidos 2 itens
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
