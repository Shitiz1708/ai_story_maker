import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/api_services.dart';

class ContentWriterController extends GetxController {
  String? selectedValue = "businessIdea";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List contentOptionList = [];
  ScrollController scrollController =
      ScrollController(initialScrollOffset: 50.0);
  Rx<List<ContentMessage>> messages = Rx<List<ContentMessage>>([]);
  final contentController = TextEditingController();
  RxString contentInput = ''.obs;
  RxInt itemCount = 0.obs;
  List<String> shareMessages = ['--THIS IS CONVERSATION with ADCRAFT--\n\n'];
  RxInt contentCount = 0.obs;
  final contentScrollController = ScrollController();
  bool _isLoading = (false);
  bool get isLoading => _isLoading;
  final isSpeechLoading = false.obs;
  final isSpeech = false.obs;

  dynamic htmlData;

  @override
  void onReady() {
    // TODO: implement onReady

    update();

    super.onReady();
  }

  //stop speech method
  speechStopMethod() async {
    isSpeech.value = false;
    update();
  }

  //listview scroll down
  void scrollDown() {
    contentScrollController.animateTo(
      contentScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  //add text count
  addTextCount() async {
    contentCount.value++;
    // LocalStorage.saveTextCount(count: count.value);
  }

  setData(String value) async {
    _gendata = value;
    update();
    // LocalStorage.saveTextCount(count: count.value);
  }

  String _gendata = "";
  String get getdata => _gendata;

  Future<void> processContentWrite(
      String brand, String type, String description) async {
    speechStopMethod();

    _isLoading = true;
    update();
    messages.value.add(
      ContentMessage(
        text: contentController.text,
        textMessageType: ContentMessageType.user,
      ),
    );

    var input =
        "This is My Brand name $brand and this is my content type $type and my content Description is this $description Short and In Proper HTML Format ";
    contentInput.value = contentController.text;
    contentController.clear();
    update();

    var value = await ApiServices.chatCompeletionResponse(input);
    // .then((value) {
    log("value : $value");
    setData(value);
    htmlData = value;
    _isLoading = false;
    update();
    // });
    contentController.clear();
    update();
  }
}

enum ContentMessageType { user, bot }

class ContentMessage {
  ContentMessage({
    required this.text,
    required this.textMessageType,
  });

  final String text;
  final ContentMessageType textMessageType;
}
