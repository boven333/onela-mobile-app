import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/routing/routes.dart';
import '../controllers/auth_controller.dart';
import '../widgets/primary_button.dart';
import '../widgets/segment_switch.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(userModeProvider);
    final startText = mode == UserMode.household
        ? AppStrings.startHousehold
        : AppStrings.startBusiness;

    return Scaffold(
      backgroundColor: AppColors.brand,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  const SegmentSwitch(),
                  const SizedBox(height: 18),

                  // Logo
                  Image.asset(Assets.logo, height: 72, fit: BoxFit.contain),
                  const SizedBox(height: 18),

                  // Promo
                  Text(
                    AppStrings.promoTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppStrings.promoSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.95),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Hero image
                  Expanded(
                    child: Center(child: Image.asset(Assets.onelaBox, fit: BoxFit.contain)),
                  ),

                  const SizedBox(height: 14),

                  // Bottom card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.p16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.r24),
                      boxShadow: const [
                        BoxShadow(color: AppColors.shadow, blurRadius: 18, offset: Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          startText,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        PrimaryButton(
                          text: AppStrings.register,
                          isPrimary: true,
                          onPressed: () => Navigator.pushNamed(context, Routes.register),
                        ),
                        const SizedBox(height: 10),
                        PrimaryButton(
                          text: AppStrings.login,
                          isPrimary: false,
                          onPressed: () => Navigator.pushNamed(context, Routes.login),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
