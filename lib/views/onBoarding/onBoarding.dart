import 'package:ai_story_maker/utils/text_style.dart';
import 'package:ai_story_maker/views/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'AI-Powered Brand Boost',
      'description':
          'Elevate your brand\'s presence with our cutting-edge app! Generate stunning images and captivating content with the power of artificial intelligence. Create effective social campaigns and brand promotions effortlessly.',
      'image': 'assets/onBoarding1.png',
    },
    {
      'title': 'CampaignCraft AI: Your Brand\'s Best Friend',
      'description':
          'Unleash the full potential of your brand with CampaignCraft AI. Craft compelling social campaigns and brand promotions using AI-generated imagery and content. Boost engagement and reach like never before.',
      'image': 'assets/onBoarding2.png',
    },
    {
      'title': 'SocialWave Pro: AI-Driven Brand Promotion',
      'description':
          'Dive into the future of brand promotion! SocialWave Pro leverages AI to craft visually striking images and persuasive content for your campaigns. Supercharge your social presence and watch your brand soar.',
      'image': 'assets/onBoarding3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: BackgroundImage()),
        Positioned.fill(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _onboardingData.length,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemBuilder: (context, index) {
                        return buildOnboardingPage(_onboardingData[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => buildDotIndicator(index),
                    ),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        GetStorage().write('isFirstTime', false);

                        Get.to(() => const RegisterView());
                      } else {
                        setState(() {
                          _currentPage = _currentPage + 1;
                          _pageController.animateToPage(_currentPage,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.bounceIn);
                        });
                      }
                    },
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 80),
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius: 1,
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                            child: Text(
                          _currentPage == _onboardingData.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: sfBold.copyWith(
                              color: Colors.white, fontSize: 18),
                        ))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOnboardingPage(Map<String, String> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              data['image']!,
              fit: BoxFit.fill,
              height: 250,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            data['title']!,
            style: sfBold.copyWith(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            data['description']!,
            style: sfRegular.copyWith(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildDotIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 12 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.black : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
