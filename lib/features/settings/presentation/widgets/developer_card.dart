import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:easy_localization/easy_localization.dart'; // Import easy_localization

class DeveloperCard extends StatelessWidget {
  const DeveloperCard({super.key});

  // Contact Links
  final String _githubUrl = "https://github.com/obadadallo95";
  final String _linkedinUrl = "https://www.linkedin.com/in/obada-dallo-777a47a9/";
  final String _facebookUrl = "https://www.facebook.com/obada.dallo33";
  final String _telegramUrl = "https://t.me/obada_dallo95";
  final String _emailUrl = "mailto:obada.dallo95@gmail.com";

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A237E), // Deep Blue
            Color(0xFF4A148C), // Deep Purple
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A148C).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          // Avatar with Glow
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white24,
              backgroundImage: const AssetImage('assets/team/obada_dallo.jpg'),
            ),
          ),
          const SizedBox(height: 16),
          
          // Name & Role
          Text(
            'developer.name'.tr(),
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'developer.role'.tr(),
            style: GoogleFonts.cairo(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
          
          const SizedBox(height: 12),
          // Bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'developer.bio'.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                color: Colors.white60,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          const SizedBox(height: 24),
          
          // Contact Label
          Text(
            'developer.contact_me'.tr(),
            style: GoogleFonts.cairo(
              color: Colors.white30,
              fontSize: 10,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Divider(color: Colors.white.withOpacity(0.1)),
          ),

          // Icons Row
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(FontAwesomeIcons.github, _githubUrl),
                _buildSocialIcon(FontAwesomeIcons.linkedin, _linkedinUrl),
                _buildSocialIcon(FontAwesomeIcons.facebook, _facebookUrl),
                _buildSocialIcon(FontAwesomeIcons.telegram, _telegramUrl),
                _buildSocialIcon(Icons.email, _emailUrl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () => _launchUrl(url),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            icon,
            color: Colors.white.withOpacity(0.9),
            size: 20,
          ),
        ),
      ),
    );
  }
}
