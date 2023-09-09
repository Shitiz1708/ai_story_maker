// ignore_for_file: unused_field

import 'dart:io';

import 'package:ai_story_maker/controllers/maths_pix_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/chat_Controller.dart';

import '../../utils/text_style.dart';
import '../widgets/message_widget.dart';

class ChatViewScreen extends StatefulWidget {
  final int? id;
  final bool? ocr;
  final String? type;
  final String? prompt;
  final String? sessionId;
  final String? title;
  final String? history;
  final String? initText;

  const ChatViewScreen({
    super.key,
    required this.id,
    this.type,
    this.prompt = 'none',
    this.sessionId = '',
    this.title,
    this.history,
    this.ocr = true,
    this.initText = "",
  });

  @override
  State<ChatViewScreen> createState() => _ChatViewScreenState();
}

class _ChatViewScreenState extends State<ChatViewScreen> {
  final TextEditingController textcontroller = TextEditingController();
  final ChatController chatController = Get.put(ChatController());

  final SpeechToText _speechToText = SpeechToText();
  bool _islistening = false;
  String _lastWords = '';

  String sessionId = '';

  /// This has to happen only once per app

  Future<void> _startListening() async {
    if (!_islistening) {
      bool available = await _speechToText.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError: $val'),
          options: []);
      if (available) {
        setState(() {
          _islistening = true;
        });
        _speechToText.listen(
            onResult: (val) => setState(() {
                  _lastWords = val.recognizedWords;
                  textcontroller.text = _lastWords;
                }));
      }
    } else {
      setState(() {
        _islistening = false;
      });
      _speechToText.stop();
    }
  }

  final List<String> _questions = [
    "Examples",
    "\"Explain quantom computing in simple terms\"",
    "\"Got any creative ideas for a 10 year old's birthday?\"",
    "\"How do I make an HTTP request in Javascript\"",
    "Capabilities",
    "Remembers what user said earlier in the conversation",
    "Allow user to provide follow-up corrections",
    "Trained to decline inappropriate requests",
  ];

  File? _imageFile;

  final MathPixController _mathPixController = Get.put(MathPixController());
  // Function to open the image picker and get the selected image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      //get text From Math Pix
      var mathText = await _mathPixController.getTextViaFile(_imageFile!.path);
      chatController.sendMessage(
          widget.id!,
          mathText["latex_styled"] ?? mathText["text"],
          _imageFile!.path,
          'mathsOcr',
          sessionId,
          true);
    }
  }

  @override
  void initState() {
    if (widget.id == 10) {
      chatController.insertFirstMessage(sessionId);
    }
    textcontroller.text = widget.initText!;
    setState(() {});

    print(widget.type);
    if (widget.sessionId != '') {
      sessionId = widget.sessionId!;
    } else {
      sessionId = const Uuid().v4();
    }
    // chatController.firstFetch(widget.id!);

    super.initState();
  }

  @override
  void dispose() {
    chatController.messages.clear();

    chatController.setTyping(false);
    super.dispose();
  }

  void attachInitialText(String text, String currentPropmpt) {
    if (widget.history != null) {
      chatController.sendMessage(
          widget.id!, text, currentPropmpt, 'history', sessionId, false);
    } else {
      if (widget.prompt != 'none') {
        chatController.sendMessage(
            widget.id!, text, currentPropmpt, 'inbuilt', sessionId, false);
      } else {
        if (widget.id != 10) {
          if (widget.type == 'Generate Summarized Text') {
            chatController.sendMessage(widget.id!, text, currentPropmpt,
                'summarize', sessionId, false);
          } else if (widget.type == 'Get Feedback') {
            chatController.sendMessage(
                widget.id!, '', currentPropmpt, 'feedback', sessionId, false);
          } else if (widget.type == 'Keywords') {
            chatController.sendMessage(
                widget.id!, text, currentPropmpt, 'keywords', sessionId, false);
          } else if (widget.type == 'Find Bugs in your code') {
            chatController.sendMessage(
                widget.id!, text, currentPropmpt, 'bugs', sessionId, false);
          } else if (widget.type == 'Sentence Correction') {
            chatController.sendMessage(
                widget.id!, text, currentPropmpt, 'grammer', sessionId, false);
          } else if (widget.type == 'Study Notes') {
            chatController.sendMessage(
                widget.id!, text, currentPropmpt, 'notes', sessionId, false);
          } else if (widget.type == 'Reasoning Questions') {
            chatController.sendMessage(widget.id!, text, currentPropmpt,
                'reasoning', sessionId, false);
          } else if (widget.type == 'Interview Questions') {
            chatController.sendMessage(widget.id!, text, currentPropmpt,
                'interview', sessionId, false);
          } else {
            chatController.sendMessage(
                widget.id!, text, '', '', sessionId, false);
          }
        } else {
          chatController.analyzeDocs(
              prompt: textcontroller.text,
              fromChat: true,
              sessionId: sessionId);
        }
      }
      textcontroller.clear();
      _speechToText.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title!, style: sfBold),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Get.back();
              },
            ),
            actions: const [
              Icon(
                Icons.cloud_download,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          // backgroundColor: Theme.of(context).primaryColor,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
                child: GetBuilder<ChatController>(
                    init: ChatController(),
                    builder: (controller) {
                      return SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            controller.messages.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                      reverse: true,
                                      padding: const EdgeInsets.all(8),
                                      itemCount: controller.messages.length,
                                      itemBuilder: (context, index) {
                                        return ChatMessage(
                                          isImage: controller
                                              .messages[index].isImage,
                                          text: controller.messages[index].text,
                                          time: controller.messages[index].time,
                                          sender:
                                              controller.messages[index].sender,
                                          query:
                                              controller.messages[index].query,
                                          type: controller.messages[index].type,
                                          index: index,
                                          sessionId: controller
                                              .messages[index].sessionId,
                                        );
                                      },
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(20),
                                      itemCount: _questions.length,
                                      itemBuilder: (_, index) => InkWell(
                                        onTap: () {
                                          textcontroller.text =
                                              _questions[index];

                                          setState(() {});
                                        },
                                        child: index == 0
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                      Icons.wb_sunny_outlined),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(_questions[index],
                                                      style: sfBold)
                                                ],
                                              )
                                            : _questions[index] ==
                                                    "Capabilities"
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(Icons
                                                          .flash_on_outlined),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(_questions[index],
                                                          style: sfBold)
                                                    ],
                                                  )
                                                : Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            14),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[
                                                          300], //Color(0xff23313c
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Text(
                                                      _questions[index],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: sfRegular.copyWith(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                      ),
                                    ),
                                  ),
                            if (controller.Typing)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 18.0, bottom: 8),
                                child: Image.asset(
                                  'assets/typing.gif',
                                  fit: BoxFit.cover,
                                  height: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            const SizedBox(height: 30),
                            Column(
                              children: [
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            cursorColor: Theme.of(context)
                                                .secondaryHeaderColor,
                                            controller: textcontroller,
                                            maxLines: null,
                                            style: sfMedium.copyWith(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                            textInputAction:
                                                TextInputAction.send,
                                            // onSubmitted: _handleSubmit,
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                                suffixIcon: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    textcontroller
                                                            .text.isNotEmpty
                                                        ? InkWell(
                                                            onTap: () {
                                                              textcontroller
                                                                  .clear();
                                                              setState(() {});
                                                            },
                                                            child: Icon(
                                                              Icons.clear,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    InkWell(
                                                      onTap: () {
                                                        if (!controller
                                                            .Typing) {
                                                          _startListening();
                                                        }
                                                      },
                                                      child: Icon(Icons.mic,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      child: VerticalDivider(
                                                        width: 3,
                                                        thickness: 1,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons.send,
                                                          size: 30,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                        onPressed: () {
                                                          if (!controller
                                                              .Typing) {
                                                            attachInitialText(
                                                                textcontroller
                                                                    .text,
                                                                '');
                                                          }
                                                        }),
                                                  ],
                                                ),
                                                fillColor: Colors.white,
                                                filled: true,
                                                hintText:
                                                    'What do you want to ask?',
                                                border:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(14),
                                                  ),
                                                ),
                                                hintStyle: sfMedium.copyWith(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                        widget.ocr!
                                            ? Container(
                                                margin: const EdgeInsets.all(4),
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      _pickImage();
                                                    },
                                                    child: const Icon(
                                                      Icons.camera_enhance,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    })),
          )),
    );
  }
}
