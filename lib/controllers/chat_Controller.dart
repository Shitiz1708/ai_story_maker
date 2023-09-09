import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../model/messages.dart';
import '../model/turbo_model.dart';
import '../utils/api_calls.dart';
import '../views/widgets/message_widget.dart';

class ChatController extends GetxController {
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;
  int _maxLenght = 4000;
  int get maxLenght => _maxLenght;

  bool _textAutoPlay = true;
  bool get textAutoPlay => _textAutoPlay;

  String? _currentModel = 'gpt-3.5-turbo';
  String? get currentModel => _currentModel;

  setCurrentModel(String? value) {
    _currentModel = value;
    GetStorage().write('currentModel', _currentModel);
    update();
  }

  loadCurrentModel() {
    GetStorage().writeIfNull('currentModel', 'gpt-3.5-turbo');
    _currentModel = GetStorage().read('currentModel');
    update();
  }

  void resetSettings() {
    _maxLenght = 1000;
    _textAutoPlay = true;
    GetStorage().write('isTextAuto', _textAutoPlay);

    _temperature = 0.8;
    _topP = 1.0;
    _currentModel = 'text-davinci-003';
    update();
  }

  void setTextAutoPlay(bool value) {
    _textAutoPlay = value;
    update();
  }

  void setMaxLenght(int value) {
    _maxLenght = value;
    update();
  }

  //temperature
  double _temperature = 0.8;
  double get temperature => _temperature;

  void setTemperature(double value) {
    _temperature = value;
    update();
  }

  //TopP
  double _topP = 1.0;
  double get topP => _topP;

  void setTopP(double value) {
    _topP = value;
    update();
  }

//filterBySessionId

  String _initialTexts = "";
  String startSequence = "A : ";
  String restartSequence = "\n";
  Future<String> getPrompt(String text, String type, String sessionId) async {
    print(type);
    if (text.isEmpty) {
      return _initialTexts;
    } else {
      if (type == 'summarize') {
        _initialTexts =
            "I will send you a paragraph you will summarize it This is my first Paragraph : ";
      } else if (type == 'feedback') {
        _initialTexts =
            "I will send you a paragraph you will give feedback on it This is my first Paragraph : ";
      } else if (type == 'keywords') {
        _initialTexts =
            "I will send you a paragraph you will give seo optimized keywords from it This is my first Paragraph : ";
      } else if (type == 'bugs') {
        _initialTexts =
            "I will send you a question that contains block of code of certain programming language you will find  bugs in it  and correct them with explanation here is my question : ";
      } else if (type == 'grammer') {
        _initialTexts =
            "I will send you a paragraph you will correct grammer mistakes in it This is my first Paragraph : ";
      } else if (type == 'notes') {
        _initialTexts =
            "I will send you a topic you will give notes on it This is my first topic : ";
      } else if (type == 'reasoning') {
        _initialTexts =
            "I will ask you a question related to reasonings you will explain it and solve it This is my first question : ";
      } else if (type == 'interview') {
        _initialTexts =
            "I will give you a job profile you will suggest me some important topic to prepare for interview This is my job profile : ";
      }

      if (_messages.length > 2) {
        var lastMessage = _messages[0];
        var secondLastMessage = _messages[1];
        var thirdLastMessage = _messages[2];

        _initialTexts =
            "$_initialTexts ${thirdLastMessage.text} $restartSequence ${secondLastMessage.text} $restartSequence ${lastMessage.text} $restartSequence $text";
      } else {
        _initialTexts = "$_initialTexts  $text $restartSequence";
      }

      return _initialTexts;
    }
  }

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  //play message
  Future<void> speakMessage(String text) async {
    try {
      _isPlaying = true;
      update();
      _isPlaying = false;
      update();
    } catch (e) {
      print(e);
    }
  }

  int _freeChats = 0;
  int get freeChats => _freeChats;

