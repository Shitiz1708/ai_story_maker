import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio1;

import '../model/messages.dart';
import '../model/turbo_model.dart';
import 'network.dart';

///Generate Image

Future<List<Images>> getImages({
  required String prompt,
  required int n,
}) async {
  //
  NetworkClient networkClient = NetworkClient();
  List<Images> imagesList = [];
  try {
    final res = await networkClient.post(
      'https://api.openai.com/v1/images/generations',
      {
        "prompt": prompt,
        "n": n,
        "size": "256x256",
      },
      token: "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",
    );
    Map<String, dynamic> mp = jsonDecode(res.toString());
    debugPrint(mp.toString());
    if (mp.containsKey('error')) {
    } else {
      if (mp['data'].length > 0) {
        imagesList = List.generate(mp['data'].length, (i) {
          return Images.fromJson(<String, dynamic>{
            'url': mp['data'][i]['url'],
          });
        });
        debugPrint(imagesList.toString());
      }
    }
  } on Exception {
    debugPrint('error');
  }
  if (imagesList.isEmpty) {
    return [];
  } else {
    return imagesList;
  }
}

///Generate Text
Future<Chat> getText({
  required String prompt,
  required int tokenValue,
  required String? model,
  required double? temperature,
  required double? topP,
}) async {
  //
  NetworkClient networkClient = NetworkClient();
  List<Chat> chatList = [];
  try {
    final res = await networkClient.post(
      "https://api.openai.com/v1/completions",
      {
        "model": model ?? "text-davinci-003",
        "prompt": prompt,
        "temperature": 0.8,
        "max_tokens": tokenValue,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0.6,
        // "stop": ["A : "]
      },
      token: "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",
    );
    Map<String, dynamic> mp = jsonDecode(res.toString());
    debugPrint(mp.toString());

    // {"error":{"message":"This model's maximum context length is 4097 tokens, however you requested 4771 tokens (4271 in your prompt; 500 for the completion). Please reduce your prompt; or completion length.","type":"invalid_request_error","param":null,"code":null}}
    if (mp.containsKey('error') &&
        !mp
            .toString()
            .contains('Please reduce your prompt; or completion length')) {
      return Chat(msg: 'error_message'.tr, chat: -1);
    }
    if (mp
        .toString()
        .contains('Please reduce your prompt; or completion length')) {
    } else {
      if (mp['choices'].length != 0) {
        chatList = List.generate(mp['choices'].length, (i) {
          return Chat.fromJson(<String, dynamic>{
            'msg': mp['choices'][i]['text'],
            'chat': 1,
          });
        });
        for (var a in chatList) {
          debugPrint(a.msg.toString());
        }
      }
    }
  } on Exception {
    debugPrint('error');
  }
  if (chatList.isEmpty) {
    return Chat(msg: 'length_error_message'.tr, chat: -1);
  } else {
    return chatList[0];
  }
}
//chatGPT turbo

Future<Chat> getTextViaTurbo({
  required List<TurboMessage> prompt,
  required int tokenValue,
  required String? model,
  required double? temperature,
  required double? topP,
}) async {
  //
  NetworkClient networkClient = NetworkClient();
  List<Chat> chatList = [];

  var messages = [];
  messages.add(
    {"role": "system", "content": prompt.first.role},
  );
  for (var i = 0; i < prompt.length; i++) {
    messages.add({
      'role': 'user',
      'content': prompt[i].content,
    });
  }

  try {
    final res = await networkClient.post(
      "https://api.openai.com/v1/chat/completions",
      {
        'model': model ?? 'gpt-3.5-turbo',
        'messages': messages,
        "temperature": 0.8,
        "max_tokens": tokenValue,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0.6,
      },
      token: "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",
    );
    Map<String, dynamic> mp = jsonDecode(res.toString());
    debugPrint(mp.toString());

    if (mp.containsKey('error') &&
        !mp
            .toString()
            .contains('Please reduce your prompt; or completion length')) {
      return Chat(msg: 'error_message'.tr, chat: -1);
    }
    if (mp
        .toString()
        .contains('Please reduce your prompt; or completion length')) {
    } else {
      if (mp['choices'].length != 0) {
        chatList = List.generate(mp['choices'].length, (i) {
          return Chat.fromJson(<String, dynamic>{
            'msg': mp['choices'][i]['message']['content'],
            'chat': 1,
          });
        });
        for (var a in chatList) {
          debugPrint(a.msg.toString());
        }
      }
    }
  } on Exception {
    debugPrint('error');
  }
  if (chatList.isEmpty) {
    return Chat(msg: 'length_error_message'.tr, chat: -1);
  } else {
    return chatList[0];
  }
}

//whisper
Future<String> getTextViaWhisper(
    {required String prompt, required String filePath}) async {
  //
  var apiUrl = 'https://api.openai.com/v1/audio/transcriptions';
  //for translations

  var openaiApiKey = "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";
  var model = 'whisper-1';
  try {
    var dio = dio1.Dio();
    dio.options.headers['Authorization'] = 'Bearer $openaiApiKey';
    dio.options.headers['Content-Type'] = 'multipart/form-data';

    var formData = dio1.FormData.fromMap({
      'model': model,
      'file': await dio1.MultipartFile.fromFile(filePath),
    });

    var response = await dio.post(apiUrl, data: formData);

    print(response.data['text']);
    return response.data['text'];
  } catch (e) {
    print(e);
  }
  throw Exception('Error While Fetching');
}
