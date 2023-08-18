import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kidys_distributor/cartScreen.dart';
import 'package:kidys_distributor/categories.dart';
import 'package:kidys_distributor/home.dart';
import 'package:kidys_distributor/login.dart';
import 'package:kidys_distributor/myOrders.dart';
import 'package:kidys_distributor/myProfile.dart';
import 'package:kidys_distributor/orderDone.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:kidys_distributor/providers/cart.dart';
import 'package:kidys_distributor/providers/categories_provider.dart';
import 'package:kidys_distributor/providers/orders.dart';
import 'package:kidys_distributor/signUp.dart';
import 'package:kidys_distributor/termsAndConditions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'items.dart';
import 'orderSummary.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => CategoriesProvider()),
      ChangeNotifierProvider(create: (context) => CartProvider()),
      ChangeNotifierProvider(create: (context) => OrderProvider()),
    ], child: MaterialAppWithInitialRoute());
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MaterialAppWithInitialRoute extends StatelessWidget {
  const MaterialAppWithInitialRoute({Key? key}) : super(key: key);

  Future<String> getInitialRoute() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    print("keyd");
    print(sp.getKeys());
    if (sp.containsKey('loggedInDistributor')) {
      return '/categories';
    }
    return '/';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInitialRoute(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Kidys Distributor',
              theme: ThemeData(primarySwatch: Colors.blue),
              initialRoute: snapshot.data.toString(),
              routes: {
                '/': (context) => HomePage(),
                '/termsAndConditions': (context) => TermsAndConditionsPage(),
                '/signup': (context) => SignUpForm(),
                '/login': (context) => LoginPage(),
                '/categories': (context) => Categories(),
                '/items': (context) => Items(),
                '/cart': (context) => CartScreen(),
                '/orderPlaced': (context) => OrderPlaced(),
                '/myOrders': (context) => MyOrders(),
                '/orderSummary': (context) => OrderSummary(),
                '/profile': (context) => MyProfile(),
              },
            );
          } else {
            print("idhar aaya");
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Kidys Distributor',
              theme: ThemeData(primarySwatch: Colors.blue),
              initialRoute: '/',
              routes: {
                '/': (context) => HomePage(),
                '/termsAndConditions': (context) => TermsAndConditionsPage(),
                '/signup': (context) => SignUpForm(),
                '/login': (context) => LoginPage(),
                '/categories': (context) => Categories(),
                '/items': (context) => Items(),
                '/cart': (context) => CartScreen(),
                '/orderPlaced': (context) => OrderPlaced(),
                '/myOrders': (context) => MyOrders(),
                '/orderSummary': (context) => OrderSummary(),
              },
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      }),
    );
  }
}
