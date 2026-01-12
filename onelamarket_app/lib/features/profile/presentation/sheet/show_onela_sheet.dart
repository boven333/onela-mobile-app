import 'package:flutter/material.dart';

Future<T?> showOnelaSheet<T>({
  required BuildContext context,
  required Widget child,
  double initial = 0.92,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false, // ✅ สำคัญ
    backgroundColor: Colors.transparent,
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: initial,
        minChildSize: 0.55,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollCtrl) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              boxShadow: [
                BoxShadow(blurRadius: 20, color: Color(0x22000000), offset: Offset(0, -2)),
              ],
            ),
            child: child, // ✅ ไม่ต้องห่อ SingleChildScrollView
          );
        },
      );
    },
  );
}
