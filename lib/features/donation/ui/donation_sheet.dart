import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class DonationBottomSheet extends StatelessWidget {
  const DonationBottomSheet({Key? key}) : super(key: key);

  static const String _btcAddress = 'bc1p42akn5et2kuexnlmtyhhkv2rgngp85rzydww0zh2w9cc3rj86xhqfemhhe';
  static const String _ethAddress = '0xb15af72fd8e0dd098158b0251d43f9a272b6505d';
  static const String _solAddress = 'ANE9Sh9Y2ExSofj9wsR7vkxKKNuawSH9KtpztxEFXs3K';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
           BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 5),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5.h,
            width: 48.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5.r),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'support.title'.tr(),
            style: GoogleFonts.cairo(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'support.subtitle'.tr(),
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 14.sp,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          SizedBox(height: 32.h),

          _buildCryptoTile(
            context,
            name: 'Bitcoin (BTC)',
            symbol: 'BTC',
            address: _btcAddress,
            icon: FontAwesomeIcons.bitcoin,
            color: const Color(0xFFF7931A),
          ),
          _buildCryptoTile(
            context,
            name: 'Ethereum (ERC20)',
            symbol: 'ETH',
            address: _ethAddress,
            icon: FontAwesomeIcons.ethereum,
            color: const Color(0xFF627EEA),
          ),
          _buildCryptoTile(
             context,
             name: 'Solana (SOL)',
             symbol: 'SOL',
             address: _solAddress,
             icon: FontAwesomeIcons.coins, // Fallback/Generic if solana not found in version, but FontAwesome usually has it or use generic
             color: const Color(0xFF14F195), 
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildCryptoTile(
    BuildContext context, {
    required String name,
    required String symbol,
    required String address,
    required IconData icon,
    required Color color,
  }) {
    // Truncate address for display: 0xb1...505d
    final displayAddress = address.length > 12 
        ? '${address.substring(0, 6)}...${address.substring(address.length - 4)}'
        : address;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
        title: Text(
          name,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        subtitle: Text(
          displayAddress,
          style: GoogleFonts.sourceCodePro(fontSize: 12.sp, color: Colors.grey[600]), // Monospace for address
        ),
        trailing: IconButton(
          icon: Icon(Icons.copy, color: Theme.of(context).primaryColor, size: 20.sp),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: address));
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('support.address_copied'.tr(args: [symbol]), style: GoogleFonts.cairo()),
                backgroundColor: Theme.of(context).primaryColor,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        onTap: () {
           Clipboard.setData(ClipboardData(text: address));
           HapticFeedback.lightImpact();
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('support.address_copied'.tr(args: [symbol]), style: GoogleFonts.cairo()),
                backgroundColor: Theme.of(context).primaryColor,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
        },
      ),
    );
  }
}
