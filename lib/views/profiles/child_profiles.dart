import 'dart:convert';
import 'dart:typed_data';

import 'package:ai_story_maker/controllers/auth_controller.dart';
import 'package:ai_story_maker/controllers/firebase_controller.dart';
import 'package:ai_story_maker/utils/text_style.dart';
import 'package:ai_story_maker/views/auth/register_screen.dart';
import 'package:ai_story_maker/views/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../auth/forgot_password.dart';
import '../brand/add_brand.dart';
import '../widgets/text_field.dart';

class ChildProfiles extends StatefulWidget {
  const ChildProfiles({super.key});

  @override
  State<ChildProfiles> createState() => _ChildProfilesState();
}

class _ChildProfilesState extends State<ChildProfiles> {
  bool isLoading = false;

  final _focusName = FocusNode();
  final _focusAge = FocusNode();

  String? _errorName;
  String? _errorAge;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      firebaseController.getAllBrand();
    });

    super.initState();
  }

  Image base64ImageWidget(String base64String) {
    Uint8List uint8List = base64.decode(base64String);
    return Image.memory(uint8List);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Positioned.fill(
          child: Scaffold(
            appBar: appBarWidget(context, "Brand's Profile"),
            backgroundColor: Colors.transparent,
            body: GetBuilder<FirebaseController>(
                init: FirebaseController(),
                builder: (controller) {
                  return controller.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.black,
                        ))
                      : SingleChildScrollView(
                          child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: firebaseController.brandData.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                      title: Text(firebaseController
                                              .brandData[index].name ??
                                          ""),
                                      leading: SizedBox(
                                        width: 80,
                                        height: 40,
                                        child: base64ImageWidget(
                                            firebaseController
                                                    .brandData[index].logo ??
                                                ""),
                                      )),
                                );
                              }),
                        ));
                }),
            floatingActionButton: InkWell(
              onTap: () {
                Get.to(() => const BrandManagementScreen());
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.add),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
