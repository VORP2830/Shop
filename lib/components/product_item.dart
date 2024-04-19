import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/app_routes.dart';

import '../models/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    //Aqui estamos utilizando o widget ClipRRect para arredondar as bordas
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      //Aqui estamos utilizando o widget GridTile para exibir a imagem do produto
      //ele serve para exibir uma imagem com um footer, que é onde podemos adicionar
      //outros widgets, como botões, textos, etc.
      child: GridTile(
          child: GestureDetector(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PRODUCT_DETAIL,
                arguments: product,
              );
            },
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                product.toggleFavorite();
              },
            ),
            title: Text(
              product.title,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {},
            ),
          )),
    );
  }
}
