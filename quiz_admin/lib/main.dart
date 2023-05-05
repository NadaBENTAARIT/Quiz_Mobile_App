import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quiz_app/screens/manage_quiz/indexmanage.dart';
import 'package:quiz_app/screens/create_quiz/create_quiz.dart';



import 'package:quiz_app/screens/welcome_screen.dart';
import 'package:quiz_app/util/bindings_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: BilndingsApp(),
      title: 'Flutter Quiz App',
      home: WelcomeScreen(),
      getPages: [


        
      ],
    );
  }
}
