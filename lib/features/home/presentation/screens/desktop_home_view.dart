import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/scanner_widget.dart';

class DesktopHomeView extends StatelessWidget {
  const DesktopHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAppBar(context),
            _buildHeroSection(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
      child: Row(
        children: [
           Image.asset(
             'assets/images/logo_kashef.png',
             height: 50.h,
           ),
           SizedBox(width: 12.w),
           Text(
             'home.title'.tr(),
             style: GoogleFonts.cairo(
               fontSize: 22.sp,
               fontWeight: FontWeight.bold,
               color: Theme.of(context).primaryColor,
             ),
           ),
           const Spacer(),
           _buildNavButton(context, 'الرئيسية', () {}),
           _buildNavButton(context, 'عن التطبيق', () => context.push('/settings')), // Reuse settings for About for now
           _buildNavButton(context, 'سياسة الخصوصية', () => context.push('/privacy-policy')),
           _buildNavButton(context, 'GitHub', () => _launchUrl('https://github.com/obadadallo95/-Kashef-')),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.cairo(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 60.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Text
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Text(
                  'احمِ محتواك الرقمي\nبذكاء اصطناعي متطور',
                  style: GoogleFonts.cairo(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'كاشف هو درعك الرقمي الذكي الذي يفحص النصوص والصور للتأكد من سلامتها من كلمات الحظر والمحتوى الحساس، مع تقديم بدائل آمنة فورياً.',
                  style: GoogleFonts.cairo(
                    fontSize: 18.sp,
                    height: 1.6,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 40.h),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {}, // Scroll to scanner or download
                      icon: const Icon(Icons.android, color: Colors.white),
                      label: Text('حمل التطبيق', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    OutlinedButton.icon(
                       onPressed: () => _launchUrl('https://github.com/obadadallo95/-Kashef-'),
                       icon: Icon(Icons.code, color: Theme.of(context).primaryColor),
                       label: Text('المصدر المفتوح', style: GoogleFonts.cairo(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                       style: OutlinedButton.styleFrom(
                         padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                         side: BorderSide(color: Theme.of(context).primaryColor),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                       ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(width: 80.w),
          
          // Right Column: The App (Scanner)
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: const ScannerWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () => _launchUrl('https://github.com'), icon: const Icon(Icons.code)),
              IconButton(onPressed: () => _launchUrl('https://linkedin.com'), icon: const Icon(Icons.link)),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            '© 2026 Kashef. Open Source Project.',
            style: GoogleFonts.cairo(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
