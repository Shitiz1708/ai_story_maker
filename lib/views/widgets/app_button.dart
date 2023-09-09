import 'package:flutter/material.dart';

import '../../utils/text_style.dart';

class AppButton extends StatelessWidget {
  final String? title;
  final bool? isLoading;
  final VoidCallback? onTap;
  const AppButton({
    super.key,
    this.title,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        height: 45,
        width: 200,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: isLoading!
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.white,
              ))
            : Center(
                child: Text(title ?? '',
                    style: sfBold.copyWith(color: Colors.white, fontSize: 17)),
              ),
      ),
    );
  }
}
