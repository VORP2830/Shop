import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/utils/app_routes.dart';

import 'models/product_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Aqui estamos utilizando o ChangeNotifierProvider para prover
    //a instância de ProductList para toda a aplicação.
    return ChangeNotifierProvider(
      //Aqui estamos passando a instância de ProductList para o provider
      //para que ele possa ser utilizado em toda a aplicação.
      //O create é utilizado para criar a instância de ProductList.
      create: (_) => ProductList(),
      child: MaterialApp(
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
          AppRoutes.PRODUCT_DETAIL: (_) => const ProductDetailPage(),
        },
        //Removendo a faixa de debug
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
