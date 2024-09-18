import 'package:aaelectroz_fe/pages/cart_page.dart';
import 'package:aaelectroz_fe/pages/checkout_page.dart';
import 'package:aaelectroz_fe/pages/checkout_success_page.dart';
import 'package:aaelectroz_fe/pages/edit_profile_page.dart';
import 'package:aaelectroz_fe/pages/home/main_page.dart';
import 'package:aaelectroz_fe/pages/sign_in_page.dart';
import 'package:aaelectroz_fe/pages/sign_up_page.dart';
import 'package:aaelectroz_fe/pages/splash_page.dart';
import 'package:aaelectroz_fe/providers/auth_provider.dart';
import 'package:aaelectroz_fe/providers/cart_provider.dart';
import 'package:aaelectroz_fe/providers/page_provider.dart';
import 'package:aaelectroz_fe/providers/product_provider.dart';
import 'package:aaelectroz_fe/providers/transaction_provider.dart';
import 'package:aaelectroz_fe/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WishlistProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TransactionProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PageProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => SplashPage(),
          '/sign-in': (context) => SignInPage(),
          '/sign-up': (context) => SignUpPage(),
          '/home': (context) => MainPage(),
          '/edit-profile': (context) => EditProfilePage(),
          '/cart': (context) => CartPage(),
          '/checkout': (context) => CheckoutPage(),
          '/checkout-success': (context) => CheckoutSuccessPage(),
        },
      ),
    );
  }
}