  //set free chats to 7 if day is monday
  void setFreeChats() {
    var now = DateTime.now();
    var monday = now.subtract(Duration(days: now.weekday - 1));
    var today = DateTime(now.year, now.month, now.day);
    if (monday == today) {
      _freeChats = 7;
    }
    update();
  }

  void stopMessage() async {}

//clear all messages
  Future<void> clearMessages(String sessionID) async {
    _messages = [];
    _initialTexts = "";
  }

  setCurrentIndex(int index) {
    _currentIndex = index;
    update();
  }

  bool _Typing = false;
  bool get Typing => _Typing;

  setTyping(bool value) {
    _Typing = value;
    update();
  }

  @override
  void onInit() {
    setFreeChats();

    loadCurrentModel();

    super.onInit();
  }

  String _systemRole =
      'You are a helpful assistant that is Smart and Intelligent and Quick and assist users in their daily life.';
  String get systemRole => _systemRole;
  String setSystemRole(String type) {
    if (type == 'summarize') {
      _systemRole =
          'You are a helpful,Intelligent,Smart,Quick assistant that Summarize the given Paragraph.';
    }
    'You are a helpful,Intelligent,Smart,Quick assistant that will solve any question  maths,english,history,chemistry,physics in more eloborated Way and easily.';

    return _systemRole;
  }

