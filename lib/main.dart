import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:secured_image_vault/app.dart';
import 'package:secured_image_vault/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
