import 'package:ai_story_maker/controllers/theme_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../utils/text_style.dart';

ThemeController themeController = Get.put(ThemeController());

class MyTextField extends StatefulWidget {
  final String? hintText;
  final int? maxlen;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final int? maxLines;
  final bool isPassword;
  final Callback? onTap;
  final Function? onChanged;
  final Callback? onSubmit;
  final Callback? onSubmit2;
  final bool isEnabled;
  final TextCapitalization capitalization;
  final Color? fillColor;
  final bool validator;
  final IconData? icon;
  final IconData? suffixIcon1;
  final IconData? suffixIcon2;
  final bool? isObscureText;
  final String? errorText;

  const MyTextField(
      {super.key,
      this.hintText = '',
      this.maxlen,
      this.controller,
      this.focusNode,
      this.nextFocus,
      this.isEnabled = true,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.maxLines = 1,
      this.onSubmit,
      this.onChanged,
      this.capitalization = TextCapitalization.none,
      this.onTap,
      this.fillColor,
      this.isPassword = false,
      this.validator = false,
      this.icon,
      this.isObscureText = true,
      this.errorText = '',
      this.suffixIcon1,
      this.suffixIcon2,
      this.onSubmit2});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool? obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isObscureText!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(
            child: TextField(
                maxLines: null,
                maxLength: widget.maxlen,
                controller: widget.controller,
                focusNode: widget.focusNode,
                style: sfBold.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black),
                textInputAction: widget.inputAction,
                keyboardType: widget.inputType,
                cursorColor: Theme.of(context).primaryColor,
                textCapitalization: widget.capitalization,
                enabled: widget.isEnabled,
                autofocus: false,
                obscureText: widget.isPassword ? obscureText! : false,
                decoration: InputDecoration(
                  counterText: '',
                  prefixIcon: widget.icon == null
                      ? const SizedBox.shrink()
                      : Icon(
                          widget.icon,
                          size: 30,
                          color: Colors.grey,
                        ),
                  errorText:
                      widget.validator ? "This Field Can't be empty" : null,
                  hintText: widget.hintText,
                  isDense: true,
                  filled: true,
                  fillColor: widget.fillColor ?? Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  hintStyle:
                      sfSemiBold.copyWith(color: Colors.grey, fontSize: 18),
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          icon: Icon(
                            obscureText!
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: _toggle,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                widget.onSubmit!();
                              },
                              child: Icon(
                                widget.suffixIcon1,
                                size: 25,
                                color: Colors.black,
                              ),
                            ),

                            widget.onSubmit2 == null
                                ? const SizedBox.shrink()
                                : const SizedBox(
                                    height: 30,
                                    child: VerticalDivider(
                                      color: Colors.grey,
                                      width: 3,
                                    ),
                                  ),
                            const SizedBox(
                              width: 6,
                            ),
                            widget.onSubmit2 == null
                                ? const SizedBox.shrink()
                                : InkWell(
                                    onTap: () {
                                      widget.onSubmit2!();
                                    },
                                    child: Icon(
                                      widget.suffixIcon2,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                            // IconButton(
                            //     onPressed: widget.onSubmit,
                            //     icon: Icon(widget.suffixIcon,
                            //         size: 30,
                            //         color: themeController.primaryHomeColor)),
                            // IconButton(
                            //     onPressed: widget.onSubmit,
                            //     icon: Icon(widget.suffixIcon,
                            //         size: 30,
                            //         color: themeController.primaryHomeColor)),
                          ],
                        ),
                ),
                onTap: widget.onTap,
                onSubmitted: (text) =>
                    FocusScope.of(context).requestFocus(widget.nextFocus)),
          ),
        ),
        widget.errorText == null
            ? const SizedBox()
            : Text(widget.errorText!,
                style: sfMedium.copyWith(color: Colors.red)),
      ],
    );
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText!;
    });
  }
}
