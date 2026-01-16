import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProcessFlowDiagram extends StatefulWidget {
  const ProcessFlowDiagram({super.key});

  @override
  State<ProcessFlowDiagram> createState() => _ProcessFlowDiagramState();
}

class _ProcessFlowDiagramState extends State<ProcessFlowDiagram> {
  int _currentStep = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimationLoop();
  }

  void _startAnimationLoop() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentStep = (_currentStep + 1) % 4;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
             color: Colors.black.withOpacity(0.05),
             blurRadius: 10,
             offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
             'about.process.journey'.tr(),
             style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStepIcon(Icons.phone_iphone, 'about.process.phone'.tr(), 0),
              _buildArrow(0),
              _buildStepIcon(Icons.shield_outlined, 'about.process.filter'.tr(), 1),
              _buildArrow(1),
              _buildStepIcon(Icons.cloud_sync_outlined, 'about.process.cloud'.tr(), 2),
              _buildArrow(2),
              _buildStepIcon(Icons.verified_user_outlined, 'about.process.safe'.tr(), 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIcon(IconData icon, String label, int index) {
    // 0 -> 1 -> 2 -> 3
    final bool isActive = _currentStep >= index;
    final bool isCurrent = _currentStep == index;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: isActive ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
            border: isCurrent ? Border.all(color: Colors.blue, width: 2) : null,
          ),
          child: Icon(
            icon,
            size: 24.sp,
            color: isActive ? Colors.blue : Colors.grey,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 10.sp,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.blue[800] : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildArrow(int index) {
    // Arrow lights up when transition happens (index -> index+1)
    // Current step is index means we are AT index.
    // Flow is 0->1, 1->2, 2->3.
    // If current is 0, arrow 0 should animate.
    final bool isActive = _currentStep > index;
    
    return Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16.sp,
      color: isActive ? Colors.green : Colors.grey.withOpacity(0.3),
    );
  }
}
