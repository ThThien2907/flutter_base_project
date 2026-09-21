class PhoneFormatUtils {
  PhoneFormatUtils._();

  static String formatPhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) return '--';
    final formatted = phone.trim();
    if (formatted.startsWith('+84')) {
      return '0${formatted.substring(3)}';
    } else if (formatted.startsWith('84')) {
      return '0${formatted.substring(2)}';
    }
    return formatted;
  }
}
