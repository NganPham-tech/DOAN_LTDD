// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'firebase_options.dart';
import 'providers/simple_firebase_user_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/flashcard/flashcard_overview_screen.dart';
import 'screens/progress/progress_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/quiz/quiz_topics_screen.dart';
import 'services/tts_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (with error handling)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Warning: Could not load .env file: $e');
  }

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Initialize TTS Service globally
  await TtsService.initialize();

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
          return MaterialApp(
            title: 'WordMaster',
            debugShowCheckedModeBanner: false,
            
            // ============================================
            // CẤU HÌNH ĐA NGÔN NGỮ
            // ============================================
            locale: localeProvider.locale,
            
            // Danh sách ngôn ngữ hỗ trợ
            supportedLocales: LocaleProvider.supportedLocales,
            
            // Localization delegates
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
            // Locale resolution callback
            localeResolutionCallback: (locale, supportedLocales) {
              // Kiểm tra xem locale hiện tại có được hỗ trợ không
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              // Nếu không hỗ trợ, trả về locale đầu tiên (mặc định)
              return supportedLocales.first;
            },
            
            // ============================================
            // THEME
            // ============================================
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
            
            home: const MainNavigation(),
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

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FlashcardOverviewScreen(),
    const QuizTopicsScreen(),
    const ProgressScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home), 
            label: l10n?.home ?? 'Trang chủ'
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.flash_on),
            label: l10n?.flashcards ?? 'Flashcard',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.quiz), 
            label: l10n?.quiz ?? 'Quiz'
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.timeline), 
            label: l10n?.progress ?? 'Tiến độ'
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person), 
            label: l10n?.profile ?? 'Hồ sơ'
          ),
        ],
      ),
    );
  }
}

// Placeholder screens
class FlashcardPlaceholderScreen extends StatelessWidget {
  const FlashcardPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Flashcard Screen\n(Đang phát triển)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class ProgressPlaceholderScreen extends StatelessWidget {
  const ProgressPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiến độ'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Progress Screen\n(Đang phát triển)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
