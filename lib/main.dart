import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:hyper_garage_sale/pages/app_navigation.dart';
import 'package:hyper_garage_sale/pages/root_page.dart';
import 'package:hyper_garage_sale/pages/view_post.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MapView.setApiKey("AIzaSyB6OcQBb_6dYo6QYeiFnfFYHzWmPg4O6Ds");
  await firebase_core.Firebase.initializeApp();

  runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => RootPage(),
        '/navigation': (context) => AppNavigation(),
        '/view_post': (context) => ViewPost(),
      },
  ));
}




