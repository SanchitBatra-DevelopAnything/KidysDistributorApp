import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 229, 229),
        body: Column(
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
                  Icons.assignment,
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
            SizedBox(
              height: 10,
            ),
            ListTile(
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
        ),
      ),
    );
  }
}
