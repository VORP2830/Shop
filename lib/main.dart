import 'package:flutter/material.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.purple,
          secondary: Colors.deepOrange,
          background: Colors.white,
        ),
        fontFamily: 'Lato',
        useMaterial3: true,
      ),
      home: ProductsOverViewPage(),
      routes: {
        AppRoutes.PRODUCT_DETAIL: (_) => ProductDetailPage(),
      },
      //Removendo a faixa de debug
      debugShowCheckedModeBanner: false,
    );
  }
}
