import 'package:ai_story_maker/views/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'create_story.dart';
import 'library_screen.dart';

class StoryCreationScreen extends StatefulWidget {
  const StoryCreationScreen({super.key});

  @override
  StoryCreationScreenState createState() => StoryCreationScreenState();
}

class StoryCreationScreenState extends State<StoryCreationScreen> {
  // For Simple and Freestyle options
  String selectedMoral = '';
  String selectedDuration = '';
  String selectedCategory = '';

  // For Freestyle option
  TextEditingController storyTextController = TextEditingController();

  @override
  void dispose() {
    storyTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Positioned.fill(
          child: SafeArea(
            child: Scaffold(
              body: Center(
                child: CreateStoryButton(
                  image: "assets/app_logo.png",
                  title: "Use a Template",
                  subtitle: "Create YOUR Personalized Epic Adventure",
                  onTap: () {
                    Get.to(() => const CreateStory());
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void main() => runApp(const MaterialApp(home: StoryCreationScreen()));
