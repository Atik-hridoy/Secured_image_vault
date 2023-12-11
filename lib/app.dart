import 'package:flutter/material.dart';
import 'package:secured_image_vault/src/screens/gallery_screen.dart';
import 'package:secured_image_vault/src/screens/sign_in_screen.dart';
import 'package:secured_image_vault/src/screens/splash_screen.dart';

import 'src/screens/registration_screen.dart';

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
      home: GalleryScreen(),
    );
  }
}
