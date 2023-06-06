import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:kidys_distributor/signUp.dart';
import 'package:provider/provider.dart';

import 'PlatformDialog.dart';
import 'PlatformTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  String? selectedArea;
  bool _isFirstTime = true;
  bool isLoading = true;
  bool _invalidLogin = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (!mounted) {
      return;
    }
    if (_isFirstTime) {
      Provider.of<AuthProvider>(context, listen: false).fetchAreasFromDB();
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      Provider.of<AuthProvider>(context, listen: false)
          .fetchDistributorsFromDB()
          .then((value) => {
                setState(
                  () => isLoading = false,
                )
              });
    }
    _isFirstTime = false; //never run the above if again.
    super.didChangeDependencies();
  }

  void startLoginProcess(BuildContext context) {
    var isPresent = false;
    var distributors =
        Provider.of<AuthProvider>(context, listen: false).distributors;
    distributors.forEach((distributor) {
      if (usernameController.text.trim().toLowerCase() ==
              distributor.distributorName.toLowerCase() &&
          selectedArea.toString().toLowerCase() ==
              distributor.area.toLowerCase()) {
        isPresent = true;
      }
      if (isPresent) {
        if (mounted) {
          setState(() {
            _invalidLogin = false;
          });
        }
        Provider.of<AuthProvider>(context, listen: false)
            .setLoggedInDistributorAndArea(
                usernameController.text.toUpperCase(), selectedArea!);

        Navigator.of(context).pushReplacementNamed('/categories');
      } else {
        if (mounted) {
          setState(() {
            _invalidLogin = true;
          });
        }
      }
    });

    if (_invalidLogin) {
      showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => const PlatformDialog(
            title: "Invalid Login!",
            content:
                "It might be that you provided correct credentials , but admin has not approved you yet. Try logging in after some time , if already registered!"));
  }

  @override
  Widget build(BuildContext context) {
    final areas = Provider.of<AuthProvider>(context).areaNames;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFf5f5f5),
        body: GestureDetector(
          onTap: () {
            // Unfocus the TextFormField when the user taps outside
            if (_focusScopeNode.hasFocus) {
              _focusScopeNode.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30),
              child: FocusScope(
                node: _focusScopeNode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/logo.png",
                          height: MediaQuery.of(context).size.height * 0.2,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          "Welcome Back!",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text("Please Login Below To Get Started!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    ),
                    SizedBox(height: 20),
                    PlatformTextField(
                      labelText: "YOUR NAME",
                      controller: usernameController,
                      type: TextInputType.text,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton<String>(
                          items: areas.map(buildMenuItem).toList(),
                          isExpanded: true,
                          focusColor: Color(0xffe6e3d3),
                          hint: Text(
                            "Select Area",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          dropdownColor: Color(0XFFf5f5f5),
                          iconSize: 36,
                          icon: Icon(Icons.arrow_drop_down,
                              color: Color(0xffDD0E1C)),
                          value: selectedArea,
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) => {
                                setState(
                                  () => this.selectedArea = value,
                                )
                              }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !isLoading
                            ? CupertinoButton(
                                onPressed: () {
                                  startLoginProcess(context);
                                },
                                color: Color(0XFFDD0E1C),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : SpinKitPulse(
                                color: Color(0xffDD0E1C),
                                size: 50.0,
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Not Registered yet? ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    //open bottom sheet.
                                    Navigator.of(context)
                                        .pushReplacementNamed('/signup');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
