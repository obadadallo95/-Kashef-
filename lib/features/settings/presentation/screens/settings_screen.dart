import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme_controller.dart';
import '../../../auth/controllers/app_lock_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('settings.title'.tr()),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Security Status Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF1B5E20), const Color(0xFF2E7D32)], // Dark Green for Security
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1B5E20).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.shield, color: Colors.white, size: 32.sp),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'settings.shield_active'.tr(),
                      style: GoogleFonts.cairo(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.lightGreenAccent, size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(
                          'settings.privacy_mode'.tr(),
                          style: GoogleFonts.cairo(
                            fontSize: 14.sp,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          _buildSectionHeader(context, 'settings.general'.tr()),
          _buildSettingsTile(
            context,
            icon: Icons.language,
            title: 'settings.language'.tr(),
            trailing: DropdownButton<Locale>(
              value: context.locale,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('ar'),
                  child: Text('العربية'),
                ),
              ],
              onChanged: (locale) {
                if (locale != null) {
                  context.setLocale(locale);
                }
              },
            ),
          ),

          SizedBox(height: 24.h),
          _buildSectionHeader(context, 'settings.appearance'.tr()),
          _buildSettingsTile(
            context,
            icon: Icons.lock_outline,
            title: 'auth.app_lock'.tr(),
            subtitle: 'auth.biometric_desc'.tr(),
            trailing: Consumer(
              builder: (context, ref, child) {
                final isEnabled = ref.watch(appLockControllerProvider.select((s) => s.isEnabled));
                return Switch(
                  value: isEnabled,
                  onChanged: (value) async {
                    if (value) {
                      await ref.read(appLockControllerProvider.notifier).enableBiometrics();
                    } else {
                      await ref.read(appLockControllerProvider.notifier).disableBiometrics();
                    }
                  },
                  activeTrackColor: Theme.of(context).primaryColor,
                );
              },
            ),
          ),
          _buildSettingsTile(
            context,
            icon: isDark ? Icons.dark_mode : Icons.light_mode,
            title: 'settings.dark_mode'.tr(),
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (value) {
                ref.read(themeControllerProvider.notifier).toggleTheme();
              },
              activeTrackColor: Theme.of(context).primaryColor,
            ),
          ),

          SizedBox(height: 24.h),
          _buildSectionHeader(context, 'settings.support'.tr()),
          _buildSettingsTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'settings.privacy_policy'.tr(),
            onTap: () => context.go('/settings/privacy'),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.description_outlined,
            title: 'settings.terms_of_service'.tr(),
            onTap: () => context.go('/settings/terms'),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: 'settings.about'.tr(),
            subtitle: 'v1.0.0',
            onTap: () => context.go('/settings/about'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 8.h, start: 4.w, end: 4.w),
      child: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.w),
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Icon(icon, size: 20.sp, color: Theme.of(context).primaryColor),
        ),
        title: Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: GoogleFonts.cairo(fontSize: 12.sp, color: Colors.grey),
              )
            : null,
        trailing: trailing ?? (onTap != null ? Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey) : null),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }
}
