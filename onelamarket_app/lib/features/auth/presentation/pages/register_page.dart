import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onelamarket_app/core/routing/routes.dart';
import 'package:onelamarket_app/features/auth/presentation/controllers/signup_flow_controller.dart';
import 'package:onelamarket_app/features/auth/presentation/controllers/signup_flow_state.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_button.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
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
        ).showSnackBar(SnackBar(content: Text('สมัครสมาชิกสำเร็จ: ${next.user!.email} (mock)')));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.registerTitle),
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
                child: AuthTextField(
                  controller: _email,
                  hintText: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
              ),
              const SizedBox(height: 14),

              PrimaryButton(
                text: AppStrings.continueText,
                isPrimary: true,
                isLoading: auth.isLoading,
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (!(_formKey.currentState?.validate() ?? false)) return;

                  // set flow method = email
                  ref
                      .read(signupFlowProvider.notifier)
                      .setAuthMethod(AuthMethod.email, email: _email.text.trim());

                  // mock register
                  await ref.read(authControllerProvider.notifier).registerEmail(_email.text.trim());

                  // ไปหน้าถัดไปตาม rule
                  final next = ref.read(signupFlowProvider.notifier).nextAfterRegister();
                  Navigator.pushReplacementNamed(context, Routes.main);
                },
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
                        // 1) บอก flow ว่าใช้ social
                        ref.read(signupFlowProvider.notifier).setAuthMethod(AuthMethod.social);

                        // 2) mock sign in
                        await ref
                            .read(authControllerProvider.notifier)
                            .signInSocial(SocialProvider.line);

                        // 3) ไปหน้าถัดไปตาม rule (household->shop / business->businessInfo)
                        final next = ref.read(signupFlowProvider.notifier).nextAfterRegister();
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

                        final next = ref.read(signupFlowProvider.notifier).nextAfterRegister();
                        Navigator.pushNamed(context, next);
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

                        final next = ref.read(signupFlowProvider.notifier).nextAfterRegister();
                        Navigator.pushNamed(context, next);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
