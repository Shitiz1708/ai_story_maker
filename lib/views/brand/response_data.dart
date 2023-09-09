import 'package:ai_story_maker/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/content_writer_controller.dart';

class ResponseData extends StatelessWidget {
  const ResponseData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContentWriterController>(
        init: ContentWriterController(),
        builder: (contentCtrl) {
          return contentCtrl.isLoading
              ? const Center(child: Center(child: CircularProgressIndicator()))
              : contentCtrl.htmlData == null
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                          text: contentCtrl.htmlData))
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
                                  Share.share(contentCtrl.htmlData);
                                },
                                child: const Icon(Icons.share)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        HtmlWidget(
                          contentCtrl.htmlData,
                          textStyle: sfSemiBold.copyWith(fontSize: 16),
                        ),
                      ],
                    );
        });
  }
}
