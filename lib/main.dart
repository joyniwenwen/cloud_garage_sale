import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:hyper_garage_sale/pages/app_navigation.dart';
import 'package:hyper_garage_sale/pages/root_page.dart';
import 'package:hyper_garage_sale/pages/view_post.dart';
import 'package:hyper_garage_sale/pages/image_detail.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();

  runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => RootPage(),
        '/navigation': (context) => AppNavigation(),
        '/view_post': (context) => ViewPost(),
        '/image_detail': (context) => ImageDetail(),
      },
  ));
}




