import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/deck_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordMaster',
      theme: ThemeData(
        primaryColor: const Color(0xFFd63384),
        primaryColorDark: const Color(0xFFa61e4d),
        primaryColorLight: const Color(0xFFf06595),
        secondaryHeaderColor: const Color(0xFFae3ec9),
        scaffoldBackgroundColor: const Color(0xFFfff0f6),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFae3ec9),
        ),
        fontFamily: 'Inter',
      ),
      home: const MainNavigation(),
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
    const DeckListScreen(),
    Container(), // Quiz Screen - để trống
    Container(), // Progress Screen - để trống
    Container(), // Profile Screen - để trống
  ];

  @override
  Widget build(BuildContext context) {
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'Flashcard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Tiến độ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}