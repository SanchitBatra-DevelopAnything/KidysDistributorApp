import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kidys_distributor/cartScreen.dart';
import 'package:kidys_distributor/categories.dart';
import 'package:kidys_distributor/home.dart';
import 'package:kidys_distributor/login.dart';
import 'package:kidys_distributor/myOrders.dart';
import 'package:kidys_distributor/orderDone.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:kidys_distributor/providers/cart.dart';
import 'package:kidys_distributor/providers/categories_provider.dart';
import 'package:kidys_distributor/providers/orders.dart';
import 'package:kidys_distributor/signUp.dart';
import 'package:kidys_distributor/termsAndConditions.dart';
import 'package:provider/provider.dart';
import "firebase_options.dart";
import 'package:firebase_core/firebase_core.dart';

import 'items.dart';
import 'orderSummary.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'kidys-distributor-app',
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
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
      debugShowCheckedModeBanner: false,
    );
  }
}
