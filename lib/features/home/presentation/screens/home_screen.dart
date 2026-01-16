import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../analysis/data/repositories/analysis_repository.dart';
import '../../../../core/services/panic_service.dart';
import '../../../analysis/data/repositories/analysis_repository.dart';
import '../../../../core/services/panic_service.dart';
import '../../../donation/ui/support_button.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start listening for shake events
    // We need to wait for the build to complete to have valid context for navigation, 
    // or pass context dynamically. PanicService logic handles context check.
    WidgetsBinding.instance.addPostFrameCallback((_) {
       ref.read(panicServiceProvider).startListening(context);
    });
  }

  @override
  void dispose() {
    ref.read(panicServiceProvider).stopListening();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeControllerProvider);

    ref.listen(homeControllerProvider, (previous, next) {
      if (previous?.result != next.result && next.result != null) {
        _showResultDialog(context, next.result!);
      }
      // Panic Mode Sync: If state text is cleared, clear the controller too.
      if (next.text.isEmpty && _textController.text.isNotEmpty) {
        _textController.clear();
      }
    });

    // Initialize Panic Service once
    // We use a post-frame callback or simple check to ensure we don't start it multiple times if build re-runs,
    // but ShakeDetector handles multiple calls gracefully (it has a running check).
    // Better to put in initState, but we need 'ref'.
    // Since this is a ConsumerStatefulWidget, we can use initState.
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPress();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 180.h,
                    floating: false,
                    pinned: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding: EdgeInsets.only(bottom: 16.h),
                      expandedTitleScale: 1.2,
                      title: Text(
                        'home.title'.tr(),
                        style: GoogleFonts.cairo(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                      background: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           SizedBox(height: 60.h),
                           Text(
                            'home.subtitle'.tr(),
                            style: GoogleFonts.cairo(
                              color: Colors.grey[600],
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.settings, color: Theme.of(context).primaryColor),
                        onPressed: () => context.push('/settings'),
                      ),
                    ],
                  ),
                ];
              },
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInputCard(context, homeState),
                    SizedBox(height: 24.h),
                    _buildAnalyzeButton(context, homeState),
                    SizedBox(height: 32.h),
                    _buildSafetyTipsSection(context),
                  ],
                ),
              ),
            ),
            // Floating Support Button (Top Left/Right based on locale)
            PositionedDirectional(
              top: 50.h, // Below status bar
              start: 20.w,
              child: const SupportButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(BuildContext context, HomeState state) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _textController,
              minLines: 5,
              maxLines: 10,
              onChanged: (value) => ref.read(homeControllerProvider.notifier).updateText(value),
              style: TextStyle(fontSize: 16.sp, height: 1.5, color: Theme.of(context).textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: 'home.input_hint'.tr(),
                hintStyle: TextStyle(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          
          if (state.selectedImage != null)
            _buildImagePreview(context, state.selectedImage!),
            
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                _buildActionButton(
                  context, 
                  icon: Icons.camera_alt_outlined, 
                  label: 'home.take_photo'.tr(),
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                SizedBox(width: 16.w),
                _buildActionButton(
                  context, 
                  icon: Icons.image_outlined, 
                  label: 'home.pick_image'.tr(),
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, File image) {
    return Container(
      height: 200.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          image: FileImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            top: 8.h,
            end: 8.w,
            child: GestureDetector(
              onTap: () => ref.read(homeControllerProvider.notifier).removeImage(),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 18.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 22.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.cairo(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton(BuildContext context, HomeState state) {
    return SizedBox(
      height: 56.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: state.isAnalyzing 
            ? null 
            : () {
                HapticFeedback.heavyImpact();
                if (state.text.isEmpty && state.selectedImage == null) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('الرجاء إدخال نص أو صورة للتحليل', style: GoogleFonts.cairo())),
                   );
                  return;
                }
                ref.read(homeControllerProvider.notifier).analyzeContent();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.4),
        ),
        child: state.isAnalyzing
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined, color: Colors.white, size: 24.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'home.analyze_btn'.tr(),
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSafetyTipsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'home.quick_tips'.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Theme.of(context).primaryColor, size: 28.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'home.tip_example'.tr(),
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.blue[200] : const Color(0xFF1565C0),
                    fontSize: 14.sp,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  DateTime? _lastBackPressTime;

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
  
  Future<void> _pickImage(ImageSource source) async {
    await ref.read(homeControllerProvider.notifier).pickImage(source);
  }

  void _showResultDialog(BuildContext context, AnalysisResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              children: [
                Center(
                  child: Container(
                    height: 5.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5.r),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'نتائج تحليل المحتوى',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.cairo().fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                _buildScoreOverview(context, result),
                SizedBox(height: 32.h),
                _buildSectionTitle(context, 'المخاطر المكتشفة', Icons.warning_amber_rounded),
                SizedBox(height: 12.h),
                ...result.reasons.map((r) => _buildDetailCard(context, r, isWarning: true)),
                if (result.reasons.isEmpty)
                   _buildDetailCard(context, 'لم يتم العثور على مخاطر واضحة.', isWarning: false),
                
                if (result.saferAlternative != null && result.saferAlternative!.isNotEmpty) ...[
                  SizedBox(height: 24.h),
                  _buildSectionTitle(context, '✨ اقتراح آمن (النسخة المنقحة)', Icons.auto_awesome),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          Theme.of(context).primaryColor.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          result.saferAlternative!,
                          style: GoogleFonts.cairo(fontSize: 15.sp, height: 1.6, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 12.h),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: result.saferAlternative!));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('تم نسخ النص المقترح', style: GoogleFonts.cairo())),
                              );
                              Navigator.pop(context); // Close dialog
                            },
                            icon: Icon(Icons.copy, size: 16.sp, color: Colors.white),
                            label: Text('نسخ واستخدام', style: GoogleFonts.cairo(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 24.h),
                _buildSectionTitle(context, 'نصائح التحسين', Icons.tips_and_updates_outlined),
                SizedBox(height: 12.h),
                ...result.suggestions.map((s) => _buildDetailCard(context, s, isWarning: false)),
                
                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: Text(
                      'إغلاق',
                      style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildScoreOverview(BuildContext context, AnalysisResult result) {
    Color color;
    String label;
    IconData icon;

    if (result.riskLevel == 'Safe') {
      color = Colors.green;
      label = 'آمن للنشر';
      icon = Icons.check_circle_outline;
    } else if (result.riskLevel == 'Warning') {
      color = Colors.orange;
      label = 'محتوى حساس';
      icon = Icons.warning_amber_rounded;
    } else {
      color = Colors.red;
      label = 'خطر الحظر';
      icon = Icons.block;
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 60.sp, color: color),
          SizedBox(height: 16.h),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'نسبة الخطر: ${result.score}%',
            style: GoogleFonts.cairo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: result.score / 100,
              color: color,
              backgroundColor: Colors.grey[200],
              minHeight: 8.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20.sp),
        SizedBox(width: 8.w),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(BuildContext context, String text, {required bool isWarning}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
           right: BorderSide(
             color: isWarning ? Colors.orange : Colors.blue, 
             width: 4.w
           ),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.cairo(fontSize: 14.sp, height: 1.5),
      ),
    );
  }

  Widget _buildScoreIndicator(BuildContext context, int score, String level) {
    // Deprecated in favor of _buildScoreOverview
    return SizedBox.shrink(); 
  }
}
