import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/utils/app_routes.dart';

import '../models/product.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
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
    final auth = Provider.of<Auth>(context, listen: false);
    //Aqui estamos utilizando o widget ClipRRect para arredondar as bordas
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      //Aqui estamos utilizando o widget GridTile para exibir a imagem do produto
      //ele serve para exibir uma imagem com um footer, que é onde podemos adicionar
      //outros widgets, como botões, textos, etc.
      child: GridTile(
          child: GestureDetector(
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder:
                    AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
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
                  product.toggleFavorite(
                    auth.token ?? '',
                    auth.userId ?? '',
                  );
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
                //Esconde o snackbar anterior
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                //Exibe um novo snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Produto adicionado com sucesso!',
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'DESFAZER',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
                cart.addItem(product);
              },
            ),
          )),
    );
  }
}
