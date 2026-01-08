import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onelamarket_app/core/constants/app_colors.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/routes.dart';
import '../controllers/signup_flow_controller.dart';

class PasswordPage extends ConsumerStatefulWidget {
  const PasswordPage({super.key});

  @override
  ConsumerState<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends ConsumerState<PasswordPage> {
  final _controller = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.read(signupFlowProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('รหัสผ่าน'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _controller,
              obscureText: _obscure,
              decoration: InputDecoration(
                hintText: 'รหัสผ่าน',
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: AppSizes.buttonH,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                onPressed: () {
                  flow.setPassword(_controller.text.trim());
                  final next = flow.nextAfterPassword();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    next,
                    (r) => r.settings.name == Routes.welcome,
                  );
                },
                child: const Text(
                  AppStrings.continueText,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
