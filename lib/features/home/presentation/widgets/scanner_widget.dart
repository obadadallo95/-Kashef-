import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/panic_service.dart';
import '../../../analysis/data/repositories/analysis_repository.dart';
import '../controllers/home_controller.dart';

class ScannerWidget extends ConsumerStatefulWidget {
  const ScannerWidget({super.key});

  @override
  ConsumerState<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends ConsumerState<ScannerWidget> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
      if (next.text.isEmpty && _textController.text.isNotEmpty) {
        _textController.clear();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInputCard(context, homeState),
        const SizedBox(height: 24),
        _buildAnalyzeButton(context, homeState),
        const SizedBox(height: 32),
        _buildSafetyTipsSection(context),
      ],
    );
  }

  Widget _buildInputCard(BuildContext context, HomeState state) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _textController,
              minLines: 5,
              maxLines: 10,
              onChanged: (value) => ref.read(homeControllerProvider.notifier).updateText(value),
              style: TextStyle(fontSize: 16, height: 1.5, color: Theme.of(context).textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: 'home.input_hint'.tr(),
                hintStyle: TextStyle(
                  color: Theme.of(context).hintColor.withOpacity(0.5),
                  fontSize: 14,
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
            
          Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildActionButton(
                  context, 
                  icon: Icons.camera_alt_outlined, 
                  label: 'home.take_photo'.tr(),
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                const SizedBox(width: 16),
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
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: FileImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            top: 8,
            end: 8,
            child: GestureDetector(
              onTap: () => ref.read(homeControllerProvider.notifier).removeImage(),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
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
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.cairo(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton(BuildContext context, HomeState state) {
    return SizedBox(
      height: 56,
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
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
        ),
        child: state.isAnalyzing
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield_outlined, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'home.analyze_btn'.tr(),
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
                fontSize: 18,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Theme.of(context).primaryColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'home.tip_example'.tr(),
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.blue[200] : const Color(0xFF1565C0),
                    fontSize: 14,
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                    height: 5,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'نتائج تحليل المحتوى',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.cairo().fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _buildScoreOverview(context, result),
                const SizedBox(height: 32),
                _buildSectionTitle(context, 'المخاطر المكتشفة', Icons.warning_amber_rounded),
                const SizedBox(height: 12),
                ...result.reasons.map((r) => _buildDetailCard(context, r, isWarning: true)),
                if (result.reasons.isEmpty)
                   _buildDetailCard(context, 'لم يتم العثور على مخاطر واضحة.', isWarning: false),
                
                if (result.saferAlternative != null && result.saferAlternative!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, '✨ اقتراح آمن (النسخة المنقحة)', Icons.auto_awesome),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.1),
                          Theme.of(context).primaryColor.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          result.saferAlternative!,
                          style: GoogleFonts.cairo(fontSize: 15, height: 1.6, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
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
                            icon: const Icon(Icons.copy, size: 16, color: Colors.white),
                            label: Text('نسخ واستخدام', style: GoogleFonts.cairo(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                _buildSectionTitle(context, 'نصائح التحسين', Icons.tips_and_updates_outlined),
                const SizedBox(height: 12),
                ...result.suggestions.map((s) => _buildDetailCard(context, s, isWarning: false)),
                
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 60, color: color),
          const SizedBox(height: 16),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'نسبة الخطر: ${result.score}%',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: result.score / 100,
              color: color,
              backgroundColor: Colors.grey[200],
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(BuildContext context, String text, {required bool isWarning}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
           right: BorderSide(
             color: isWarning ? Colors.orange : Colors.blue, 
             width: 4
           ),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.cairo(fontSize: 14, height: 1.5),
      ),
    );
  }
}
