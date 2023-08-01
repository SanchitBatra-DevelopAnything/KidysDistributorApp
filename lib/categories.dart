import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:kidys_distributor/providers/cart.dart';
import 'package:kidys_distributor/providers/categories_provider.dart';
import 'package:provider/provider.dart';

import 'PlatformDialog.dart';
import 'cartBadge.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  bool _isFirstTime = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isFirstTime) {
      // setState(() {
      //   _isLoading = true;
      // });
      Provider.of<AuthProvider>(context, listen: false)
          .setupNotifications()
          .then((_) => {
                doAuthStuff().then((_) => {
                      Provider.of<CategoriesProvider>(context, listen: false)
                          .fetchCategoriesFromDB()
                          .then((value) => setState(() {
                                var distributor = Provider.of<AuthProvider>(
                                        context,
                                        listen: false)
                                    .loggedInDistributor;

                                var area = Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .loggedInArea;
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .fetchCartFromDB(distributor, area)
                                    .then((_) => {
                                          print("FETCH COMPLETE!"),
                                          setState(() {
                                            _isLoading = false;
                                          })
                                        });
                              }))
                    })
              });
    }
    _isFirstTime = false; //never run the above if again.
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> doAuthStuff() async {
    var authObject = Provider.of<AuthProvider>(context, listen: false);
    await authObject.loadLoggedInDistributorData();
  }

  moveToCart(BuildContext context) {
    Navigator.of(context).pushNamed("/cart");
  }

  moveToItems(String categoryId, String categoryName) {
    Provider.of<CategoriesProvider>(context, listen: false).activeCategoryKey =
        categoryId;
    Provider.of<CategoriesProvider>(context, listen: false).activeCategoryName =
        categoryName;

    Navigator.of(context).pushNamed('/items');
  }

  showLogoutBox(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => PlatformDialog(
            title: "LOGOUT?",
            content: "By Clicking OK , you will be logged out",
            callBack: logout));
  }

  Future<void> logout() async {
    Provider.of<CartProvider>(context, listen: false)
        .clearCart(); //taaki next login se mix na hon same phone me.
    await Provider.of<AuthProvider>(context, listen: false).logout();

    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var categoriesData = Provider.of<CategoriesProvider>(context).categories;
    var loggedInDistributor =
        Provider.of<AuthProvider>(context).loggedInDistributor;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF552018),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              color: Color(0xff552018),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () {
                      showLogoutBox(context);
                    },
                  ),
                  Container(
                    width: 150.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.assignment),
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: () {
                            Navigator.of(context).pushNamed('/myOrders');
                          },
                        ),
                        Consumer<CartProvider>(
                          builder: (_, cart, ch) => CartBadge(
                            value: cart.itemCount.toString(),
                            color: Colors.red,
                            child: ch!,
                          ),
                          child: IconButton(
                            onPressed: () {
                              moveToCart(context);
                            },
                            icon: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            iconSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0),
            Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "WELCOME ${loggedInDistributor}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "KIDY'S CATEGORIES",
                        style: TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(2, 2),
                              blurRadius: 1,
                            ),
                          ],
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(75.0),
                  ),
                ),
                child: _isLoading
                    ? Center(
                        child: SpinKitPulse(
                          color: Color(0xffDD0E1C),
                          size: 50.0,
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(20.0),
                        itemCount: categoriesData.length,
                        itemBuilder: (ctx, i) => Stack(
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            GestureDetector(
                              onTap: () {
                                moveToItems(categoriesData[i].id,
                                    categoriesData[i].categoryName);
                              },
                              child: SizedBox(
                                height: 400,
                                width: double.infinity,
                                child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 15,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        child: CachedNetworkImage(
                                          imageUrl: categoriesData[i].imageUrl,
                                          fit: BoxFit.fitWidth,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              SpinKitPulse(
                                            color: Color(0xffdd0e1c),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 2.0, sigmaY: 2.0),
                                          child: Container(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                categoriesData[i]
                                                    .categoryName
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25.0,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.white,
                                                      offset: Offset(2, 2),
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
