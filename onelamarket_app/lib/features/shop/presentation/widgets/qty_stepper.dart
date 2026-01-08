import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class QtyStepper extends StatelessWidget {
  const QtyStepper({super.key, required this.qty, required this.onMinus, required this.onPlus});

  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.fieldBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: onMinus, icon: const Icon(Icons.remove)),
          Text('$qty', style: const TextStyle(fontWeight: FontWeight.w700)),
          IconButton(onPressed: onPlus, icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
