// Web Build Fix Trigger
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kashef/features/home/presentation/screens/desktop_home_view.dart';
import 'package:kashef/features/home/presentation/widgets/scanner_widget.dart';
import 'package:kashef/features/settings/presentation/screens/settings_screen.dart';
import 'package:kashef/core/services/panic_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  
  @override
  void initState() {
    super.initState();
    // تفعيل وضع الطوارئ عند بدء الشاشة (للموبايل)
    ref.read(panicServiceProvider).startListening(context);
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
        // إذا كانت الشاشة عريضة (ويب/ديسكتوب)
        if (constraints.maxWidth > 900) {
          return const DesktopHomeView();
        } 
        
        // إذا كانت الشاشة صغيرة (موبايل) - نعيد التصميم القديم
        return Scaffold(
          appBar: AppBar(
            title: const Text('كاشف'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: const ScannerWidget(),
        );
      },
    );
  }
}