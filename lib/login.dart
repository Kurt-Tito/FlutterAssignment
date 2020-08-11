import 'package:HiringAssignment/constants.dart';
import 'package:HiringAssignment/customwidgets/filledbutton.dart';
import 'package:HiringAssignment/home.dart';
import 'package:HiringAssignment/usermanagement.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<Login> {
  // Instantiate user for login
  UserManagement user = new UserManagement();

  @override
  void initState() {
    super.initState();
    // Checks to see if user is already logged in, if so authenticate via biometric authentication (fingerprint)
    user.authenticateUser(() {
      // Navigates to Home page after successful authentication
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home(userName: user.userName,)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Creates a top bar with a text in the center
        title: Center(child: Text("User Login")),
      ),
      body: Center( // Creates a centered column of two buttons (Facebook Login and Instagram Login)
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: Constants.BUTTON_HEIGHT,
              width: Constants.BUTTON_WIDTH,
              child: filledButton("Login with Facebook", Colors.white, Colors.blue[300], Colors.lightBlue[300], Colors.white, () async {
                String name = await user.facebookSignIn(); // Login User via facebook account and store user's name to string name
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home(userName: name,))); // Navigate to Home page while passing the String 'name' in constructor
              })),
            SizedBox(height: 20.0),
            Container(
              height:  Constants.BUTTON_HEIGHT,
              width: Constants.BUTTON_WIDTH,
              // BUTTON NOT IN USE
              child: filledButton("Login with Instagram", Colors.white, Colors.blueGrey[100], Colors.blueGrey[50], Colors.white, () {})),
            SizedBox(height: 75.0),
            Icon(Icons.fingerprint, size: 75.0, color: Colors.blue[100],),
          ],
        ),
      ),
    );
  }
}