import 'dart:convert';
import 'package:HiringAssignment/services/authenticationservice.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class UserManagement extends AuthenticationService{
  static final FacebookLogin facebookLogin = new FacebookLogin();
  String userName = '';

  UserManagement ();

  // Method that authenticates user and returns their name as a string
  Future<String> facebookSignIn() async {
    final result = await facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    final profile = json.decode(graphResponse.body);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        this.userName = profile['name'].toString();
        return profile['name'].toString();
        break;
      case FacebookLoginStatus.cancelledByUser:
        // Display message here for when login is cancelled by user
        break;
      case FacebookLoginStatus.error:
        // Display message here for when there's an error in login process
        break;
    }
    // if could not authenticate, return 'user not logged in'
    return "User not logged in";
  }

  // Returns a future to check if user is currently logged in
  Future<bool> isLoggedIn() async {
     return await facebookLogin.isLoggedIn;
  }

  // Future method to sign out the current user
  Future<void> signOut() async {
    await facebookLogin.logOut();
  }

  // Method to get user's name
  String getUser() {
    return userName;
  }

  // Method to authenticate user
  void authenticateUser(myFunction()) async {
    if (await this.isLoggedIn()) {
      checkBiometrics();
      getAvailableBiometrics();
      startAuth(() => myFunction());
    }
  }
}