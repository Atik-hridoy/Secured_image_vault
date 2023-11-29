import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:secured_image_vault/screens/registration_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyA9hDMH1ocNwBIaq6sklcU74xDfLVMbURE",
          appId: "1:934229348374:android:52e5629e03f74e0590e537",
          messagingSenderId: "934229348374",
          projectId: "imagevaul"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secured image vault',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: RegistrationScreen(),
    );
  }
}
