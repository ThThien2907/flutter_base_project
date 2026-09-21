import 'package:flutter/material.dart';

import '../components/primary_text.dart';
import '../theme/app_text_style.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PrimaryText(
        message,
        style: AppTextStyles.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
