import 'package:ai_story_maker/views/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/text_style.dart';
import '../widgets/text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _focusEmail = FocusNode();
  String? _errorEmail;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Positioned.fill(
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: appBarWidget(context, "Forgot Password"),
              body: Padding(
                padding: const EdgeInsets.all(18.0),
                child: GetBuilder<AuthController>(
                    init: AuthController(),
                    builder: (controller) {
                      return Column(
                        children: [
                          const SizedBox(height: 40),
                          MyTextField(
                            controller: _emailController,
                            focusNode: _focusEmail,
                            errorText: _errorEmail,
                            inputAction: TextInputAction.next,
                            icon: Icons.email,
                            hintText: 'Enter Email',
                            inputType: TextInputType.text,
                            isEnabled: true,
                            fillColor: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                                'We will send you a link to reset your password on your email',
                                style: sfSemiBold.copyWith(
                                  fontSize: 18,
                                  color: const Color(0xff7A7D84),
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: double.infinity,
                              height: 50,
                              child: controller.isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ))
                                  : ElevatedButton(
                                      onPressed: () {
                                        if (_emailController.text.isEmpty) {
                                          setState(() {
                                            _errorEmail = 'Email is required';
                                          });
                                        } else {
                                          setState(() {
                                            _errorEmail = null;
                                          });
                                          controller.resetPassword(
                                              email: _emailController.text);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .secondaryHeaderColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        'Send',
                                        style: sfBold.copyWith(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      );
                    }),
              )),
        ),
      ],
    );
  }
}

AppBar appBarWidget(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5), shape: BoxShape.circle),
      margin: const EdgeInsets.only(left: 10),
      child: Center(
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
    centerTitle: false,
    title: Text(
      title,
      style: sfBold.copyWith(color: Colors.black),
    ),
  );
}
