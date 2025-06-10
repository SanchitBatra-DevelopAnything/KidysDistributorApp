import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kidys_distributor/PlatformDialog.dart';
import 'package:kidys_distributor/PlatformTextField.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'bottomSheetModal.dart';
import 'package:geolocator/geolocator.dart';
class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController shopController = TextEditingController();
  TextEditingController GSTController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController shopAddressController = TextEditingController();
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

 Future<Position?> getUserLocation(BuildContext context) async {
  Position? position;

  // Always request permission each time the method is called
  LocationPermission permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.denied || 
      permission == LocationPermission.deniedForever) {
    showSnackBar(context, "Location permission is required for signup!");
    return null;
  }

  try {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  } catch (e) {
    showSnackBar(context, "Unable to get your location. Please try again.");
    return null;
  }

  if (position != null) {
    return position;
  } else {
    showSnackBar(context, "Unable to get your location. Please try again.");
    return null;
  }
}

  Future<void> signUp(BuildContext context) async {

    
    Position? position = await getUserLocation(context);

    if(position == null)
    {
      showSnackBar(context, "Location not found. Please enable location services.");
      return;
    }

    bool result = validateForm(context);

    

    if(result)
    {
        setState(() {
          isSigningUp = true;
        });

    await Provider.of<AuthProvider>(context, listen: false).distributorSignUp(
        usernameController.text.trim().toString().toUpperCase(),
        selectedArea.toString().trim().toUpperCase(),
        GSTController.text.trim(),
        shopController.text.trim().toString().toUpperCase(),
        contactController.text.trim(),
        shopAddressController.text.trim(),
        position.latitude.toString(),
        position.longitude.toString());

    setState(() {
      // showAlertDialog(context);
      isSigningUp = false;
      Navigator.pushReplacementNamed(context , '/afterSignUp');
    });
  }

    
  }

  showSnackBar(BuildContext context , String msg)
  {
    final snackBar = SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Fill All Fields!',
                                        message: msg
                                            ,

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.help,
                                      ),
                                    );

    // Show the snackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



  validateForm(BuildContext context)
  {
    if(usernameController.text==null || usernameController.text.trim() == "")
    {
      showSnackBar(context , "username should not be empty");
      return false;
    }
    if(shopAddressController.text == null || shopAddressController.text.trim() == "")
    {
      showSnackBar(context , "shopAddress should not be empty");
      return false;
    }
    if(shopController.text == null || shopController.text.trim() == "")
    {
      showSnackBar(context , "shop name should not be empty");
      return false;
    }
    if(GSTController.text == null || GSTController.text.trim() == "")
    {
      showSnackBar(context , "Please enter your GST Number");
      return false;
    }
    if(contactController.text == null || contactController.text.trim() == "" || contactController.text.trim().length!=10)
    {
      showSnackBar(context , "Mobile number not valid");
      return false;
    }
    if(selectedArea == null)
    {
      showSnackBar(context , "Selecting your area is necessary!");
      return false;
    }
    return true;
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
        builder: (context) => PlatformDialog(
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
                          "assets/odo.png",
                          height: MediaQuery.of(context).size.height * 0.2,
                          fit: BoxFit.contain,
                        ),
                        const Text(
                          "Get On Board!",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                            "Create your profile to join ODO!",
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
                      labelText: "YOUR SHOP",
                      controller: shopController,
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
                      labelText: "GST/PAN-CARD NO.",
                      controller: GSTController,
                      type: TextInputType.visiblePassword,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PlatformTextField(
                      labelText:"Shop Address",
                      controller : shopAddressController,
                      type : TextInputType.multiline,
                      maxLines : 3
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
                              color: Colors.black),
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
                                onPressed: () async{
                                  setState(() {
                                    isSigningUp = true;
                                  });
                                  await signUp(context);
                                  setState(() {
                                    isSigningUp = false;
                                  });
                                },
                                color: Colors.black,
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
