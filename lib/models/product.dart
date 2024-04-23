import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';

import '../utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    //Essa função é responsável por notificar os listeners
    //que estão escutando as mudanças no estado do produto
    notifyListeners();
  }

  //Essa função é responsável por mudar o estado do produto
  //de favorito para não favorito e vice-versa.
  Future<void> toggleFavorite() async {
    _toggleFavorite();
    final response = await http.patch(
      Uri.parse('${Constants.PRODUCT_BASE_URL}/${id}.json'),
      body: jsonEncode({
        "isFavorite": isFavorite,
      }),
    );
    if (response.statusCode >= 400) {
      _toggleFavorite();
      throw HttpException(
        message: 'Ocorreu um erro ao favoritar o produto',
        statusCode: response.statusCode,
      );
    }
  }
}
