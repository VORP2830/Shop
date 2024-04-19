import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Aqui estamos obtendo a instância de ProductList que foi provida
    //pelo ChangeNotifierProvider no arquivo main.dart
    final provider = Provider.of<ProductList>(context);
    List<Product> loadedProducts = provider.items;
    //Aqui estamos utilizando o GridView.builder para exibir os produtos
    //em uma grade. O GridView.builder é uma versão otimizada do GridView
    //que cria os itens conforme eles são exibidos na tela.
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      //Aqui estamos utilizando o ChangeNotifierProvider para prover
      //a instância de Product para o ProductItem. Dessa forma, o ProductItem
      //pode acessar o estado do produto e notificar os listeners quando
      //o estado do produto é alterado. O value é utilizado para passar
      //a instância de Product para o ProductItem.
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        //O value é utilizado para passar a instância de Product para o ProductItem.
        value: loadedProducts[i],
        child: ProductItem(),
      ),
      //Aqui estamos definindo a quantidade de itens que serão exibidos
      //por linha. No caso, estamos definindo que serão exibidos 2 itens
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
