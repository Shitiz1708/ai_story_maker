import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/text_style.dart';
import '../brand/content_generation.dart';
import '../widgets/app_button.dart';
import '../widgets/text_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   actions: const [
      //     // Padding(
      //     //   padding: EdgeInsets.all(8.0),
      //     //   child: Icon(
      //     //     Icons.info,
      //     //     size: 30,
      //     //   ),
      //     // )
      //   ],
      //   // backgroundColor: Colors.white,
      // ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset(
                "assets/bg.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //appBanner

                  CardWidget(
                    color: Colors.blue,
                    icon: "assets/bulb.png",
                    title: 'AI-Generated Blog',
                    intro:
                        'Effortlessly create compelling content for your brand',
                    onTap: () {
                      Get.to(() => const ContentGeneration(
                            title: "AI-Generated Blog",
                          ));
                    },
                  ),
                  CardWidget(
                    color: Colors.orange,
                    icon: "assets/book.png",
                    title: 'Social Media Posts',
                    intro: 'Generate captivating social media content with AI',
                    onTap: () {
                      Get.to(() => const ContentGeneration(
                            title: "Social Media Posts",
                          ));
                    },
                  ),

                  CardWidget(
                    color: Colors.red,
                    title: 'Automated Email Campaigns',
                    intro:
                        'Leverage AI for personalized email marketing campaigns',
                    icon: "assets/phrase 01 2.png",
                    onTap: () {
                      Get.to(() => const ContentGeneration(
                            title: "Automated Email Campaigns",
                          ));
                    },
                  ),
                  CardWidget(
                    color: Colors.purple,
                    title: 'AI Ad Copywriting',
                    icon: "assets/pop up 2.png",
                    intro: 'Enhance your ad campaigns with AI-generated copy',
                    onTap: () {
                      Get.to(() => const ContentGeneration(
                            title: "AI Ad Copywriting",
                          ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerButton extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const ContainerButton({
    super.key,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: sfBold.copyWith(color: Colors.white)),
            const SizedBox(height: 4),
            Text(subtitle, style: sfMedium.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String? title;
  final String? intro;
  final VoidCallback? onTap;
  final Color? color;
  final String? icon;
  const CardWidget({
    super.key,
    this.title,
    this.onTap,
    this.color,
    this.intro,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            offset: const Offset(0, 20),
          )
        ],
      ),
      child: Center(
        child: ListTile(
          leading: Image.asset(
            icon!,
            width: 70,
            height: 70,
            fit: BoxFit.contain,
          ),
          onTap: () {
            onTap!();
          },
          title: Text(
            title ?? '',
            style: sfBold.copyWith(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              intro ?? '',
              style: sfRegular.copyWith(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

class SupportBottomSheet extends StatefulWidget {
  const SupportBottomSheet({super.key});

  @override
  SupportBottomSheetState createState() => SupportBottomSheetState();
}

class SupportBottomSheetState extends State<SupportBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    "Give Feedback",
                    style: sfBold.copyWith(fontSize: 18, color: Colors.white),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const SizedBox(height: 30.0),
            MyTextField(
              controller: _emailController,
              inputAction: TextInputAction.next,
              icon: Icons.email,
              hintText: 'Enter Email',
              inputType: TextInputType.text,
              isEnabled: true,
              fillColor: Colors.white,
            ),
            const SizedBox(height: 16.0),
            MyTextField(
              controller: _emailController,
              inputAction: TextInputAction.next,
              icon: Icons.person_outline,
              hintText: 'Enter Name',
              inputType: TextInputType.text,
              isEnabled: true,
              fillColor: Colors.white,
            ),
            const SizedBox(height: 16.0),
            MyTextField(
              maxLines: 3,
              controller: _emailController,
              inputAction: TextInputAction.next,
              icon: Icons.feedback,
              hintText: 'Feedback',
              inputType: TextInputType.text,
              isEnabled: true,
              fillColor: Colors.white,
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(context);
                    }
                  },
                  title: ('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
