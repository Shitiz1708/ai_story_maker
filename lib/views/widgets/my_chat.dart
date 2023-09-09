import 'dart:io';

import 'package:flutter/material.dart';

import '../../utils/text_style.dart';

class MyChat extends StatelessWidget {
  final String? message;
  final String? query;
  final String? type;
  final bool? isImage;
  const MyChat({Key? key, this.message, this.query, this.type, this.isImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.9),
                      border: Border.all(
                          color: Theme.of(context).secondaryHeaderColor),
                      borderRadius: BorderRadius.circular(12)),
                  child: isImage!
                      ? Image.file(File(query!))
                      : SelectableText(
                          message!,
                          style: sfSemiBold.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/User Icon.png',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
