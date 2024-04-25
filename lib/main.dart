import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/orders_list.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/utils/custom_route.dart';

import 'models/product_list.dart';
import 'pages/cart_page.dart';
import 'pages/product_form_page.dart';
import 'pages/products_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Aqui estamos utilizando o MultiProvider para prover
    //a instância de ProductList, Cart e OrderList para toda a aplicação.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (context, auth, previous) {
            return ProductList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrdersList>(
          create: (_) => OrdersList(),
          update: (context, auth, previous) {
            return OrdersList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
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
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            },
          ),
        ),
        //home: ProductsOverViewPage(),
        routes: {
          AppRoutes.AUTH_OR_HOME: (_) => const AuthOrHomePage(),
          AppRoutes.PRODUCT_DETAIL: (_) => const ProductDetailPage(),
          AppRoutes.CART: (_) => const CartPage(),
          AppRoutes.ORDERS: (_) => const OrdersPage(),
          AppRoutes.PRODUCTS: (_) => const ProductsPage(),
          AppRoutes.PRODUCT_FORM: (_) => const ProductFormPage(),
        },
        //Removendo a faixa de debug
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