  Future<void> sendMessage(int id, String text, String previous, String type,
      String sessionId, bool isImage) async {
    if (text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: text,
      isImage: isImage,
      sender: "You",
      query: previous,
      index: 0,
      type: 'You',
      time: DateTime.now(),
      sessionId: sessionId,
    );

    _messages.insert(0, message);
    _Typing = true;
    update();

    try {
      Chat rsp = await getTextViaTurbo(
        prompt: [
          TurboMessage(
              role: setSystemRole(type),
              content: await getPrompt(text, type, sessionId))
        ],
        tokenValue: (_maxLenght / 4).ceil(),
        model: _currentModel,
        temperature: _temperature,
        topP: _topP,
      );

      if (rsp.chat == -1) {
        _Typing = false;
        update();
        ChatMessage botMessage = ChatMessage(
          isImage: isImage,
          text: rsp.msg,
          sender: "gpt",
          query: message.text,
          index: 0,
          type: 'gpt',
          time: DateTime.now(),
          sessionId: sessionId,
        );
        _messages.insert(0, botMessage);
      } else {
        await insertNewData(id, rsp.msg, message.text, sessionId,
            isImage: isImage);
      }
    } catch (e) {
      _Typing = false;
      update();
      print(e);
      Get.snackbar(
        "Error $e",
        "Something went wrong please try again later",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> insertNewData(
      int id, String response, String query, String sessionId,
      {bool isImage = false, List<Images> images = const []}) async {
    ChatMessage botMessage = ChatMessage(
      isImage: isImage,
      text: response,
      sender: "gpt",
      query: query,
      index: 0,
      type: 'gpt',
      time: DateTime.now(),
      sessionId: sessionId,
    );
    setCurrentIndex(0);

    speakMessage(response);

    getPrompt(response, 'reply', sessionId);
    _Typing = false;
    _messages.insert(0, botMessage);
    resetCount();

    update();
  }

  ///APi Section

  int? _currentIndex;
  int get currentIndex => _currentIndex!;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  Future<void> downloadImage(String url, int index, String? type,
      {Uint8List? bytes}) async {
    setCurrentIndex(index);
    try {
      _isDownloading = true;
      update();
      // Saved with this method.

      if (type == 'stability') {
//get deault path

        var directory = Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationSupportDirectory();

        await File('${directory!.path}/stability.png').writeAsBytes(bytes!);

        // final galleryPath =
        //     await ImageGallerySaver.saveFile('${directory.path}/stability.png');
        _isDownloading = false;
        update();

        Get.snackbar(
          "Success",
          "Image saved successfully",
          colorText: Colors.white,
          backgroundColor: Theme.of(Get.context!).primaryColor,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        _isDownloading = false;
        update();

        Get.snackbar(
          "Success",
          "Image saved successfully",
          colorText: Colors.white,
          backgroundColor: Theme.of(Get.context!).primaryColor,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on PlatformException catch (error) {
      _isDownloading = false;
      update();
      print(error);
    }
  }

  ///ad interval Section

  int _count = 0;
  int get count => _count;

  void setCount() {
    _count++;
    update();
  }

  void resetCount() {
    _count = 0;
    update();
  }

//generate Mock Text Series

  String _testSeries = "";
  String get testSeries => _testSeries;

  bool _resultLoading = false;
  bool get resultLoading => _resultLoading;

  Future<void> generateMockTestSeries(
      {String? topic,
      String? noOfQuestion,
      String? exam,
      String? typeOfExam}) async {
    _resultLoading = true;
    update();
    try {
      Chat rsp = await getTextViaTurbo(
        prompt: [
          TurboMessage(
              role:
                  '''You will act as a Question Generator I will give you type of question,No of Question,topic and Exam Name you will generate a test series  you will return the series in correct  format and no other text with test series questions list''',
              content:
                  "The Topic is $topic, no of Questionis $noOfQuestion and exam name is $exam and the type of Exam is $typeOfExam")
        ],
        tokenValue: (_maxLenght / 4).ceil(),
        model: "gpt-3.5-turbo-16k",
        temperature: _temperature,
        topP: _topP,
      );

      _testSeries = rsp.msg;
      _resultLoading = false;
      update();
    } catch (e) {
      _resultLoading = false;
      update();
    }
  }

  String? _currentDocs;
  String? get currentDocs => _currentDocs;

  void setCurrentDocs(String docs) {
    _currentDocs = docs;
    update();
  }

  Future<void> analyzeDocs(
      {String? prompt, bool? fromChat, String? sessionId}) async {
    _resultLoading = true;
    if (fromChat ?? false) {
      ChatMessage myMessage = ChatMessage(
        isImage: false,
        text: prompt ?? '',
        sender: "You",
        query: prompt ?? '',
        index: 0,
        type: 'You',
        time: DateTime.now(),
        sessionId: sessionId ?? '',
      );
      _messages.insert(0, myMessage);
    }
    _Typing = true;
    update();

    try {
      Chat rsp = await getTextViaTurbo(
        prompt: [
          TurboMessage(
              role:
                  "You will act as an Experienced Teacher that will give answers to student Queries and take document and analyze it and answer user queries from the documents,",
              content:
                  "The Documents is : \"$_currentDocs\", user Query is : $prompt ")
        ],
        tokenValue: (_maxLenght / 4).ceil(),
        model: "gpt-3.5-turbo-16k",
        temperature: _temperature,
        topP: _topP,
      );
      if (fromChat ?? false) {
        if (rsp.chat == -1) {
          _Typing = false;
          update();
          ChatMessage botMessage = ChatMessage(
            isImage: false,
            text: rsp.msg,
            sender: "gpt",
            query: prompt ?? '',
            index: 0,
            type: 'gpt',
            time: DateTime.now(),
            sessionId: sessionId ?? '',
          );
          _messages.insert(0, botMessage);
        } else {
          await insertNewData(1, rsp.msg, prompt ?? '', sessionId ?? '',
              isImage: false);
        }
      } else {
        _testSeries = rsp.msg;
        _resultLoading = false;
      }
      update();
    } catch (e) {
      _resultLoading = false;
      update();
    }
  }

  void insertFirstMessage(String sessionId) {
    ChatMessage message1 = ChatMessage(
      text: "Hello! How can I assist you today with this document?",
      isImage: false,
      sender: "gpt",
      query: "Hello! How can I assist you today with this document?",
      index: 0,
      type: 'gpt',
      time: DateTime.now(),
      sessionId: sessionId,
    );
    _messages.insert(0, message1);
    update();
  }
}
