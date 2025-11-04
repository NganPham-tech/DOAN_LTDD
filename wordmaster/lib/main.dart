// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'l10n/app_localizations.dart';

import 'firebase_options.dart';
import 'providers/simple_firebase_user_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/auth_wrapper.dart';
import 'services/tts_service.dart';
import 'controllers/auth_controller.dart';
import 'controllers/progress_controller.dart';
import 'controllers/flashcard_overview_controller.dart';
import 'controllers/quiz_controller.dart';
import 'controllers/main_navigation_controller.dart';
import 'controllers/home_controller.dart';
/// wordmaster/lib/main.dart
/// 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Warning: Could not load .env file: $e');
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await TtsService.initialize();

  // Đăng ký providers trong GetX
  Get.put(SimpleFirebaseUserProvider(), permanent: true);
  Get.put(SettingsProvider(), permanent: true);
  Get.put(QuizProvider(), permanent: true);
  Get.put(LocaleProvider(), permanent: true);
  Get.put(MainNavigationController(), permanent: true);
  // Đăng ký AuthController
  Get.put(AuthController(), permanent: true);
  Get.put(ProgressController(), permanent: true);
  Get.put(FlashcardOverviewController(), permanent: true);
  Get.put(QuizController(), permanent: true);
  Get.put(HomeController());
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SimpleFirebaseUserProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => SettingsProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => QuizProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => LocaleProvider(), lazy: false),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return GetMaterialApp(
            title: 'WordMaster',
            debugShowCheckedModeBanner: false,
            
         
            locale: localeProvider.locale,
            
        
            supportedLocales: LocaleProvider.supportedLocales,
            
           
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
          
            localeResolutionCallback: (locale, supportedLocales) {
              
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
            
              return supportedLocales.first;
            },
         
            theme: ThemeData(
              primaryColor: const Color(0xFFd63384),
              primaryColorDark: const Color(0xFFa61e4d),
              primaryColorLight: const Color(0xFFf06595),
              secondaryHeaderColor: const Color(0xFFfff0f6),
              scaffoldBackgroundColor: const Color(0xFFfff0f6),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: const Color(0xFFae3ec9),
              ),
              fontFamily: 'Inter',
              visualDensity: VisualDensity.adaptivePlatformDensity,
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Color(0xFF2D3436),
              ),
            ),
            
            home: const AuthWrapper(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
            },
          );
        },
      ),
    );
  }
}
