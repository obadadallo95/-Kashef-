import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../../core/services/preferences_service.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntroductionScreen(
        pages: [
          PageViewModel(
            titleWidget: Text(
              'onboarding.title1'.tr(),
              style: GoogleFonts.cairo(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            bodyWidget: Text(
              'onboarding.body1'.tr(),
              style: GoogleFonts.cairo(fontSize: 16.sp, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            image: Center(child: Icon(Icons.analytics, size: 100.sp, color: Theme.of(context).primaryColor)),
            decoration: PageDecoration(
              pageColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          PageViewModel(
            titleWidget: Text(
              'onboarding.title2'.tr(),
              style: GoogleFonts.cairo(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            bodyWidget: Text(
              'onboarding.body2'.tr(),
              style: GoogleFonts.cairo(fontSize: 16.sp, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            image: Center(child: Icon(Icons.security, size: 100.sp, color: Theme.of(context).primaryColor)),
            decoration: PageDecoration(
              pageColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          PageViewModel(
            titleWidget: Text(
              'onboarding.title3'.tr(),
              style: GoogleFonts.cairo(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            bodyWidget: Text(
              'onboarding.body3'.tr(),
              style: GoogleFonts.cairo(fontSize: 16.sp, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            image: Center(child: Icon(Icons.check_circle_outline, size: 100.sp, color: Theme.of(context).primaryColor)),
            decoration: PageDecoration(
              pageColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ],
        showSkipButton: true,
        skip: Text('onboarding.skip'.tr(), style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        next: Text('onboarding.next'.tr(), style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        done: Text('onboarding.done'.tr(), style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        onDone: () => _onIntroEnd(context, ref),
        onSkip: () => _onIntroEnd(context, ref),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).primaryColor,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      );
  }

  Future<void> _onIntroEnd(BuildContext context, WidgetRef ref) async {
    await ref.read(preferencesServiceProvider).setHasSeenOnboarding(true);
    if (context.mounted) {
      context.go('/');
    }
  }
}
