import 'package:flutter/material.dart';
import 'package:hyper_garage_sale/pages/login_signup.dart';
import 'package:hyper_garage_sale/services/authentication.dart';
import 'package:hyper_garage_sale/pages/app_navigation.dart';
import 'package:hyper_garage_sale/models/user_profile.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {

  final BaseAuth auth = new Auth();

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String _email = "";

  // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;

  void _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      if (this.mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
      placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude).then(
              (List<Placemark> p) {
            Placemark place = p[0];
            if (this.mounted) {
              setState(() {
                _currentAddress =
                "${place.name}, ${place.locality}, ${place
                    .administrativeArea}, ${place.postalCode}, ${place
                    .country}";
              });
            }
          }
      ).catchError((e) => print(e));
    });
  }

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
          _email = user?.email;
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
    _getCurrentLocation();
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        _email = user.email;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      _email = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return LoginSignup(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null && _currentAddress != null && _currentPosition != null) {
          UserProfile userProfile = UserProfile(
              userId: _userId,
              email: _email,
              currentAddress: _currentAddress,
              currentPosition: _currentPosition
          );
          print(userProfile.currentAddress);
          return AppNavigation(
            logoutCallback: logoutCallback,
            userProfile: userProfile
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
