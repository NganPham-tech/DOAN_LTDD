import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../flashcard/flashcard_overview_screen.dart';
import '../dictation/dictation_list_screen.dart';
import '/providers/simple_firebase_user_provider.dart';
import '/services/api_service.dart';

//D:\DEMOLTDD\wordmaster\lib\screens\home\home_screen.dart

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  
  Map<String, dynamic> _userProgress = {
    'todayLearned': 0,
    'dailyGoal': 20,
    'currentStreak': 0,
    'totalPoints': 0,
    'progressPercentage': 0,
  };

  List<Map<String, dynamic>> _recommendedDecks = [];
  List<Map<String, dynamic>> _recentActivities = [];
  Map<String, dynamic> _statistics = {
    'cardsToReview': 0,
    'todayLearned': 0,
  };
  
  // 🆕 THÊM BIẾN CHO FLASHCARD OF THE DAY
  Map<String, dynamic> _todayFlashcard = {};

  final List<Map<String, dynamic>> _quickActions = [
    {'icon': Icons.flash_on, 'label': 'Flashcard', 'badge': 0},
    {'icon': Icons.repeat, 'label': 'Ôn tập', 'badge': 5},
    {'icon': Icons.quiz, 'label': 'Quiz', 'badge': 0},
    {'icon': Icons.mic, 'label': 'Dictation', 'badge': 0},
    {'icon': Icons.record_voice_over, 'label': 'Shadowing', 'badge': 0},
    {'icon': Icons.menu_book, 'label': 'Grammar', 'badge': 2},
  ];



  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<SimpleFirebaseUserProvider>(
        context,
        listen: false,
      );

      if (!userProvider.isLoggedIn) {
        setState(() => _isLoading = false);
        return;
      }

      final firebaseUid = userProvider.currentUser?.id;
      
      // Sử dụng ApiService với userId=2 cho dữ liệu người dùng
      final data = await ApiService.get('/users/home?firebaseUid=$firebaseUid');
      
      print('Home API response: Success');

      if (data['success'] == true) {
        setState(() {
          _userProgress = Map<String, dynamic>.from(
            data['data']['userProgress'] ?? {}
          );
          _recommendedDecks = List<Map<String, dynamic>>.from(
            data['data']['recommendedDecks'] ?? []
          );
          _recentActivities = List<Map<String, dynamic>>.from(
            data['data']['recentActivities'] ?? []
          );
          _statistics = Map<String, dynamic>.from(
            data['data']['statistics'] ?? {}
          );
          // 🆕 PARSE FLASHCARD OF THE DAY
          _todayFlashcard = Map<String, dynamic>.from(
            data['data']['todayFlashcard'] ?? {}
          );
          _isLoading = false;
        });
        print('Home data loaded successfully');
      }
    } catch (e) {
      print('Error loading home data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFd63384),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFd63384),
          onRefresh: _loadHomeData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildHeader(),
                const SizedBox(height: 16),
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildProgressCard(),
                const SizedBox(height: 24),
                
                // 🆕 FLASHCARD OF THE DAY
                if (_todayFlashcard.isNotEmpty) ...[
                  _buildFlashcardOfTheDay(),
                  const SizedBox(height: 24),
                ],
                
                _buildQuickActions(),
                const SizedBox(height: 32),
                _buildRecommendedSection(),
                const SizedBox(height: 32),
                _buildRecentActivity(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Row(
          children: [
            Image.asset(
              'images/Bannerapp.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WordMaster',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFd63384),
                  ),
                ),
                Text(
                  'Học từ vựng dễ — Nhớ lâu hơn mỗi ngày',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              icon: Badge(
                label: Text('${_statistics['cardsToReview'] ?? 0}'),
                isLabelVisible: (_statistics['cardsToReview'] ?? 0) > 0,
                child: Icon(Icons.notifications, color: Colors.grey[600]),
              ),
              onPressed: () {},
            ),
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFd63384),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm từ, chủ đề hoặc bài học...',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    final todayLearned = _userProgress['todayLearned'] ?? 0;
    final dailyGoal = _userProgress['dailyGoal'] ?? 20;
    final progress = dailyGoal > 0 ? todayLearned / dailyGoal : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFd63384), Color(0xFFa61e4d)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFd63384).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiến độ hôm nay',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$todayLearned/$dailyGoal từ',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Streak: ${_userProgress['currentStreak'] ?? 0} ngày',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FlashcardOverviewScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFd63384),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Ôn tập ngay',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🆕 FLASHCARD OF THE DAY WIDGET
  Widget _buildFlashcardOfTheDay() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFfff9fb), Color(0xFFfff0f5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFd63384).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFd63384).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.wb_sunny_rounded,
                  color: Color(0xFFd63384),
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Từ vựng hôm nay',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFd63384).withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _todayFlashcard['question'] ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                if (_todayFlashcard['phonetic'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _todayFlashcard['phonetic'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf8f9fa),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _todayFlashcard['answer'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (_todayFlashcard['example'] != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Ví dụ:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _todayFlashcard['example'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FlashcardOverviewScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: Text(
                      'Học từ deck "${_todayFlashcard['deckName'] ?? 'Unknown'}"',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFd63384),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    // Cập nhật badge từ statistics
    _quickActions[1]['badge'] = _statistics['cardsToReview'] ?? 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Học nhanh',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: _quickActions.length,
          itemBuilder: (context, index) {
            final action = _quickActions[index];
            return _buildActionTile(
              icon: action['icon'] as IconData,
              label: action['label'] as String,
              badge: action['badge'] as int,
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required int badge,
  }) {
    return GestureDetector(
      onTap: () => _handleFeatureNavigation(label),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Badge(
              isLabelVisible: badge > 0,
              label: Text(badge.toString()),
              child: Icon(icon, size: 28, color: const Color(0xFFd63384)),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFeatureNavigation(String feature) {
    switch (feature) {
      case 'Flashcard':
      case 'Ôn tập':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FlashcardOverviewScreen()),
        );
        break;
      case 'Dictation':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DictationListScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tính năng $feature đang phát triển'),
            backgroundColor: const Color(0xFFd63384),
          ),
        );
    }
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gợi ý cho bạn',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _recommendedDecks.isEmpty
            ? Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Chưa có deck gợi ý',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            : SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recommendedDecks.length,
                  itemBuilder: (context, index) {
                    return _buildDeckCard(_recommendedDecks[index]);
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildDeckCard(Map<String, dynamic> deck) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: deck['thumbnail'] != null
                ? Image.network(
                    deck['thumbnail'],
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 80,
                      color: const Color(0xFFf8f9fa),
                      child: const Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                  )
                : Container(
                    height: 80,
                    color: const Color(0xFFf8f9fa),
                    child: const Icon(Icons.menu_book, size: 40, color: Color(0xFFd63384)),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deck['title'] ?? 'Unknown Deck',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${deck['cardsCount'] ?? 0} thẻ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hoạt động gần đây',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _recentActivities.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Chưa có hoạt động nào',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
              : Column(
                  children: _recentActivities
                      .map((activity) => _buildActivityItem(
                            activity['activity'] ?? '',
                            activity['timeAgo'] ?? '',
                            activity['icon'] ?? 'book',
                          ))
                      .toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String activity, String timeAgo, String iconType) {
    IconData icon;
    Color iconColor;

    switch (iconType) {
      case 'quiz':
        icon = Icons.quiz;
        iconColor = const Color(0xFFae3ec9);
        break;
      case 'repeat':
        icon = Icons.repeat;
        iconColor = const Color(0xFFf06595);
        break;
      default:
        icon = Icons.check_circle;
        iconColor = const Color(0xFFd63384);
    }

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        activity,
        style: const TextStyle(fontSize: 14),
      ),
      trailing: Text(
        timeAgo,
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
    );
  }
}