import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ItemDetail extends StatelessWidget {
  final String imgUrl;
  final String itemName;
  final String itemDetails;

  const ItemDetail(
      {Key? key,
      required this.imgUrl,
      required this.itemName,
      required this.itemDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text(
          itemName.toUpperCase(),
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 30,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Background image with blur effect
            // CachedNetworkImage(
            //   imageUrl: imgUrl,
            //   fit: BoxFit.cover,
            //   height: double.infinity,
            //   width: double.infinity,
            //   progressIndicatorBuilder: (context, url, downloadProgress) =>
            //       SpinKitPulse(
            //     color: Color(0xffdd0e1c),
            //   ),
            //   errorWidget: (context, url, error) => Icon(Icons.error),
            // ),
            // BackdropFilter(
            //   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            //   child: Container(
            //     color: Colors.black.withOpacity(0.5),
            //   ),
            // ),
            // Profile image with hero animation

            Container(
              child: Hero(
                tag: imgUrl,
                child: CachedNetworkImage(
                  width: double.infinity,
                  height: 400,
                  imageUrl: imgUrl,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SpinKitPulse(
                    color: Color(0xffdd0e1c),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: SafeArea(
                child: Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SafeArea(
                        child: Text(
                          itemDetails,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
