import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoScreen extends StatelessWidget {
  final String title;
  final String content;

  const InfoScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Text(
          content,
          style: GoogleFonts.cairo(
            fontSize: 16.sp,
            height: 1.6,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}
