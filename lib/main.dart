import 'package:flutter/material.dart';
import 'package:lip_reading/core/routing/app_router.dart';
import 'package:lip_reading/lip_reading_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(LipReadingApp(
    appRouter: AppRouter(),
  ));
}
