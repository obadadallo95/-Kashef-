import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kashef/features/donation/ui/donation_sheet.dart';

class SupportButton extends StatefulWidget {
  const SupportButton({Key? key}) : super(key: key);

  @override
  State<SupportButton> createState() => _SupportButtonState();
}

class _SupportButtonState extends State<SupportButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FloatingActionButton.small(
        heroTag: 'support_btn',
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const DonationBottomSheet(),
          );
        },
        backgroundColor: Colors.amber[700],
        child: Icon(Icons.volunteer_activism, color: Colors.white, size: 20.sp),
      ),
    );
  }
}
