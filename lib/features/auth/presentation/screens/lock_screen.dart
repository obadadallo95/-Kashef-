import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/app_lock_controller.dart';

class LockScreen extends ConsumerWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80.sp,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 24.h),
            Text(
              'app_title'.tr(),
              style: GoogleFonts.cairo(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'auth.locked_message'.tr(), // Needs 'locked_message' in arb
              style: GoogleFonts.cairo(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 48.h),
            ElevatedButton(
              onPressed: () async {
                await ref.read(appLockControllerProvider.notifier).authenticate();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: Text(
                'auth.unlock'.tr(), // Needs 'unlock' in arb
                style: GoogleFonts.cairo(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
