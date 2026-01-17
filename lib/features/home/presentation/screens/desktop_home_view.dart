import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../donation/ui/donation_sheet.dart';
import '../widgets/scanner_widget.dart';

class DesktopHomeView extends StatelessWidget {
  const DesktopHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const DonationBottomSheet(),
            );
          },
          backgroundColor: Colors.amber[700],
          icon: const Icon(Icons.volunteer_activism, color: Colors.white),
          label: Text(
            'ادعم المشروع',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat, // Left side for Arabic
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
            child: Column(
              children: [
                _buildAppBar(context),
                const Spacer(),
                _buildHeroSection(context),
                const Spacer(),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo Section
        Row(
          children: [
            Image.asset(
              'assets/images/logo_kashef.png',
              height: 48, // Fixed height, reasonably small
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Text(
              'home.title'.tr(),
              style: GoogleFonts.cairo(
                fontSize: 24, // Reduced from 22.sp (which could be huge)
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),

        // Navigation Links
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNavButton(context, 'الرئيسية', () {}),
            const SizedBox(width: 24),
            _buildNavButton(context, 'الإعدادات', () => context.push('/settings')),
            const SizedBox(width: 24),
            _buildNavButton(context, 'عن التطبيق', () => context.push('/settings/about')),
            const SizedBox(width: 24),
            _buildNavButton(context, 'سياسة الخصوصية', () => context.push('/privacy-policy')),
            const SizedBox(width: 24),
            _buildNavButton(context, 'GitHub', () => _launchUrl('https://github.com/obadadallo95/-Kashef-')),
          ],
        ),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.cairo(
          fontSize: 16, // Web standard
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Column: Text (50%)
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'احمِ محتواك الرقمي\nبذكاء اصطناعي متطور',
                style: GoogleFonts.cairo(
                  fontSize: 40, // Max 40px as requested
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                  color: Theme.of(context).textTheme.displayLarge?.color,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'كاشف هو درعك الرقمي الذكي الذي يفحص النصوص والصور للتأكد من سلامتها من كلمات الحظر والمحتوى الحساس، مع تقديم بدائل آمنة فورياً.',
                style: GoogleFonts.cairo(
                  fontSize: 18, // Max 18px body
                  height: 1.8,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _launchUrl('https://github.com/obadadallo95/-Kashef-/releases'), 
                    icon: const Icon(Icons.download_rounded, color: Colors.white, size: 20),
                    label: Text('حمل التطبيق', style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  OutlinedButton.icon(
                     onPressed: () => _launchUrl('https://github.com/obadadallo95/-Kashef-'),
                     icon: Icon(Icons.code, color: Theme.of(context).primaryColor, size: 20),
                     label: Text('المصدر المفتوح', style: GoogleFonts.cairo(color: Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
                     style: OutlinedButton.styleFrom(
                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                       side: BorderSide(color: Theme.of(context).primaryColor),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                     ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 60),
        
        // Right Column: The App (Scanner) - Fixed Width Phone Look
        Container(
          width: 380, // Fixed phone/card width
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: const ScannerWidget(),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '© 2026 Kashef. Open Source Project.',
              style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(width: 16),
             IconButton(
              iconSize: 20,
              onPressed: () => _launchUrl('https://github.com/obadadallo95/-Kashef-'), 
              icon: const Icon(Icons.code, color: Colors.grey)
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
