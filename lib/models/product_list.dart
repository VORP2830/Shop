import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final _url = 'https://shop-68727-default-rtdb.firebaseio.com/products.json';
  List<Product> _items = [];
  bool _showFavoriteOnly = false;
  //Returnando apenas um clone
  //não é possível alterar a lista original
  List<Product> get items => [..._items];
  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    final response = await http.get(Uri.parse(_url));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    _items.clear();
    data.forEach((productId, productData) {
      _items.add(Product(
        id: productId,
        name: productData['name'],
        price: productData['price'],
        description: productData['description'],
        imageUrl: productData['imageUrl'],
        isFavorite: productData['isFavorite'],
      ));
    });
    notifyListeners();
    return Future.value();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;
    final product = Product(
      id: hasId
          ? data['id'] as String
          : Random().nextDouble().toString() as String,
      name: data['name'] as String,
      price: data['price'] as double,
      description: data['description'] as String,
      imageUrl: data['imageUrl'] as String,
    );
    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$_url'),
      body: jsonEncode(
        {
          "name": product.name,
          "price": product.price,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        },
      ),
    );
    final id = jsonDecode(response.body)['name'];
    _items.add(Product(
      id: id,
      name: product.name,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
      isFavorite: product.isFavorite,
    ));
    //Notifica os listeners quando houver mudanças
    //para que a interface seja atualizada com os novos dados
    notifyListeners();
  }

  Future<void> updateProduct(Product product) {
    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
    return Future.value();
  }

  void removeProduct(Product product) {
    _items.removeWhere((prod) => prod.id == product.id);
    notifyListeners();
  }
}
