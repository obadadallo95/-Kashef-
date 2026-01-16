import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('privacy.title'.tr(), style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
            centerTitle: true,
            pinned: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(20.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildInfoCard(
                  context,
                  title: 'privacy.amnesia_title'.tr(),
                  content: 'privacy.amnesia_desc'.tr(),
                  icon: Icons.delete_sweep_outlined,
                  color: Colors.blue,
                  trailing: SizedBox(
                    width: 60.w,
                    height: 60.w,
                    child: Lottie.asset(
                      'assets/animations/data_amnesia.json',
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.privacy_tip, color: Colors.blue.withOpacity(0.5), size: 40.sp),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                _buildInfoCard(
                  context,
                  title: 'privacy.local_title'.tr(),
                  content: 'privacy.local_desc'.tr(),
                  icon: Icons.phone_android_outlined,
                  color: Colors.green,
                ),
                SizedBox(height: 16.h),
                _buildInfoCard(
                  context,
                  title: 'privacy.cloud_title'.tr(),
                  content: 'privacy.cloud_desc'.tr(),
                  icon: Icons.cloud_outlined,
                  color: Colors.deepPurple,
                ),
                SizedBox(height: 16.h),
                _buildInfoCard(
                  context,
                  title: 'privacy.tracking_title'.tr(),
                  content: 'privacy.tracking_desc'.tr(),
                  icon: Icons.do_not_disturb_alt_outlined,
                  color: Colors.red,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required String content, required IconData icon, required Color color, Widget? trailing}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(right: BorderSide(color: color, width: 4.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: 8.w),
                trailing,
              ],
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            content,
            style: GoogleFonts.cairo(
              fontSize: 14.sp,
              height: 1.6,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
