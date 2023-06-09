import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:kidys_distributor/providers/categories_provider.dart';
import 'package:provider/provider.dart';

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

      Provider.of<CategoriesProvider>(context, listen: false)
          .fetchCategoriesFromDB()
          .then((value) => setState(() {
                print("FETCH COMPLETE!");
                _isLoading = false;
              }));
    }
    _isFirstTime = false; //never run the above if again.
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                    onPressed: () {},
                  ),
                  Container(
                    width: 125.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.money),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.shopping_cart),
                          color: Colors.white,
                          onPressed: () {},
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
                  Row(
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
                              onTap: () {},
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
                                        child: Image.network(
                                          categoriesData[i].imageUrl,
                                          loadingBuilder:
                                              (context, child, progress) {
                                            return progress == null
                                                ? child
                                                : LinearProgressIndicator(
                                                    backgroundColor:
                                                        Colors.black12,
                                                  );
                                          },
                                          fit: BoxFit.fitWidth,
                                          semanticLabel:
                                              categoriesData[i].categoryName,
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
