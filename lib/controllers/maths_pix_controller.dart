import 'dart:convert';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class MathPixController extends GetxController {
  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  String appKey =
      'your_api_key';

  Future<String> getAppToken() async {
    const String url = 'https://api.mathpix.com/v3/app-tokens';
    final Map<String, String> headers = {
      'app_key': appKey,
    };

    try {
      final response = await http.post(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to get app token.');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //
  // final String imageUrl =
  //     'https://mathpix-ocr-examples.s3.amazonaws.com/cases_hw.jpg';

  Future<Map<String, dynamic>> getTextViaImageUrl(
    String imageUrl,
  ) async {
    var appID = await getAppToken();
    const String url = 'https://api.mathpix.com/v3/text';
    final Map<String, String> headers = {
      'app_id': appID,
      'app_key': appKey,
      'Content-type': 'application/json',
    };
    final Map<String, dynamic> requestBody = {
      'src': imageUrl,
      'math_inline_delimiters': ['\$', '\$'],
      'rm_spaces': true,
    };

    try {
      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(requestBody));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get text from image.');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getTextViaFile(String filePath) async {
    var appID = await getAppToken();
    const String url = 'https://api.mathpix.com/v3/text';
    final Map<String, String> headers = {
      'app_id': appID,
      'app_key': appKey,
    };
    final Map<String, String> options = {
      'math_inline_delimiters': '["\$", "\$"]',
      'rm_spaces': 'true',
    };

    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        filePath,
      ))
      ..fields.addAll({'options_json': jsonEncode(options)});

    try {
      final response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get text from image.');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }



}
