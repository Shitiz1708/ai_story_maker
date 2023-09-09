import 'package:ai_story_maker/controllers/auth_controller.dart';
import 'package:ai_story_maker/controllers/firebase_controller.dart';
import 'package:ai_story_maker/controllers/stable_diffusion_controller.dart';
import 'package:ai_story_maker/model/brand_data.dart';
import 'package:ai_story_maker/views/auth/forgot_password.dart';
import 'package:ai_story_maker/views/auth/register_screen.dart';
import 'package:ai_story_maker/views/brand/add_brand.dart';
import 'package:ai_story_maker/views/profiles/child_profiles.dart';
import 'package:ai_story_maker/views/widgets/app_button.dart';
import 'package:ai_story_maker/views/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../utils/text_style.dart';

class CreateStory extends StatefulWidget {
  const CreateStory({super.key});

  @override
  State<CreateStory> createState() => _CreateStoryState();
}

class _CreateStoryState extends State<CreateStory> {
  final TextEditingController _additionalController = TextEditingController();
  final _focusAdditional = FocusNode();
  String? _errorAdditional;
  final TextEditingController _descriptionController = TextEditingController();
  final _focusDescription = FocusNode();
  String? _errorDescription;

  List<String> storyCategories = [
    "Linkedin Post",
    "Instagram Post",
    "Facebook Post",
    "Blog Post Image",
    "Brand Promotion Thumbnail",
    "Youtube Thumbnail",
    "Product Mockup",
  ];

  List<String> demography = [
    "Rajasthan",
    "Kerela",
    "Mexico",
    "Japan",
    "Arab",
    "Africa",
  ];

  List<String> sizes = ["portrait", "landscape", "square"];

  String? type;
  String? demographyS;
  String? size = "landscape";

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      firebaseController.getAllBrand();
    });

    super.initState();
  }

  final StableDiffusionController _stableDiffusionController =
      Get.put(StableDiffusionController());
  @override
  void dispose() {
    _stableDiffusionController.setFinalLoadin(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirebaseController>(
        init: FirebaseController(),
        builder: (controller) {
          return Stack(
            children: [
              Positioned.fill(
                child: Scaffold(
                  appBar: appBarWidget(context, "Define Your Story"),
                  body: SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Brand",
                            style: sfBold.copyWith(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
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
                                  child: DropdownButtonFormField<Branddata>(
                                    value: controller.selectedBrand,
                                    isDense: true,
                                    style: sfBold.copyWith(color: Colors.black),
                                    onChanged: (Branddata? newValue) {
                                      controller.setSelectedBrand(newValue!);
                                    },
                                    items: <Branddata>[
                                      ...controller.brandData.toSet()
                                    ]
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
                                      hintText: "Select Brand's Name",
                                      hintStyle: sfSemiBold.copyWith(
                                          color: Colors.grey, fontSize: 18),
                                      prefixIcon: const Icon(
                                        Icons.generating_tokens,
                                        size: 30,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Get.to(() => const BrandManagementScreen());
                                  },
                                  child: const Text("Add Brand"))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Select Image Type",
                            style: sfBold.copyWith(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
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
                                    value: type,
                                    isDense: true,
                                    style: sfBold.copyWith(color: Colors.black),
                                    onChanged: (String? newValue) {
                                      type = newValue;
                                      setState(() {});
                                    },
                                    items: <String>[...storyCategories]
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
                                      hintText: "Select Category",
                                      hintStyle: sfSemiBold.copyWith(
                                          color: Colors.grey, fontSize: 18),
                                      prefixIcon: const Icon(
                                        Icons.generating_tokens,
                                        size: 30,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                          Text(
                            "Select Demography",
                            style: sfBold.copyWith(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
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
                                    value: demographyS,
                                    isDense: true,
                                    style: sfBold.copyWith(color: Colors.black),
                                    onChanged: (String? newValue) {
                                      demographyS = newValue;
                                      setState(() {});
                                    },
                                    items: <String>[...demography]
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
                                      hintText: "Select Demography",
                                      hintStyle: sfSemiBold.copyWith(
                                          color: Colors.grey, fontSize: 18),
                                      prefixIcon: const Icon(
                                        Icons.generating_tokens,
                                        size: 30,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                          Text(
                            "Reference Image Link",
                            style: sfBold.copyWith(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                            controller: _descriptionController,
                            focusNode: _focusDescription,
                            errorText: _errorDescription,
                            inputAction: TextInputAction.next,
                            icon: Icons.store_mall_directory,
                            hintText: "Reference Image Link",
                            inputType: TextInputType.text,
                            isEnabled: true,
                            fillColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Description",
                            style: sfBold.copyWith(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                            controller: _additionalController,
                            focusNode: _focusAdditional,
                            errorText: _errorAdditional,
                            inputAction: TextInputAction.next,
                            icon: Icons.store_mall_directory,
                            hintText: "Brief Description of the Post",
                            inputType: TextInputType.text,
                            isEnabled: true,
                            fillColor: Colors.white,
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(
                          //   "Example:\nThe Monster learns to make Friends\nAdventure of Children Park\nThe Legends of School",
                          //   style: sfLight.copyWith(color: Colors.white),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Select Image Size",
                            style: sfBold.copyWith(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 150,
                            child: GridView.builder(
                              itemCount: sizes.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 0,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    size = sizes[index];
                                    setState(() {});
                                  },
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: size == sizes[index]
                                              ? Colors.black
                                              : Colors.transparent,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          clipBehavior: Clip.antiAlias,
                                          margin: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Image.asset(
                                            "assets/app_logo.png",
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          sizes[index].capitalizeFirst!,
                                          style: sfBold.copyWith(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ]),
                  )),
                  bottomNavigationBar: GetBuilder<StableDiffusionController>(
                      init: StableDiffusionController(),
                      builder: (stableDiffusionController) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          child: AppButton(
                            isLoading: stableDiffusionController.isFinalLoading,
                            title: "Start the Magic",
                            onTap: () async {
                              stableDiffusionController.setFinalLoadin(true);
                              await stableDiffusionController
                                  .generateImageViaImage(
                                      data: controller.selectedBrand,
                                      imageURL: _descriptionController.text,
                                      type: type,
                                      description: _additionalController.text,
                                      model: "",
                                      size: size,
                                      demography: demographyS);
                            },
                          ),
                        );
                      }),
                ),
              ),
            ],
          );
        });
  }
}
