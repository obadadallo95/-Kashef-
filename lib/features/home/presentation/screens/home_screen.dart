import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:kashef/features/home/presentation/screens/desktop_home_view.dart';
import 'package:kashef/features/home/presentation/widgets/scanner_widget.dart';
import 'package:kashef/features/settings/presentation/screens/settings_screen.dart';
import 'package:kashef/core/services/panic_service.dart';
import '../../../donation/ui/support_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    // Start listening for shake events (Panic Mode)
    WidgetsBinding.instance.addPostFrameCallback((_) {
       ref.read(panicServiceProvider).startListening(context);
    });
  }

  @override
  void dispose() {
    ref.read(panicServiceProvider).stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          // Desktop View
          return const DesktopHomeView();
        } else {
          // Mobile View
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              _handleBackPress();
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  'home.title'.tr(),
                  style: GoogleFonts.cairo(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings, color: Theme.of(context).primaryColor),
                    onPressed: () => context.push('/settings'),
                  ),
                ],
              ),
              body: Stack(
                children: [
                   const SingleChildScrollView(
                     child: Padding(
                       padding: EdgeInsets.all(16.0),
                       child: ScannerWidget(),
                     ),
                   ),
                   // Floating Support Button
                   PositionedDirectional(
                    top: 10.h,
                    start: 20.w,
                    child: const SupportButton(),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void _handleBackPress() {
    final now = DateTime.now();
    if (_lastBackPressTime == null || 
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('اضغط مرة أخرى للخروج', style: GoogleFonts.cairo()),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          margin: EdgeInsets.all(16.w),
        ),
      );
    } else {
      SystemNavigator.pop();
    }
  }
}