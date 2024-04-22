import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/product_list.dart';
import '../utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Excluir Produto'),
                    content: const Text('Tem Certeza?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          //Aqui fechamos o dialogo e retornamos false para o then,
                          Navigator.of(ctx).pop(false);
                        },
                        child: const Text('Não'),
                      ),
                      TextButton(
                        onPressed: () {
                          //Aqui fechamos o dialogo e retornamos true para o then,
                          Navigator.of(ctx).pop(true);
                        },
                        child: const Text('Sim'),
                      ),
                    ],
                  ),
                ).then(
                  (_) => {
                    Provider.of<ProductList>(context, listen: false)
                        .removeProduct(product)
                  },
                );
              },
            ),
          ],
        ),
      ),
      onTap: null,
    );
  }
}
