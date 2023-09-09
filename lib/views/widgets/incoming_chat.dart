import 'dart:io';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../controllers/chat_Controller.dart';
import '../../utils/text_style.dart';

class IncomingChat extends StatelessWidget {
  final String? message;
  final String? query;
  final int index;
  final String type = 'gpt';

  const IncomingChat({
    Key? key,
    this.message,
    this.query,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logo.png',
                height: 40,
                width: 30,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 10.0,
                        spreadRadius: 3.0,
                      )
                    ],
                    //  borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: GetBuilder<ChatController>(builder: (controller) {
                        return Column(
                          children: [
                            index == 0 &&
                                    controller.count == 0 &&
                                    controller.textAutoPlay
                                ? chatWidget(
                                    "${message!}  ${"\n"}${"\n"}Disclaimer:\n\na) The Answers are powered by ChatGPT and might be inaccurate. Please refer to your official textbook for confirmation of the answer.\n\nb) ChatGPT cannot yet understand an image as an input. Please refrain from taking a photo of an image from your textbook.")
                                : SelectableText(
                                    "${message!}  ${"\n"}${"\n"}Disclaimer:\n\na) The Answers are powered by ChatGPT and might be inaccurate. Please refer to your official textbook for confirmation of the answer.\n\nb) ChatGPT cannot yet understand an image as an input. Please refrain from taking a photo of an image from your textbook.",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.setCurrentIndex(index);
                                    if (controller.isPlaying &&
                                        controller.currentIndex == index) {
                                      controller.stopMessage();
                                    } else {
                                      controller.speakMessage(message!);
                                    }
                                  },
                                  child: Icon(
                                    controller.isPlaying &&
                                            controller.currentIndex == index
                                        ? Icons.pause
                                        : Icons.play_circle_fill,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(
                                            ClipboardData(text: message!))
                                        .then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Center(
                                                  child: Text(
                                        "copied".tr,
                                        style: sfBold,
                                      ))));
                                    });
                                  },
                                  child: const Icon(
                                    Icons.copy,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () async {
                                    //     format query and message
                                    final String formattedQuery = query!;

                                    final String formattedMessage = message!;
                                    Share.share(
                                        'Question:\n${formattedQuery}My Epic AI Stories\nResponse: $formattedMessage');
                                  },
                                  child: const Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () async {
                                    final pdfFile =
                                        await PdfApi.generateCenteredText(
                                            "BitterLeaf: $message",
                                            "Question:  ${controller.messages[index + 1].query}");

                                    print(pdfFile.path);

                                    launchURL(pdfFile.path);
                                  },
                                  child: const Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      })),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget chatWidget(String text, {TextStyle? style}) {
  return DefaultTextStyle(
    style: style ??
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
    child: AnimatedTextKit(
      animatedTexts: [
        TyperAnimatedText(
          text.replaceFirst('\n\n', ''),
          speed: const Duration(milliseconds: 10),
        ),
      ],
      repeatForever: false,
      totalRepeatCount: 1,
    ),
  );
}

class PdfApi {
  static Future<File> generateCenteredText(String text, String question) async {
    String normalText = "";
    normalText = normalText + text;
    // making a pdf document to store a text and it is provided by pdf pakage
    final pdf = pw.Document();
    try {
      // Text is added here in center
      final List<String> words = normalText.split(' ');

      const int maxWordsPerPage =
          200; // You can adjust this value based on your preference.

      int pageCount = (words.length / maxWordsPerPage).ceil();

      int startWordIndex = 0;
      int endWordIndex;

      // Create pages dynamically based on the number of words and the maximum words per page
      for (int i = 0; i < pageCount; i++) {
        endWordIndex = (startWordIndex + maxWordsPerPage) < words.length
            ? startWordIndex + maxWordsPerPage
            : words.length;

        final pageContent =
            words.sublist(startWordIndex, endWordIndex).join(' ');

        final page = pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(pageContent,
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
            );
          },
        );

        pdf.addPage(page);

        startWordIndex = endWordIndex;
      }

      // pdf.addPage(pw.Page(
      //     pageFormat: PdfPageFormat.a4,
      //     build: (pw.Context context) {
      //       return pw.Center(
      //         child: pw.Column(
      //             crossAxisAlignment: pw.CrossAxisAlignment.center,
      //             children: [
      //               pw.Text(question, style: const pw.TextStyle(fontSize: 22)),
      //               pw.SizedBox(height: 20),
      //               pw.Text(normalText,
      //                   style: const pw.TextStyle(
      //                     fontSize: 22,
      //                   ))
      //             ]),
      //       ); // Center
      //     }));
      //create random name for pdf of 5 characters
      final name = Random().nextInt(10000).toString();
      return saveDocument(name: 'TestSeries$name.pdf', pdf: pdf);
    } catch (e) {
      print(e);
    }
    throw Exception();

    // passing the pdf and name of the docoment to make a direcotory in  the internal storage
  }

  // it will make a named dircotory in the inquestionternal storage and then return to its call
  static Future<File> saveDocument({
    String? name,
    pw.Document? pdf,
  }) async {
    // pdf save to the variable called bytes
    final bytes = await pdf!.save();

    // here a beautiful pakage  path provider helps us and take dircotory and name of the file  and made a proper file in internal storage
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    // reterning the file to the top most method which is generate centered text.
    return file;
  }
}

launchURL(String? path) async {
  await OpenFilex.open(path);
}
