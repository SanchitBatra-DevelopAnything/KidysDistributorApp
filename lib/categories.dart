import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFDD0E1C),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              backgroundColor: Color(0xFFDD0E1C),
              title: Row(
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
                  )
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 25.0),
                  Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Row(
                      children: <Widget>[
                        Text("Kidy's",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0)),
                        SizedBox(width: 10.0),
                        Text('Categories',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontSize: 25.0))
                      ],
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    height: MediaQuery.of(context).size.height - 18.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(75.0)),
                    ),
                    child: ListView(
                      primary: false,
                      padding: EdgeInsets.only(left: 25.0, right: 20.0),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 45.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height - 300.0,
                            child: ListView(children: [
                              Container(
                                child: Text("HELLO"),
                                height: 160,
                              ),
                              Container(
                                child: Text("HELLO"),
                                height: 160,
                              ),
                              Container(
                                child: Text("HELLO"),
                                height: 160,
                              ),
                              Container(
                                child: Text("HELLO"),
                                height: 160,
                              ),
                              Container(
                                child: Text("HELLO"),
                                height: 160,
                              ),
                              Container(
                                child: Text("HELLO"),
                                height: 160,
                              ),
                              Container(
                                child: Text("HELLO"),
                                height: 160,
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
