import 'dart:ui';

import 'package:flutter/material.dart';

class ItemDetail extends StatelessWidget {
  final String imgUrl;
  final String itemName;

  const ItemDetail({Key? key, required this.imgUrl, required this.itemName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          itemName.toUpperCase(),
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 30,
        ),
      ),
      body: Stack(
        children: [
          // Background image with blur effect
          Image.network(
            imgUrl,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Profile image with hero animation
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Hero(
                  tag: imgUrl,
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                    height: 400,
                    width: double.infinity,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "DETAILS HERE BABABABABAB HAHASDHJKAHDKJAHSKDJHAKSDHALKJHDIUAHDLIASD , Ingredients : PAPAYA DKJAHSDJKHAJKDFHAJKFHGKJAGFJKAGFJKAGSFJKAGJKFAJKFHKJAHFKJAHFKJHAJKFGHAJKGHFAJKHGFKJAHFKJAHSFKJAHKJFHAF , pOORA LOREN IPSUM DAAALDUNGA YAHIN PE TERE!",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
