import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'cartBadge.dart';
import './models/item.dart';
import 'item.dart';
import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/categories_provider.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  final searchItemController = TextEditingController();
  var _isLoading = false;
  var _isFirstTime = true;
  var _isSearching = false;

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<CategoriesProvider>(context, listen: false)
          .loadItemsForActiveCategory()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  void onSearch(String text) {
    Provider.of<CategoriesProvider>(context, listen: false).filterItems(text);
  }

  dynamic getPrice(Item item, String loggedInArea) {
    return item.itemPrice;
  }

  @override
  Widget build(BuildContext context) {
    var items = Provider.of<CategoriesProvider>(context).filteredItems;
    var loggedInDistributor =
        Provider.of<AuthProvider>(context).loggedInDistributor;
    var loggedInArea =
        Provider.of<AuthProvider>(context).loggedInArea.toLowerCase().trim();

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: _isLoading
              ? const Center(
                  child: SpinKitPulse(
                    color: Color(0xffDD0E1C),
                    size: 50.0,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0XFFFFFFFF), Color(0xffFFFFFF)],
                        ),
                      ),
                      child: loggedInDistributor != 'null'
                          ? Row(children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new),
                                color: Colors.black,
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  height: 45,
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: CupertinoSearchTextField(
                                      autocorrect: false,
                                      onTap: () {
                                        setState(() {
                                          _isSearching = true;
                                        });
                                      },
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      controller: searchItemController,
                                      onChanged: onSearch,
                                    ),
                                  ),
                                ),
                              ),
                              Consumer<CartProvider>(
                                builder: (_, cart, ch) => CartBadge(
                                  value: cart.itemCount.toString(),
                                  color: Colors.red,
                                  child: ch!,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.shopping_cart,
                                      color: Colors.black),
                                  iconSize: 30,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed("/cart");
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.info_outline),
                                iconSize: 30,
                                onPressed: () {
                                  final snackBar = SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'Information',
                                      message:
                                          'Long press + - to change quantity by 50 directly and click on item image to view more information about it.',
                                      contentType: ContentType.success,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(snackBar);
                                },
                              ),
                            ])
                          : IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new),
                              color: Colors.black,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: GridView.builder(
                          itemCount: items.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final slabData = item.getEffectiveSlab(loggedInArea);

                            return ItemCard(
                              imgPath: item.imgUrl,
                              price: getPrice(item, loggedInArea),
                              itemId: item.id,
                              itemName: item.itemName,
                              itemDetails: item.details,
                              slab_1_start: slabData['slab_1_start'] ?? 1000,
                              slab_1_end: slabData['slab_1_end'] ?? 1000,
                              slab_2_start: slabData['slab_2_start'] ?? 1000,
                              slab_2_end: slabData['slab_2_end'] ?? 1000,
                              slab_3_start: slabData['slab_3_start'] ?? 1000,
                              slab_3_end: slabData['slab_3_end'] ?? 1000,
                              slab_1_discount: slabData['slab_1_discount'] ?? 0,
                              slab_2_discount: slabData['slab_2_discount'] ?? 0,
                              slab_3_discount: slabData['slab_3_discount'] ?? 0,
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
