import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lip_reading/features/onboarding/widgets/lipreading_logo_and_name.dart';
import 'package:lip_reading/features/onboarding/widgets/get_started_button.dart';
import 'package:lip_reading/features/onboarding/widgets/image_and_text.dart';

import '../../core/theming/style.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
            child: Column(
              children: [
                const LipReadingLogoAndName(),
                SizedBox(height: 30.h,),
                const DoctorImageAndText(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h,),
                      Text(
                        'Unlock the world of silent communication. Experience the future of understanding through lip reading technology.',
                        style: TextStyles.font13GrayRegular,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30.h),
                      const GetStartedButton(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
