import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/theming/style.dart';

class DoctorImageAndText extends StatelessWidget {
  const DoctorImageAndText({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset('assets/svgs/lipReading_logo_low_opacity.svg'),
        Container(
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.0),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [0.14, 0.4],
            ),
          ),
          child: Image.asset('assets/images/onboarding_robot_1-removebg.png'),
        ),
        Positioned(
          bottom: 5,
          left: 0,
          right: 0,
          child: Text(
            'Unlock speech through vision',
            // 'Best Doctor\nAppointment App',
            textAlign: TextAlign.center,
            style: TextStyles.font32BlueBold.copyWith(
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
