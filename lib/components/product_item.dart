import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/utils/app_routes.dart';

import '../models/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Aqui estamos utilizando o Provider.of para pegar o produto que foi passado
    final product = Provider.of<Product>(
      context,
      //O listen é utilizado para informar ao provider que ele deve ou não
      //ficar escutando mudanças no objeto, se o listen for false, o provider
      //não ficará escutando mudanças no objeto, ou seja, ele não será atualizado
      //se o objeto for alterado, se o listen for true, o provider ficará escutando
      //mudanças no objeto, ou seja, ele será atualizado se o objeto for alterado.
      listen: true,
    );
    final cart = Provider.of<Cart>(context);
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
            //Essa é a parte que será reconstruida quando o objeto for alterado
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  product.toggleFavorite();
                },
              ),
            ),
            title: Text(
              product.name,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                cart.addItem(product);
              },
            ),
          )),
    );
  }
}
