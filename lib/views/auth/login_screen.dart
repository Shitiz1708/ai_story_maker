import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/utilities.dart';
import '../widgets/app_button.dart';
import '../widgets/text_field.dart';
import 'forgot_password.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  bool isLoading = false;

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusUsername = FocusNode();

  String? _errorEmail;
  String? _errorPassword;

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
            return Positioned.fill(
              child: Scaffold(
                // ignore: prefer_const_constructors
                body: controller.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.black,
                      ))
                    : SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Image.asset(
                                    'assets/bg.png',
                                    height: 100,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                const Text(
                                  'Login Your Account',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 50),
                                MyTextField(
                                  controller: _emailController,
                                  focusNode: _focusEmail,
                                  errorText: _errorEmail,
                                  inputAction: TextInputAction.next,
                                  icon: Icons.person_outline,
                                  hintText: 'Enter Email',
                                  inputType: TextInputType.text,
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
                                const SizedBox(height: 10),
                                //forgot password
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Get.to(
                                            () => const ForgotPasswordScreen());
                                      },
                                      child: const Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 70,
                                    child: AppButton(
                                      title: 'Login',
                                      onTap: () async {
                                        UtilValidator.hiddenKeyboard(context);
                                        _errorEmail = UtilValidator.validate(
                                            _emailController.text,
                                            type: ValidateType.email);

                                        _errorPassword = UtilValidator.validate(
                                            _passwordController.text,
                                            type: ValidateType.password);

                                        setState(() {});
                                        if (_errorEmail == null &&
                                            _errorPassword == null) {
                                          await controller.signIn(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Don\'t have an account?',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            color: Colors.grey,
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
                                        color: Colors.grey,
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
                                              color:
                                                  Colors.grey.withOpacity(0.5),
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
                                                  fontWeight: FontWeight.bold),
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
            );
          }),
    );
  }
}
