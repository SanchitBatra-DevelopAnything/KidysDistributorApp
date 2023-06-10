import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kidys_distributor/providers/categories_provider.dart';
import 'package:provider/provider.dart';

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
    return Scaffold();
  }
}
