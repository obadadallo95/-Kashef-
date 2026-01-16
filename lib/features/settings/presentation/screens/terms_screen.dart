import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('terms.title'.tr(), style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
            centerTitle: true,
            pinned: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(20.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                 Text(
                   'terms.alert_title'.tr(),
                   style: GoogleFonts.cairo(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.orange[800]),
                   textAlign: TextAlign.center,
                 ),
                 SizedBox(height: 16.h),
                 Container(
                   padding: EdgeInsets.all(16.w),
                   decoration: BoxDecoration(
                     color: Colors.orange.withOpacity(0.1),
                     borderRadius: BorderRadius.circular(12.r),
                     border: Border.all(color: Colors.orange.withOpacity(0.3)),
                   ),
                   child: Text(
                     'terms.alert_desc'.tr(),
                     style: GoogleFonts.cairo(fontSize: 16.sp, fontWeight: FontWeight.bold, height: 1.5),
                     textAlign: TextAlign.center,
                   ),
                 ),
                 SizedBox(height: 32.h),

                 _buildTermPoint('terms.point1_title'.tr(), 'terms.point1_desc'.tr()),

                 _buildTermPoint('terms.point2_title'.tr(), 'terms.point2_desc'.tr()),

                 _buildTermPoint('terms.point3_title'.tr(), 'terms.point3_desc'.tr()),

                 _buildTermPoint('terms.point4_title'.tr(), 'terms.point4_desc'.tr()),
                 
                 SizedBox(height: 32.h),
                 Center(
                   child: ElevatedButton(
                     onPressed: () => Navigator.pop(context),
                     style: ElevatedButton.styleFrom(
                       padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                     ),
                     child: Text('terms.acknowledge'.tr(), style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                   ),
                 ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermPoint(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: GoogleFonts.cairo(fontSize: 14.sp, color: Colors.grey[700], height: 1.6),
          ),
        ],
      ),
    );
  }
}
