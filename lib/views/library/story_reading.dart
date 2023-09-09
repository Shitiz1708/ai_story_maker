import 'dart:convert';
import 'dart:io';

import 'package:ai_story_maker/controllers/auth_controller.dart';
import 'package:ai_story_maker/controllers/content_writer_controller.dart';
import 'package:ai_story_maker/controllers/stable_diffusion_controller.dart';
import 'package:ai_story_maker/utils/text_style.dart';
import 'package:ai_story_maker/views/dashboard/dashboard.dart';
import 'package:ai_story_maker/views/widgets/app_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:ui' as ui;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_editor_plus/image_editor_plus.dart' as editor;

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

final GlobalKey widgetKey = GlobalKey();

class StoryViewingScreen extends StatefulWidget {
  final String? imageUrl;
  final String? data;
  final bool? history;

  const StoryViewingScreen({
    super.key,
    required this.imageUrl,
    required this.data,
    this.history = false,
  });

  @override
  _StoryViewingScreenState createState() => _StoryViewingScreenState();
}

class _StoryViewingScreenState extends State<StoryViewingScreen> {
  _saveNetworkImage(String url) async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "PromoGen.AI");

    Get.snackbar('Download', "Image Saved Successfully",
        snackPosition: SnackPosition.BOTTOM);
  }

  Uint8List? imageData;

  Future<void> saveWidgetAsImage(
      GlobalKey widgetKey, String fileName, bool edit) async {
    try {
      RenderRepaintBoundary boundary =
          widgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(
          pixelRatio: 3.0); // Adjust the pixelRatio as needed for image quality
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List uint8List = byteData!.buffer.asUint8List();
      final buffer = uint8List.buffer.asUint8List();

      final directory = (await getApplicationDocumentsDirectory()).path;
      final filePath = '$directory/$fileName.png';

      await File(filePath).writeAsBytes(buffer);
      print('Image saved as $filePath');
      imageData = buffer;
      setState(() {});

      if (edit) {
      } else {
        final result = await ImageGallerySaver.saveImage(buffer,
            name: 'watermarked_image');

        Get.snackbar('Download', "Image Saved Successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black,
            colorText: Colors.white);
      }
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  // Future<Uint8List> imageUrlToUint8List(String imageUrl) async {
  //   final response = await http.get(Uri.parse(imageUrl));

  //   if (response.statusCode == 200) {
  //     final List<int> bytes = response.bodyBytes;
  //     return Uint8List.fromList(bytes);
  //   } else {
  //     throw Exception('Failed to load image from URL');
  //   }
  // }

  final StableDiffusionController _stableDiffusionController =
      Get.put(StableDiffusionController());
  @override
  void initState() {
    if (!widget.history!) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _stableDiffusionController.setFinalLoadin(false);
        firebaseController.insertPosts(
            data: widget.data ?? '',
            image: widget.imageUrl ?? '',
            brandName: firebaseController.selectedBrand!.name!);
      });
    }
    super.initState();
  }

  bool _edited = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.off(() => const DashBoardScreen());
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Container(
            height: 30,
            width: 30,
            decoration:
                const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
            margin: const EdgeInsets.only(left: 10),
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.off(() => const DashBoardScreen());
                },
              ),
            ),
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "Result",
            style: sfBold.copyWith(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: GetBuilder<ContentWriterController>(
              init: ContentWriterController(),
              builder: (controllerContent) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              border: Border.all(
                                width: 5,
                              ),
                            ),
                            child: imageData != null
                                ? WatermarkedImage(
                                    imageData: imageData,
                                    edited: _edited,
                                    watermark:
                                        firebaseController.selectedBrand!.logo,
                                  )
                                : WatermarkedImage(
                                    original: widget.imageUrl!,
                                    edited: _edited,
                                    watermark:
                                        firebaseController.selectedBrand!.logo,
                                  )
                            // : Image.network(
                            //     widget.imageUrl!,
                            //   ),
                            ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                width: 100,
                                child: AppButton(
                                  title: "Edit",
                                  onTap: () async {
                                    await saveWidgetAsImage(
                                        widgetKey, 'watermarked_image', true);
                                    //link to
                                    // var data = await imageUrlToUint8List(
                                    //     widget.imageUrl!);
                                    var editedImage = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            editor.ImageEditor(
                                          image: imageData,
                                        ),
                                      ),
                                    );

                                    // replace with edited image
                                    if (editedImage != null) {
                                      imageData = editedImage;
                                      setState(() {
                                        _edited = true;
                                      });
                                    }
                                  },
                                )),
                            SizedBox(
                                width: 100,
                                child: AppButton(
                                  title: "Download",
                                  onTap: () {
                                    saveWidgetAsImage(
                                        widgetKey, 'watermarked_image', false);
                                  },
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Caption Data :",
                              style: sfBold.copyWith(fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                          text: controllerContent.htmlData))
                                      .then((value) =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Center(
                                                  child: Text(
                                                'Copied to clipboard!',
                                                style: sfBold,
                                              )),
                                            ),
                                          ));
                                },
                                child: const Icon(Icons.copy)),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                                onTap: () {
                                  Share.share(controllerContent.htmlData);
                                },
                                child: const Icon(Icons.share)),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          height: 1,
                          thickness: 2,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Text(
                        //   widget.data ?? '',
                        //   style: sfMedium.copyWith(fontSize: 16),
                        //   textAlign: TextAlign.center,
                        // ),
                        HtmlWidget(
                          widget.data ?? '',
                          textStyle: sfMedium.copyWith(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

Image base64ImageWidget(String base64String) {
  Uint8List uint8List = base64.decode(base64String);
  return Image.memory(uint8List);
}

class WatermarkedImage extends StatelessWidget {
  final String? watermark;
  final String? original;
  final Uint8List? imageData;
  final bool? edited;

  const WatermarkedImage(
      {super.key, this.watermark, this.original, this.imageData, this.edited});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widgetKey,
      child: Stack(
        // alignment: Alignment.topRight,
        children: [
          // Original Image
          imageData == null
              ? Image.network(original!)
              : Image.memory(imageData!),

          // Watermark Logo
          edited!
              ? const SizedBox.shrink()
              : Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40,
                      child: base64ImageWidget(
                        (watermark!),
                      ),
                    ),
                  ),
                ),
          edited!
              ? const SizedBox.shrink()
              : Positioned(
                  bottom: 0,
                  left: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                        Center(
                          child: Text(
                            firebaseController.selectedBrand!.slogan ?? '',
                            style: GoogleFonts.b612(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
