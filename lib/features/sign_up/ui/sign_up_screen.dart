// ignore_for_file: use_build_context_synchronously, unused_local_variable, avoid_print

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lip_reading/core/helpers/extensions.dart';
import 'package:lip_reading/core/helpers/spacing.dart';
import 'package:lip_reading/core/routing/routes.dart';
import 'package:lip_reading/core/theming/style.dart';
import 'package:lip_reading/core/widgets/app_text_button.dart';
import 'package:lip_reading/core/widgets/app_text_form_field.dart';
import 'package:lip_reading/features/login/ui/widgets/terms_and_conditions_text.dart';
import 'package:lip_reading/features/sign_up/ui/widgets/already_have_account.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isObscureText = true;

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: TextStyles.font24BlueBold,
                ),
                verticalSpace(8),
                Text(
                  'Sign up now and start exploring all that our app has to offer. We\'re excited to welcome you to our community!',
                  style: TextStyles.font14GrayRegular,
                ),
                verticalSpace(36),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      AppTextFormField(
                        hintText: 'Name',
                        myController: name,
                        validator: validateName,
                      ),
                      verticalSpace(18),
                      AppTextFormField(
                        hintText: 'Phone number',
                        myController: phone,
                        validator: validatePhone,
                      ),
                      verticalSpace(18),
                      AppTextFormField(
                        hintText: 'Email',
                        myController: email,
                        validator: validateEmail,
                      ),
                      verticalSpace(18),
                      AppTextFormField(
                        hintText: 'Password',
                        myController: password,
                        validator: validatePassword,
                        isObscureText: isObscureText,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isObscureText = !isObscureText;
                            });
                          },
                          child: Icon(
                            isObscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      verticalSpace(24),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyles.font13blueregular,
                        ),
                      ),
                      verticalSpace(40),
                      AppTextButton(
                        buttonText: 'Create Account',
                        textStyle: TextStyles.font16whitesemibold,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                              );
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Success',
                                desc:
                                    'Congratulations, you have signed up successfully',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {
                                  context.pushReplacementNamed(
                                      Routes.homepageScreen);
                                },
                              ).show();
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                // print('The password provided is too weak.');
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc: 'The password provided is too weak.',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {},
                                ).show();
                              } else if (e.code == 'email-already-in-use') {
                                // print('The account already exists for that email.');
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc:
                                      'The account already exists for that email.',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {},
                                ).show();
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                      ),
                      verticalSpace(16),
                      const TermsAndConditionsText(),
                      verticalSpace(60),
                      const AlreadyHaveAccountText(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
