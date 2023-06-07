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
        backgroundColor: Color(0xFFDD0E1C),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              color: Color(0xFFDD0E1C),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.work),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.shopping_cart_checkout),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.0),
            Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "WELCOME ${loggedInDistributor}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    "KIDY'S CATEGORIES",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(75.0),
                    bottomRight: Radius.circular(125.0),
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
                                height: 300,
                                width: 300,
                                child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Image.network(
                                    categoriesData[i].imageUrl,
                                    loadingBuilder: (context, child, progress) {
                                      return progress == null
                                          ? child
                                          : LinearProgressIndicator(
                                              backgroundColor: Colors.black12,
                                            );
                                    },
                                    fit: BoxFit.fill,
                                    semanticLabel:
                                        categoriesData[i].categoryName,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
                              child: GestureDetector(
                                child: Text(
                                  categoriesData[i].categoryName.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    backgroundColor: Colors.black54,
                                  ),
                                ),
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
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
