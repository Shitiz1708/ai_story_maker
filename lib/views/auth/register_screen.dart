import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/utilities.dart';
import '../widgets/app_button.dart';
import '../widgets/text_field.dart';
import 'login_screen.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  bool isLoading = false;

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusUsername = FocusNode();

  String? _errorEmail;
  String? _errorPassword;
  String? _errorUsername;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userName.dispose();
    _focusEmail.dispose();
    _focusUsername.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (controller) {
            return Stack(
              children: [
                const BackgroundImage(),
                Positioned.fill(
                  child: Scaffold(
                    body: controller.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.black,
                          ))
                        : SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 20),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/bg.png',
                                          height: 100,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 50),
                                    const Text(
                                      'Create Your Account',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 30),
                                    MyTextField(
                                      controller: _userName,
                                      focusNode: _focusUsername,
                                      errorText: _errorUsername,
                                      inputAction: TextInputAction.next,
                                      icon: Icons.person_outline,
                                      hintText: 'User Name',
                                      inputType: TextInputType.text,
                                      isEnabled: true,
                                      fillColor: Colors.white,
                                    ),
                                    const SizedBox(height: 20),
                                    MyTextField(
                                      controller: _emailController,
                                      focusNode: _focusEmail,
                                      errorText: _errorEmail,
                                      icon: Icons.mail_outline,
                                      hintText: 'Email Address',
                                      inputAction: TextInputAction.next,
                                      inputType: TextInputType.emailAddress,
                                      isEnabled: true,
                                      fillColor: Colors.white,
                                    ),
                                    const SizedBox(height: 20),
                                    MyTextField(
                                      controller: _passwordController,
                                      focusNode: _focusPassword,
                                      errorText: _errorPassword,
                                      icon: Icons.lock_outline,
                                      hintText: 'Password',
                                      inputAction: TextInputAction.done,
                                      inputType: TextInputType.visiblePassword,
                                      isEnabled: true,
                                      // isObscureText: true,
                                      // isPassword: true,
                                      fillColor: Colors.white,
                                    ),
                                    const SizedBox(height: 30),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 70,
                                        child: AppButton(
                                          title: 'Register',
                                          onTap: () async {
                                            UtilValidator.hiddenKeyboard(
                                                context);
                                            _errorEmail =
                                                UtilValidator.validate(
                                                    _emailController.text,
                                                    type: ValidateType.email);

                                            _errorUsername =
                                                UtilValidator.validate(
                                              _userName.text,
                                            );
                                            _errorPassword =
                                                UtilValidator.validate(
                                                    _passwordController.text,
                                                    type:
                                                        ValidateType.password);

                                            setState(() {});
                                            if (_errorEmail == null &&
                                                _errorPassword == null &&
                                                _errorUsername == null) {
                                              await controller.signUp(
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                                username: _userName.text,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Already have an account?',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.to(() => const LoginView());
                                          },
                                          child: const Text(
                                            'Login',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Color(0xffC2C3CB),
                                      thickness: 1,
                                    ),
                                    const SizedBox(height: 20),
                                    const Center(
                                      child: Text(
                                        'Continue with social media',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18),
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            controller.googleSignIn();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xffEBEDF2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(width: 20),
                                                Image.asset(
                                                  'assets/Vector.png',
                                                  height: 30,
                                                  width: 30,
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  'Google    ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: Stack(
      children: [
        // Positioned.fill(
        //   child: Image.asset(
        //     "assets/bgr.png",
        //     fit: BoxFit.fitHeight,
        //   ),
        // ),
        Positioned.fill(
            child: Container(
          color: Colors.white,
        )),
      ],
    ));
  }
}
