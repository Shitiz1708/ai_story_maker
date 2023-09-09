import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ValidateType { normal, email, number, phone, tag, password }

class UtilValidator {
  static const String errorEmpty = "This field is required";
  static const String errorRange = "value_not_valid_range";
  static const String errorEmail = "Please Enter Valid Email";
  static const String errorNumber = "Please Enter Valid Phone Number";
  static const String errorPhone = "Please Enter Valid Phone Number";
  static const String errorPassword = "Password must be at least 6 characters";
  static const String errorId = "value_not_valid_id";
  static const String valueNotMatch = "value_not_match";
  static const String valueNotIsTag = "value_not_is_tag";

  static hiddenKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static String formatDate(DateTime date) {
    //format date  Sep 11, 2022 17:12

    String formattedDate = DateFormat('MMM dd, yyyy HH:mm').format(date);
    return formattedDate;
  }

  static String? validate(
    String data, {
    ValidateType? type = ValidateType.normal,
    int? min,
    int? max,
    bool allowEmpty = false,
    String? match,
  }) {
    ///Empty
    if (!allowEmpty && data.isEmpty) {
      return errorEmpty;
    }

    ///Match
    if (match != null && match != data) {
      return valueNotMatch;
    }

    if (data.isEmpty) return null;

    switch (type) {
      ///Email pattern
      case ValidateType.email:
        final emailRegex = RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
        );
        if (!emailRegex.hasMatch(data)) {
          return errorEmail;
        }
        break;

      //  ///Email pattern
      case ValidateType.password:
        if (!allowEmpty && data.isEmpty) {
          return errorEmpty;
        } else if (data.length < 6) {
          return errorPassword;
        }
        break;

      ///Phone pattern
      case ValidateType.number:
        final phoneRegex = RegExp(r'^[0-9]*$');
        if (!phoneRegex.hasMatch(data)) {
          return errorNumber;
        }
        break;

      ///Phone pattern
      case ValidateType.phone:
        const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
        final phoneRegex = RegExp(pattern);
        if (!phoneRegex.hasMatch(data)) {
          return errorPhone;
        }
        break;

      ///Tag pattern
      case ValidateType.tag:
        final tagRegex = RegExp(r'^([^0-9|\,\s]*)$');
        if (!tagRegex.hasMatch(data)) {
          return valueNotIsTag;
        }
        break;
      default:
    }
    return null;
  }

  ///Singleton factory
  static final UtilValidator _instance = UtilValidator._internal();

  factory UtilValidator() {
    return _instance;
  }

  UtilValidator._internal();
}
