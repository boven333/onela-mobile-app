import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.iconPath,
    required this.text,
    required this.onPressed,
  });

  final String iconPath;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonH,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textDark,
          side: const BorderSide(color: AppColors.fieldBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 22, height: 22),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
