import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onelamarket_app/core/constants/app_colors.dart';
import 'package:onelamarket_app/core/routing/routes.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';
import '../controllers/signup_flow_controller.dart';
import '../controllers/signup_flow_state.dart';
import '../widgets/social_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (prev, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error!)));
      }
      if (prev?.user == null && next.user != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เข้าสู่ระบบสำเร็จ: ${next.user!.email} (mock)')));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('เข้าสู่ระบบ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.p20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                      decoration: const InputDecoration(hintText: 'อีเมล'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _pass,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        hintText: 'รหัสผ่าน',
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                        ),
                      ),
                    ),
                  ],
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
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();

                          if (!(_formKey.currentState?.validate() ?? false)) return;

                          await ref
                              .read(authControllerProvider.notifier)
                              .signInEmail(_email.text.trim());

                          if (!context.mounted) return;

                          Navigator.pushReplacementNamed(context, Routes.main);
                        },
                  child: auth.isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'ดำเนินการต่อ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(AppStrings.or, style: Theme.of(context).textTheme.bodySmall),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),

              SocialButton(
                iconPath: Assets.icLine,
                text: AppStrings.continueWithLine,
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        // mock social login
                        ref.read(signupFlowProvider.notifier).setAuthMethod(AuthMethod.social);
                        await ref
                            .read(authControllerProvider.notifier)
                            .signInSocial(SocialProvider.line);
                        Navigator.pushReplacementNamed(context, Routes.main);
                      },
              ),
              const SizedBox(height: 10),
              SocialButton(
                iconPath: Assets.icGoogle,
                text: AppStrings.continueWithGoogle,
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        ref.read(signupFlowProvider.notifier).setAuthMethod(AuthMethod.social);
                        await ref
                            .read(authControllerProvider.notifier)
                            .signInSocial(SocialProvider.google);
                      },
              ),
              const SizedBox(height: 10),
              SocialButton(
                iconPath: Assets.icFacebook,
                text: AppStrings.continueWithFacebook,
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        ref.read(signupFlowProvider.notifier).setAuthMethod(AuthMethod.social);
                        await ref
                            .read(authControllerProvider.notifier)
                            .signInSocial(SocialProvider.facebook);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
