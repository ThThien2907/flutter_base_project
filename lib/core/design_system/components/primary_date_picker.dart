import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../formatting/date_format_utils.dart';
import 'primary_text_field.dart';

class PrimaryDatePicker extends StatelessWidget {
  const PrimaryDatePicker({
    super.key,
    required this.controller,
    required this.hintText,
    required this.firstDate,
    required this.lastDate,
    this.label,
    this.initialDate,
    this.prefixIcon = const Icon(Icons.calendar_month_rounded),
    this.enabled = true,
    this.validator,
    this.onDateChanged,
  });

  final TextEditingController controller;
  final String? label;
  final String hintText;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialDate;
  final Widget prefixIcon;
  final bool enabled;
  final FormFieldValidator<String>? validator;
  final ValueChanged<DateTime>? onDateChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? () => _pickDate(context) : null,
      child: AbsorbPointer(
        child: PrimaryTextField(
          controller: controller,
          label: label,
          hintText: hintText,
          prefixIcon: prefixIcon,
          enabled: enabled,
          validator: validator,
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final parsedInitialDate = DateFormatUtils.parseDisplayDate(controller.text);
    final resolvedInitialDate = _resolveInitialDate(
      parsedInitialDate ?? initialDate ?? DateTime.now(),
    );

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: resolvedInitialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: context.locale,
    );

    if (pickedDate == null || !context.mounted) {
      return;
    }

    controller.text = DateFormatUtils.formatDisplayDate(pickedDate);
    onDateChanged?.call(pickedDate);
  }

  DateTime _resolveInitialDate(DateTime date) {
    if (date.isBefore(firstDate)) {
      return firstDate;
    }
    if (date.isAfter(lastDate)) {
      return lastDate;
    }
    return date;
  }
}
