// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zero/controllers/login_controller.dart';


import 'package:zero/firebase_options.dart';

import 'package:zero/pages/Welcome/signinpage.dart';


// import 'package:zero/pages/repository/authentication_repository/authentication_repository.dart';

import 'package:zero/services/notification_service.dart';

import 'package:zero/styles/color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initNotification();
  runApp(const MyAppAdmin());
}

class MyAppAdmin extends StatelessWidget {
  const MyAppAdmin({Key? key}) : super(key: key);
  
  

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: background,
          fontFamily: 'FjallaOne',
          useMaterial3: true,
        ),
        home: SignInPage(), // Set Screen widget as the home screen
      );
  }
}
