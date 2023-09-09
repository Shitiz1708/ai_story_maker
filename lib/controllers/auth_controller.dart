import 'package:ai_story_maker/controllers/firebase_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../views/auth/register_screen.dart';
import '../views/brand/add_brand.dart';
import '../views/dashboard/dashboard.dart';

FirebaseController firebaseController = Get.put(FirebaseController());

class AuthController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //check if user is logged in

  checkLogin(bool isNew) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      Get.offAll(() => const RegisterView());
    } else {
      await firebaseController.checkBrand();
      GetStorage().write('isLogged', true);
      if (isNew || firebaseController.isEmpty) {
        Get.offAll(() => const BrandManagementScreen());
      } else {
        Get.offAll(() => const DashBoardScreen());
      }
    }
  }

//logout
  logout() async {
    GetStorage().write("isLogged", false);
    await _auth.signOut();
    await GoogleSignIn().signOut();

    Get.offAll(() => const RegisterView());
  }

  bool _isNewUser = false;
  bool get isNewUser => _isNewUser;
  //google sign in
  Future<void> googleSignIn() async {
    _isLoading = true;
    update();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _isNewUser = userCredential.additionalUserInfo!.isNewUser;
      checkLogin(_isNewUser);
    } finally {
      _isLoading = false;
      update();
    }
  }

  //sign up with email and password and username
  Future<void> signUp(
      {required String email,
      required String password,
      required String username}) async {
    _isLoading = true;
    update();
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      //handle if user is already registered
      await _auth.currentUser!.updateDisplayName(username);
      _isNewUser = userCredential.additionalUserInfo!.isNewUser;

      checkLogin(_isNewUser);
    } finally {
      _isLoading = false;
      update();
    }
  }

  //sign in with email and password
  Future<void> signIn({required String email, required String password}) async {
    _isLoading = true;
    update();
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _isNewUser = userCredential.additionalUserInfo!.isNewUser;

      checkLogin(_isNewUser);
    } finally {
      _isLoading = false;
      update();
    }
  }

  //forgot password
  Future<void> resetPassword({required String email}) async {
    _isLoading = true;
    update();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Password reset link sent to your email',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.black);
    } finally {
      _isLoading = false;
      update();
    }
  }
}
