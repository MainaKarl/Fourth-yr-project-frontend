import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lip_reading/core/routing/app_router.dart';

import 'core/routing/routes.dart';
import 'core/theming/colors.dart';

class LipReadingApp extends StatelessWidget {
  final AppRouter appRouter;

  const LipReadingApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'Lip Reading App',
        theme: ThemeData(
          primaryColor: ColorsManager.mainBlue,
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? Routes.onBoardingScreen
            : Routes.homepageScreen,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}
