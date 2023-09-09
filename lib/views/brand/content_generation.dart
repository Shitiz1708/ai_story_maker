import 'package:ai_story_maker/controllers/content_writer_controller.dart';
import 'package:ai_story_maker/controllers/firebase_controller.dart';
import 'package:ai_story_maker/model/brand_data.dart';
import 'package:ai_story_maker/views/auth/forgot_password.dart';
import 'package:ai_story_maker/views/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/text_style.dart';
import '../widgets/text_field.dart';
import 'response_data.dart';

class ContentGeneration extends StatefulWidget {
  final String? title;

  const ContentGeneration({
    super.key,
    this.title,
  });

  @override
  State<ContentGeneration> createState() => _ContentGenerationState();
}

class _ContentGenerationState extends State<ContentGeneration> {
  final TextEditingController _descriptionController = TextEditingController();
  final _focusDescription = FocusNode();

  String? _errorDescription;
  String? __type;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      firebaseController.getAllBrand();
    });
    super.initState();
  }

  final ContentWriterController _contentWriterController =
      Get.put(ContentWriterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context, widget.title ?? "Content Generation"),
      body: GetBuilder<FirebaseController>(
          init: FirebaseController(),
          builder: (controller) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.0001),
                                spreadRadius: 1,
                                blurRadius: 10)
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<Branddata>(
                                value: controller.selectedBrand,
                                isDense: true,
                                style: sfBold.copyWith(color: Colors.black),
                                onChanged: (Branddata? newValue) {
                                  controller.setSelectedBrand(newValue!);
                                },
                                items: <Branddata>[...controller.brandData]
                                    .map<DropdownMenuItem<Branddata>>(
                                      (Branddata value) =>
                                          DropdownMenuItem<Branddata>(
                                        value: value,
                                        child: Text(
                                          value.name ?? '',
                                        ),
                                      ),
                                    )
                                    .toList(),
                                decoration: InputDecoration(
                                  hintText: "Select Brand",
                                  hintStyle: sfSemiBold.copyWith(
                                      color: Colors.grey, fontSize: 18),
                                  prefixIcon: const Icon(
                                    Icons.generating_tokens,
                                    size: 30,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.0001),
                                spreadRadius: 1,
                                blurRadius: 10)
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: __type,
                                isDense: true,
                                style: sfBold.copyWith(color: Colors.black),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    __type = newValue;
                                  });
                                },
                                items: <String>[
                                   "Hashtag Generator","Keyword Generator","Blogs and Articles","Instagram Post Generator","YouTube Script Generator","Infographic Creator", "Social Media Content Calendar","Email Newsletter Generator","Product Description Generator",
  "Survey and Poll Generator",
  "Language Translation Tool",
  "Plagiarism Checker"
                                ]
                                    .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                decoration: InputDecoration(
                                  hintText: "Select Type",
                                  hintStyle: sfSemiBold.copyWith(
                                      color: Colors.grey, fontSize: 18),
                                  prefixIcon: const Icon(
                                    Icons.generating_tokens,
                                    size: 30,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyTextField(
                        controller: _descriptionController,
                        focusNode: _focusDescription,
                        errorText: _errorDescription,
                        inputAction: TextInputAction.next,
                        icon: Icons.store_mall_directory,
                        hintText: "Describe Your Content",
                        inputType: TextInputType.text,
                        isEnabled: true,
                        fillColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          title: "Generate",
                          onTap: () {
                            _contentWriterController.processContentWrite(
                                controller.selectedBrand!.name!,
                                __type!,
                                _descriptionController.text);
                          },
                        ),
                      ),
                      const ResponseData()
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
