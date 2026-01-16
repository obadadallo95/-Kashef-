import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/developer_card.dart';
import '../widgets/process_flow_diagram.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'كاشف: درعك الرقمي',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.shield_outlined, size: 80.sp, color: Colors.white.withOpacity(0.2)),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionTitle(context, 'لماذا كاشف؟'),
                SizedBox(height: 12.h),
                _buildBodyText(
                  'في عالمنا الرقمي اليوم، أصبحت الكلمة سلاحاً ومسؤولية. يواجه السوريون يومياً تحديات هائلة في التعبير عن أنفسهم؛ فبين القوانين الصارمة وخوارزميات الحظر العشوائية، قد يؤدي بوست واحد إلى إغلاق حسابك أو تعريضك لمخاطر غير محسوبة.\n\n"كاشف" لم يأتِ لتقييدك، بل لحمايتك. نحن نؤمن بحقك في التعبير، ولكن بذكاء. باستخدام تقنيات الذكاء الاصطناعي المتقدمة، نقوم بفحص محتواك قبل نشره، لننبهك إلى الكلمات التي قد تكون "مصيدة" لك، ونقترح عليك بدائل أكثر أماناً توصل فكرتك دون أن تضحي بسلامتك.'
                ),
                SizedBox(height: 32.h),
                
                _buildSectionTitle(context, 'تقنياتنا للحماية'),
                _buildSectionTitle(context, 'تقنياتنا للحماية'),
                SizedBox(height: 16.h),
                const ProcessFlowDiagram(), // Animated Diagram
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTechItem(context, Icons.memory, 'AI محلي', 'لحجب المخاطر الجسيمة فوراً'),
                    _buildTechItem(context, Icons.security, 'سحابة آمنة', 'لتحليل السياق السياسي المعقد'),
                    _buildTechItem(context, Icons.visibility_off, 'خصوصية تامة', 'لا نحفظ أي سجلات'),
                  ],
                ),
                
                SizedBox(height: 48.h),
                SizedBox(height: 24.h),
                const DeveloperCard(),
                SizedBox(height: 24.h),
                Divider(),
                SizedBox(height: 24.h),
                
                Center(
                  child: Text(
                    'Made with ❤️ and 🛡️ for Syrians',
                    style: GoogleFonts.cairo(
                      color: Colors.grey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.cairo(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: GoogleFonts.cairo(
        fontSize: 16.sp,
        height: 1.8,
        color: Colors.grey[800],
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildTechItem(BuildContext context, IconData icon, String title, String subtitle) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 28.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: GoogleFonts.cairo(fontSize: 10.sp, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
