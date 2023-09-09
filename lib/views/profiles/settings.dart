import 'package:ai_story_maker/controllers/auth_controller.dart';
import 'package:ai_story_maker/views/profiles/saved_stories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/text_style.dart';
import 'child_profiles.dart';

AuthController authController = Get.put(AuthController());

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Text(
                    'Profile',
                    style: sfBold.copyWith(color: Colors.black, fontSize: 25),
                  ),
                ),
                _buildSection('Account', [
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(Icons.star, 'Generated Posts', Colors.blue,
                      () {
                    Get.to(() => const GeneratedPosts());
                  }),
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(Icons.child_care, 'Brand\'s Profile',
                      const Color.fromARGB(255, 7, 186, 138), () {
                    Get.to(() => const ChildProfiles());
                  }),
                  const Divider(
                    color: Colors.grey,
                  ),
                ]),
                _buildSection('SHARE', [
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(
                      Icons.email, 'Rate us on Play Store', Colors.blue, () {}),
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(Icons.sms, 'Share App',
                      const Color.fromARGB(255, 7, 186, 138), () {}),
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(
                      Icons.share, 'Give Feedback', Colors.green, () {}),
                  const Divider(
                    color: Colors.grey,
                  ),
                ]),
                _buildSection('PRIVACY POLICY', [
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(
                      Icons.lock, 'Privacy Policy', Colors.purple, () {}),
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(Icons.person, 'Terms & Conditions',
                      Colors.blueAccent, () {}),
                  const Divider(
                    color: Colors.grey,
                  ),
                ]),
                _buildSection('UPGRADE TO PREMIUM', [
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(Icons.star, 'Upgrade to Premium',
                      const Color.fromRGBO(197, 73, 44, 1), () {}),
                  const Divider(
                    color: Colors.grey,
                  ),
                ]),
                _buildSection('Account Session', [
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(Icons.logout, 'LogOut', Colors.green, () {
                    authController.logout();
                  }),
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(
                      Icons.delete, 'Delete Account', Colors.red, () {}),
                  const Divider(
                    color: Colors.grey,
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildSettingItem(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16.0),
            Text(
              title,
              style: sfSemiBold.copyWith(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}


//Caption Generation
//Keywords Suggestion
//Blog Post Generation
//