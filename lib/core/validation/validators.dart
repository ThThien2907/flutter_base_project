import 'package:easy_localization/easy_localization.dart';

class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.email_required'.tr();
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'validation.invalid_email_format'.tr();
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.username_required'.tr();
    }
    if (value.trim().length < 3) {
      return 'validation.username_min_length'.tr();
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.full_name_required'.tr();
    }
    if (value.trim().length < 2) {
      return 'validation.full_name_min_length'.tr();
    }
    return null;
  }

  static String? validateEmptyField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.text_required'.tr();
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.phone_required'.tr();
    }
    final phoneRegex = RegExp(r'^(\+84|84|0)[3|5|7|8|9][0-9]{8}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'validation.phone_invalid'.tr();
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.password_required'.tr();
    }
    if (value.length < 6) {
      return 'validation.password_short'.tr();
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'validation.confirm_password_required'.tr();
    }
    if (value != originalPassword) {
      return 'validation.confirm_password_mismatch'.tr();
    }
    return null;
  }
}
