import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kidys_distributor/PlatformDialog.dart';
import 'package:kidys_distributor/PlatformTextField.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:provider/provider.dart';

import 'bottomSheetModal.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController GSTController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  String? selectedArea;
  bool _isFirstTime = true;
  bool isSigningUp = false;

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => BottomSheetModal(),
    );
  }

  Future<void> signUp(BuildContext context) async {
    setState(() {
      isSigningUp = true;
    });

    await Provider.of<AuthProvider>(context, listen: false).distributorSignUp(
        usernameController.text.trim().toString().toUpperCase(),
        selectedArea.toString().trim().toUpperCase(),
        GSTController.text.trim(),
        contactController.text.trim());

    setState(() {
      showAlertDialog(context);
      isSigningUp = false;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isFirstTime) {
      Provider.of<AuthProvider>(context, listen: false).fetchAreasFromDB();
      Provider.of<AuthProvider>(context, listen: false).setupNotifications();
    }
    _isFirstTime = false; //never run the above if again.
    super.didChangeDependencies();
  }

  showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => const PlatformDialog(
            title: "Signed Up!",
            content:
                "Please wait for the notification approval before you login."));
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
                        const Text(
                          "Get On Board!",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                            "Create your profile to become our distributor!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    ),
                    const SizedBox(height: 20),
                    PlatformTextField(
                      labelText: "YOUR NAME",
                      controller: usernameController,
                      type: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PlatformTextField(
                      labelText: "CONTACT NUMBER",
                      controller: contactController,
                      type: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PlatformTextField(
                      labelText: "GST NUMBER",
                      controller: GSTController,
                      type: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton<String>(
                          items: areas.map(buildMenuItem).toList(),
                          isExpanded: true,
                          focusColor: Color(0xffe6e3d3),
                          hint: const Text(
                            "Select Area",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          dropdownColor: Color(0XFFf5f5f5),
                          iconSize: 36,
                          icon: const Icon(Icons.arrow_drop_down,
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
                        !isSigningUp
                            ? CupertinoButton(
                                onPressed: () {
                                  signUp(context);
                                },
                                color: Color(0XFFDD0E1C),
                                child: Text(
                                  "Sign Up",
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
                                text: 'Already Registered? ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    //open bottom sheet.
                                    _showBottomSheet(context);
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

DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(item,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        )));
