import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;
  //Returnando apenas um clone
  //não é possível alterar a lista original
  List<Product> get items => [..._items];

  void addProduct(Product product) {
    _items.add(product);
    //Notifica os listeners quando houver mudanças
    //para que a interface seja atualizada com os novos dados
    notifyListeners();
  }
}
