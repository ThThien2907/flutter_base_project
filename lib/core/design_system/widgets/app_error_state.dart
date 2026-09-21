import 'package:flutter/material.dart';

import '../components/primary_text.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PrimaryText(
        message,
        style: AppTextStyles.bodyMedium,
        color: AppColors.error,
        textAlign: TextAlign.center,
      ),
    );
  }
}
