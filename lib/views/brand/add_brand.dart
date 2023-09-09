import 'dart:convert';
import 'dart:io';

import 'package:ai_story_maker/utils/text_style.dart';
import 'package:ai_story_maker/views/dashboard/dashboard.dart';
import 'package:ai_story_maker/views/widgets/app_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/firebase_controller.dart';
import '../../utils/utilities.dart';
import '../widgets/text_field.dart';

class BrandManagementScreen extends StatefulWidget {
  const BrandManagementScreen({
    super.key,
  });

  @override
  State<BrandManagementScreen> createState() => _BrandManagementScreenState();
}

class _BrandManagementScreenState extends State<BrandManagementScreen> {
  final TextEditingController brandNameController = TextEditingController();
  final FocusNode gumastafocusNode = FocusNode();
  String _gumastaError = "";

  //contact
  final TextEditingController categoryController = TextEditingController();
  final FocusNode mobilefocusNode = FocusNode();
  String _mobileError = "";

  //email

  final TextEditingController emailController = TextEditingController();
  final FocusNode emailfocusNode = FocusNode();
  String _emailError = "";

  //country

  final TextEditingController fbController = TextEditingController();
  final FocusNode countryfocusNode = FocusNode();
  final String _countryError = "";

  //state

  final TextEditingController linkedinController = TextEditingController();
  final FocusNode statefocusNode = FocusNode();
  final String _stateError = "";

  final TextEditingController instagramController = TextEditingController();
  final FocusNode aadharfocusNode = FocusNode();
  final String _aadharError = "";

  final TextEditingController websiteController = TextEditingController();
  final FocusNode panfocusNode = FocusNode();
  final String _panError = "";

  final FocusNode namefocusNode = FocusNode();
  final String _nameError = "";

  final TextEditingController logoController = TextEditingController();
  final FocusNode dobfocusNode = FocusNode();
  String _dobError = "";

  final TextEditingController sloganController = TextEditingController();
  final FocusNode ciblifocusNode = FocusNode();
  final String _cibilError = "";

  final TextEditingController shareController = TextEditingController();
  final FocusNode sharefocusNode = FocusNode();
  final String _shareError = "";

  final TextEditingController cibilFileController = TextEditingController();
  final String _cibilFileError = "";

  final TextEditingController projectFileController = TextEditingController();
  final String _projectFileError = "";
  final TextEditingController itrFileController = TextEditingController();
  final String _itrFileError = "";

  String _selectedITR = "";

