import 'package:flutter/material.dart';

class Product with ChangeNotifier{
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
  //Essa função é responsável por mudar o estado do produto 
  //de favorito para não favorito e vice-versa.
  void toggleFavorite() {
    isFavorite = !isFavorite;
    //Essa função é responsável por notificar os listeners
    //que estão escutando as mudanças no estado do produto
    notifyListeners();
  }
}
