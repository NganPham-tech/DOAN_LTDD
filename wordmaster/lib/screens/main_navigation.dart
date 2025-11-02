import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'home/home_screen.dart';
import 'flashcard/flashcard_overview_screen.dart';
import 'quiz/quiz_topics_screen.dart';
import 'progress/progress_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    HomeScreen(),
    FlashcardOverviewScreen(),
    QuizTopicsScreen(),
    ProgressScreen(),
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