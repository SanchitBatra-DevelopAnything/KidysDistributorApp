import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:kidys_distributor/providers/cart.dart';
import 'package:kidys_distributor/providers/categories_provider.dart';
import 'package:provider/provider.dart';

import 'cartBadge.dart';
import 'item.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  var searchItemController = TextEditingController();
  var _isLoading = false;
  var _isFirstTime = true;
  var _isSearching = false;
  var _noItems = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isFirstTime) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<CategoriesProvider>(context, listen: false)
          .loadItemsForActiveCategory()
          .then((_) => {
                setState(() {
                  _isLoading = false;
                })
              });
    }
    _isFirstTime = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var items = Provider.of<CategoriesProvider>(context).items;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? const Center(
                child: SpinKitPulse(
                color: Color(0xffDD0E1C),
                size: 50.0,
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0XFF552018), Color(0xff552018)])),
                    height: 100,
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Flexible(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios_new),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        fit: FlexFit.tight,
                        child: SizedBox(
                          height: 45,
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: CupertinoSearchTextField(
                              onTap: () {
                                setState(() {
                                  _isSearching = true;
                                });
                              },
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              controller: searchItemController,
                              onChanged: (text) {
                                //onSearch(text);
                              },
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Consumer<CartProvider>(
                          builder: (_, cart, ch) => CartBadge(
                            value: cart.itemCount.toString(),
                            color: Colors.red,
                            child: ch!,
                          ),
                          child: IconButton(
                            onPressed: () {
                              //moveToCart(context);
                            },
                            icon: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            iconSize: 30,
                          ),
                        ),
                      )
                    ]),
                  ),
                  Flexible(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: GridView.builder(
                          itemCount: items.length,
                          primary: false,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.6,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (context, index) => Item(
                                imgPath: items[index].imgUrl,
                                price: items[index].delhi_ncr_price.toString(),
                                itemId: items[index].id,
                                itemName: items[index].itemName,
                              )),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
