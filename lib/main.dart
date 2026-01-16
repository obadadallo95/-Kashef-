import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/logger_service.dart';
import 'core/services/preferences_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/controllers/app_lock_controller.dart';
import 'features/auth/presentation/screens/lock_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/settings/presentation/screens/info_screen.dart'; // Keep if needed elsewhere, otherwise maybe remove
import 'features/settings/presentation/screens/about_screen.dart';
import 'features/settings/presentation/screens/privacy_screen.dart';
import 'features/settings/presentation/screens/terms_screen.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(); // Load environment variables
  
  // lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  final logger = ConsoleLogger();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: ProviderScope(
        observers: [
          RiverpodLogger(logger),
        ],
        overrides: [
          // Override PreferencesService with initialized instance
          preferencesServiceProvider.overrideWithValue(PreferencesService(prefs, logger)),
        ],
        child: const MainApp(),
      ),
    ),
  );
}

// GoRouter provider to watch auth state
final routerProvider = Provider<GoRouter>((ref) {
  final appLockState = ref.watch(appLockControllerProvider);
  final preferences = ref.watch(preferencesServiceProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // 1. Check Onboarding
      final hasSeenOnboarding = preferences.hasSeenOnboarding;
      if (!hasSeenOnboarding) {
        return '/onboarding';
      }

      // 2. Check App Lock
      // If locked and not already on lock screen
      if (appLockState.isLocked && state.matchedLocation != '/lock') {
         return '/lock';
      }

      // If unlocked and on lock screen, go home (or back to where they were)
      if (!appLockState.isLocked && state.matchedLocation == '/lock') {
        return '/';
      }
      
      // Prevent manual navigation to onboarding if seen
      if (hasSeenOnboarding && state.matchedLocation == '/onboarding') {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'privacy',
            builder: (context, state) => const PrivacyScreen(),
          ),
          GoRoute(
            path: 'terms',
            builder: (context, state) => const TermsScreen(),
          ),
          GoRoute(
            path: 'about',
            builder: (context, state) => const AboutScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/lock',
        builder: (context, state) => const LockScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
    ],
  );
});

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final router = ref.watch(routerProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          // Global Keyboard Dismissal
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MaterialApp.router(
            title: 'app_title'.tr(),
            debugShowCheckedModeBanner: false,
            
            // Theme Configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,

            // Router Configuration
            routerConfig: router,

            // Localization Configuration
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            
            builder: (context, widget) {
               return widget!;
            },
          ),
        );
      },
    );
  }
}
