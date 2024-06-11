
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theming/style.dart';

class LipReadingLogoAndName extends StatelessWidget {
  const LipReadingLogoAndName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/svgs/lipReading_logo.svg'),
        SizedBox(width: 10.w,),
        Text(
          'LipReading',
          style: TextStyles.font24BlackBold,
        ),
      ],
    );
  }
}
