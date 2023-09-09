import 'package:ai_story_maker/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/app_button.dart';
import 'story_type.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _focusEmail = FocusNode();
  String? _errorEmail;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CreateStoryButton(
                  image: "assets/logo.png",
                  title: "My Epic AI Stories",
                  subtitle: "Create YOUR Personalized Epic Adventure",
                  onTap: () {
                    Get.to(() => const StoryCreationScreen());
                  },
                ),

                // Search section
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateStoryButton extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? image;
  final VoidCallback? onTap;

  const CreateStoryButton({
    super.key,
    this.title,
    this.subtitle,
    this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(18),
        height: 120,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            )),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(image!),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  style: sfBold.copyWith(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  subtitle ?? '',
                  style: sfMedium.copyWith(fontSize: 10, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: 50,
                    child: AppButton(
                      onTap: () {
                        onTap!();
                      },
                      title: 'Create your Brand',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
