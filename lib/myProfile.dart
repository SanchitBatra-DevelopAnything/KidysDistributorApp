import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:kidys_distributor/providers/cart.dart';
import 'package:kidys_distributor/termsAndConditions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'PlatformDialog.dart';
import 'dart:io';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool _isLoading = false;
  // String pathPDF = "";

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

  showDeleteAccountBox(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => PlatformDialog(
            title: "Delete your account?",
            content: "By Clicking OK , you will no longer be our distributor",
            callBack: deleteAccount));
  }

  Future<void> deleteAccount() async {
    await Provider.of<AuthProvider>(context, listen: false).deleteAccount();
    await logout();
  }

  // Future<File> fromAsset(String asset, String filename) async {
  //   // To open from assets, you can copy them to the app storage folder, and the access them "locally"
  //   Completer<File> completer = Completer();

  //   try {
  //     var dir = await getApplicationDocumentsDirectory();
  //     File file = File("${dir.path}/$filename");
  //     var data = await rootBundle.load(asset);
  //     var bytes = data.buffer.asUint8List();
  //     await file.writeAsBytes(bytes, flush: true);
  //     completer.complete(file);
  //   } catch (e) {
  //     throw Exception('Error parsing asset file!');
  //   }

  //   return completer.future;
  // }

  @override
  void initState() {
    // TODO: implement initState
    // fromAsset('assets/tnc.pdf', 'tnc.pdf').then((f) {
    //   setState(() {
    //     pathPDF = f.path;
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 229, 229),
        body: !_isLoading
            ? Column(
                children: [
                  Container(
                    height: 75,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => {Navigator.of(context).pop()},
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 28,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "My Profile",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                      onTap: (() => {
                            Navigator.of(context).pushNamed("/myOrders"),
                          }),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 25,
                      ),
                      leading: Icon(
                        Icons.shopping_bag,
                        size: 28,
                        color: Colors.black,
                      ),
                      tileColor: Colors.white,
                      subtitle: Text("Get updates on your orders here"),
                      title: Text(
                        "My Orders",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // ListTile(
                  //     onTap: (() => {
                  //           if (pathPDF.isNotEmpty)
                  //             {
                  //               Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       TermsAndConditionsPage(path: pathPDF),
                  //                 ),
                  //               )
                  //             }
                  //         }),
                  //     trailing: Icon(
                  //       Icons.arrow_forward_ios,
                  //       color: Colors.black,
                  //       size: 25,
                  //     ),
                  //     leading: Icon(
                  //       Icons.description,
                  //       size: 28,
                  //       color: Colors.black,
                  //     ),
                  //     tileColor: Colors.white,
                  //     subtitle: Text("Please read it carefully."),
                  //     title: Text(
                  //       "TERMS & CONDITIONS",
                  //       style: TextStyle(
                  //           color: Colors.black,
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.bold),
                  //     )),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                      onTap: () => {showLogoutBox(context)},
                      leading: Icon(
                        Icons.logout_outlined,
                        size: 28,
                        color: Colors.black,
                      ),
                      tileColor: Colors.white,
                      subtitle: Text("Log me out of this application"),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                      onTap: () => {showDeleteAccountBox(context)},
                      leading: Icon(
                        Icons.delete_forever,
                        size: 28,
                        color: Color(0XFFDD0E1C),
                      ),
                      tileColor: Colors.white,
                      subtitle: Text("You'll be no longer our distributor"),
                      title: Text(
                        "Delete My Account",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )
            : Center(
                child: SpinKitPulse(
                  color: Color(0xffDD0E1C),
                  size: 50.0,
                ),
              ),
      ),
    );
  }
}
