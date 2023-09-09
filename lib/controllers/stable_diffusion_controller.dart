import 'dart:convert';
import 'dart:math';

import 'package:ai_story_maker/controllers/auth_controller.dart';
import 'package:ai_story_maker/controllers/content_writer_controller.dart';
import 'package:ai_story_maker/views/chat/story_reader_view.dart';
import 'package:ai_story_maker/views/library/story_reading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/brand_data.dart';

ContentWriterController contentWriterController =
    Get.put(ContentWriterController());

class StableDiffusionController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _currentSeed = 273040836;
  int get currentSeed => _currentSeed;

  bool _isFinalLoading = false;
  bool get isFinalLoading => _isFinalLoading;

  setFinalLoadin(bool value) {
    _isFinalLoading = value;
    update();
  }

  int generateRandomSeed() {
    //10 digit random  number poisitive and <= 2^32
    final int value = (Random().nextDouble() * 4294967296).toInt();

    _currentSeed = value;
    return value;
  }

  void setCurrentSeed(int value) {
    _currentSeed = value;
    update();
  }

  final String _jobId = "";
  String get jobId => _jobId;

  //Generate Image Via Image
  Future<void> generateImageViaImage({
    Branddata? data,
    String? imageURL,
    String? model,
    String? type,
    String? description,
    String? demography,
    String? size,
  }) async {
    try {
      generateRandomSeed();
      _isLoading = true;
      update(); // Notify listeners that loading state has changed

      final Map<String, dynamic> requestBody = {
        "prompt":
            "A Person in $demography attair  8k hd ultra realistic for $type with $description",
        "imageUrl": "$imageURL",
        "model": "absolutereality_v181.safetensors [3d9d4d2b]",
        "negative_prompt":
            "(worst quality, low quality, cgi, bad eye, worst eye, illustration, cartoon), deformed, distorted, disfigured, poorly drawn, bad anatomy, wrong anatomy, (bad teeth, wrong teeth, open mouth:1.5)",
        "denoising_strength": 0.7,
        "steps": 25,
        "cfg_scale": 7,
        "seed": _currentSeed,
        "upscale": true,
        "sampler": "DPM++ 2S a",
        "aspect_ratio": size,
      };

      final Uri apiUrl = Uri.parse("https://api.prodia.com/v1/sd/transform");
      final Map<String, String> headers = {
        'X-Prodia-Key': '598f5981-3669-4466-9b16-4afd33992cc0',
        'accept': 'application/json',
        'content-type': 'application/json',
      };

      final http.Response response = await http.post(
        apiUrl,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);

        await getImageViaJobId(responseData['job'], data!, type ?? '',
            description ?? '', demography ?? '');
      } else {
        // Handle API error or non-200 status code here
      }
    } catch (e) {
      // Handle errors
    } finally {
      _isLoading = false;
      update(); // Notify listeners that loading state has changed
    }
  }

  //Generate Image via Text
  Future<void> textToImage(String promptText) async {
    try {
      _isLoading = true;
      update(); // Notify listeners that loading state has changed

      final Map<String, dynamic> requestBody = {
        "model": "absolutereality_v181.safetensors [3d9d4d2b]",
        "prompt": promptText,
        "negative_prompt": "badly drawn",
        "steps": 25,
        "cfg_scale": 7,
        "seed": -1,
        "upscale": true,
        "sampler": "DPM++ 2S a Karras",
        "aspect_ratio": "landscape"
      };

      final Uri apiUrl = Uri.parse("https://api.prodia.com/v1/sd/generate");
      final Map<String, String> headers = {
        'X-Prodia-Key': '598f5981-3669-4466-9b16-4afd33992cc0',
        'accept': 'application/json',
        'content-type': 'application/json',
      };

      final http.Response response = await http.post(
        apiUrl,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // Handle the API response here
        print(responseData);
        // await getImageViaJobId(responseData['jobId']);
      } else {
        // Handle API error or non-200 status code here
      }
    } catch (e) {
      // Handle errors
    } finally {}
  }

  //Get GeneratedImageViaJob Id

  Future<void> getImageViaJobId(String jobId, Branddata data, String type,
      String description, String demography) async {
    print(":here");
    try {
      // Notify listeners that loading state has changed

      final Uri apiUrl = Uri.parse("https://api.prodia.com/v1/job/$jobId");
      final Map<String, String> headers = {
        'X-Prodia-Key': '598f5981-3669-4466-9b16-4afd33992cc0',
        'accept': 'application/json',
      };

      final http.Response response = await http.get(
        apiUrl,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);
        if (responseData["status"] == "succeeded") {
          await contentWriterController.processContentWrite(
              "Brand Name :${data.name}, Brand SLogan :${data.slogan}, and demography $demography",
              type,
              description);
          Get.to(() => StoryViewingScreen(
              data: contentWriterController.htmlData.toString(),
              imageUrl: responseData["imageUrl"].toString()));
        } else if (responseData["status"] == "generating" ||
            responseData["status"] == "queued") {
          getImageViaJobId(jobId, data, type, description, demography);
        }
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      // Handle errors
    } finally {
      _isLoading = false;
      update(); // Notify listeners that loading state has changed
    }
  }
}
