
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/* Authentication Service class to handle Biometric Authentication */

class AuthenticationService {
  // Initialize localAuthentication and boolean variables
  LocalAuthentication _authentication; // LocalAuthentication plugin for authenticating the user
  bool _checkBio; // boolean to check if Biometrics available
  bool _isBioFinger; // boolean to check if fingerprint biometric is available

  // Default Constructor
  AuthenticationService() {
    _authentication = new LocalAuthentication();
    _checkBio = false;
    _isBioFinger = false;
  }

  /* Method to check if device can do Biometrics authentication,
      if so prints true to console, otherise prints false */
  void checkBiometrics() async {
    try {
      final bio = await _authentication.canCheckBiometrics;
      _checkBio = bio;
      print('Biometrics = $_checkBio');
    } catch (e) {
      print(e);
    }
  }

  /* Method to check all available Biometrics and prints to console as a list */
  void getAvailableBiometrics() async {
    List<BiometricType> _listType;
    try {
      _listType = await _authentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    print('List Biometrics = $_listType');

    if (_listType.contains(BiometricType.fingerprint)) {
      _isBioFinger = true;
    }
    print('Fingerprint is $_isBioFinger');
  }

  /* Method to authenticate user via Fingerprint Authentication
     if user is successfully authenticated, method runs passed in function myfunction() */
  void startAuth(myfunction()) async {
    bool _isAuthenticated = false;
    try {
        _isAuthenticated = await _authentication.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint',
        useErrorDialogs: true,
        stickyAuth: true
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (_isAuthenticated) {
       myfunction();
    }
  }
}