  Future<void> _pickPDFFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpeg', 'jpg'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        setState(() {
          logoController.text = file.name;
        });
        _selectedITR = await fileToBase64(File(file.path!));
      }
    } catch (e) {
      print("Error");
    }
  }

  Future<String> fileToBase64(File? file) async {
    if (file == null) {
      return "";
    }

    List<int> fileBytes = await file.readAsBytes();
    String base64Image = base64Encode(fileBytes);
    return base64Image;
  }

  //pick date of birth
  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (date != null) {
      setState(() {
        logoController.text = date.toString().substring(0, 10);
      });
    }
  }

  @override
  void dispose() {
    brandNameController.dispose();

    gumastafocusNode.dispose();
    categoryController.dispose();
    mobilefocusNode.dispose();
    emailController.dispose();
    emailfocusNode.dispose();
    fbController.dispose();
    countryfocusNode.dispose();
    instagramController.dispose();
    aadharfocusNode.dispose();
    websiteController.dispose();
    panfocusNode.dispose();
    namefocusNode.dispose();
    logoController.dispose();
    dobfocusNode.dispose();
    sloganController.dispose();
    ciblifocusNode.dispose();
    shareController.dispose();
    sharefocusNode.dispose();
    cibilFileController.dispose();
    projectFileController.dispose();
    itrFileController.dispose();

    super.dispose();
  }

  FirebaseController firebaseController = Get.put(FirebaseController());

  bool _isLoading = false;
  void _submit() async {
    //validate all

    brandNameController.text.isEmpty
        ? _gumastaError = "Please enter Brand Name"
        : _gumastaError = "";

    categoryController.text.isEmpty
        ? _mobileError = "Please enter Category"
        : _mobileError = "";

    emailController.text.isEmpty
        ? _emailError = "Please enter Email"
        : _emailError = "";

    logoController.text.isEmpty
        ? _dobError = "Please Pick Logo"
        : _dobError = "";

    setState(() {});

    if (_gumastaError.isEmpty &&
        _mobileError.isEmpty &&
        _emailError.isEmpty &&
        _countryError.isEmpty &&
        _dobError.isEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        await firebaseController.insertBrandData(
          name: brandNameController.text,
          category: categoryController.text,
          email: emailController.text,
          facebook: fbController.text,
          linkedin: linkedinController.text,
          instagram: instagramController.text,
          website: websiteController.text,
          logo: _selectedITR,
          slogan: sloganController.text,
        );

        _showDialog(
            "Successfully Added", "Your details have been successfully Saved");

        //after 2 seconds
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
          Get.offAll(() => const DashBoardScreen());
        });
      } catch (e) {
        print(e);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

//show dialog
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Center(
            child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        )),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              "assets/success.json",
              height: 200,
              width: 200,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ],
        ),
        actions: const [
          // TextButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   child: const Text("OK"),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(18),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text("Add Brand Details",
                      style: sfBold.copyWith(fontSize: 20))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFieldWithTitle(
                      title: 'Brand Name',
                      icon: (Icons.branding_watermark),
                      hintText: 'Enter Brand Name',
                      textEditingController: brandNameController,
                      focusNode: gumastafocusNode,
                      errorText: _gumastaError,
                      isMandatory: true,
                    ),
                    const SizedBox(height: 16),
                    TextFieldWithTitle(
                      title: 'Brand Email',
                      hintText: 'Enter Brand Email',
                      icon: (Icons.email),
                      textEditingController: emailController,
                      focusNode: emailfocusNode,
                      errorText: _emailError,
                      isMandatory: true,
                    ),
                    const SizedBox(height: 16),
                    TextFieldWithTitle(
                      title: 'Category',
                      icon: (Icons.category),
                      hintText: 'Enter Brand Category',
                      textEditingController: categoryController,
                      focusNode: mobilefocusNode,
                      errorText: _mobileError,
                      isMandatory: true,
                    ),
                    const SizedBox(height: 16),
                    TextFieldWithTitle(
                      title: 'Slogan',
                      isMandatory: true,
                      hintText: 'Enter Brand Slogan',
                      icon: (Icons.subtitles),
                      textEditingController: sloganController,
                      focusNode: countryfocusNode,
                      errorText: _countryError,
                    ),
                    const SizedBox(height: 16),
                    TextFieldWithTitle(
                      title: 'Linkedin Handler',
                      hintText: 'Enter Linkedin Handler Link',
                      icon: (Icons.feed),
                      textEditingController: linkedinController,
                      focusNode: statefocusNode,
                      errorText: _stateError,
                    ),
                    const SizedBox(height: 16),
                    TextFieldWithTitle(
                      title: 'Instagram Handler',
                      hintText: 'Enter Instagram Handler Link',
                      icon: (Icons.feed),
                      textEditingController: instagramController,
                      focusNode: aadharfocusNode,
                      errorText: _aadharError,
                    ),
                    const SizedBox(height: 16),
                    TextFieldWithTitle(
                      title: 'Facebook Handler',
                      icon: (Icons.facebook),
                      hintText: 'Enter Facebook Handler',
                      textEditingController: fbController,
                      focusNode: panfocusNode,
                      errorText: _panError,
                    ),
                    const SizedBox(height: 16),
                    TextFieldWithTitle(
                      title: 'Website',
                      icon: (Icons.web_stories),
                      hintText: 'Enter Website Link',
                      textEditingController: websiteController,
                      focusNode: namefocusNode,
                      errorText: _nameError,
                    ),
                    const SizedBox(height: 16),
                    TextFieldWithTitle(
                        title: 'Upload Brand Logo',
                        hintText: 'Upload Brand Logo',
                        icon: (Icons.branding_watermark_sharp),
                        isMandatory: true,
                        textEditingController: logoController,
                        errorText: _itrFileError,
                        suffixIcon: () {
                          _pickPDFFile();
                        }),
                    const SizedBox(height: 32),
                    AppButton(
                      isLoading: _isLoading,
                      onTap: () {
                        UtilValidator.hiddenKeyboard(context);
                        _submit();
                      },
                      title: ('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldWithTitle extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final VoidCallback? suffixIcon;
  final IconData? icon;
  final String? errorText;
  final bool? isEnabled;
  final bool? isMandatory;

  const TextFieldWithTitle({
    super.key,
    required this.title,
    required this.hintText,
    this.textEditingController,
    this.focusNode,
    this.nextFocusNode,
    this.suffixIcon,
    this.icon,
    this.errorText,
    this.isEnabled = true,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: isMandatory! ? ' *' : "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            )),
        const SizedBox(height: 8),
        MyTextField(
          isEnabled: isEnabled!,
          hintText: hintText,
          controller: textEditingController,
          focusNode: focusNode,
          icon: icon,
          nextFocus: nextFocusNode,
          errorText: errorText,
          onChanged: (value) {},
          onTap: () {
            if (suffixIcon != null) {
              suffixIcon!();
            }
          },
          onSubmit: () {
            focusNode!.unfocus(); // Hide keyboard
            FocusScope.of(context)
                .requestFocus(nextFocusNode); // Move focus to the next field
          },
        ),
      ],
    );
  }
}
