import 'package:flutter/material.dart';
import '../models/home_models.dart';
import './deck_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8f9fa),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header với logo và slogan
              _buildHeader(context),
              
              // Banner học tập
              _buildLearningBanner(context),
              
              // Thống kê nhanh
              _buildQuickStats(context),
              
              // Navigation Cards chính
              _buildMainNavigation(context),
              
              // Deck được gợi ý
              _buildSuggestedDecks(context),
              
              // Bộ thẻ yêu thích
              _buildFavoriteDecks(context),
              
              // Footer
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFd63384),
            const Color(0xFFae3ec9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Logo
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '📚',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WordMaster',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Học từ vựng thông minh',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Avatar user
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Text(
                  'A',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Flashcard & Spaced Repetition',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFd63384).withOpacity(0.1),
            const Color(0xFFae3ec9).withOpacity(0.1),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFd63384).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bắt đầu học ngay hôm nay!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Học 10 phút mỗi ngày để cải thiện vốn từ vựng',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            'images/Bannerapp.png', // Thay bằng ảnh của bạn
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final UserProgress progress = UserProgress(
      totalLearned: 245,
      currentStreak: 7,
      bestStreak: 15,
      points: 1250,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('📚', '${progress.totalLearned}', 'Từ đã học'),
          _buildStatItem('🔥', '${progress.currentStreak}', 'Streak'),
          _buildStatItem('⭐', '${progress.points}', 'Điểm'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFd63384),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildMainNavigation(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Học tập',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildNavigationCard(
                context,
                'Flashcard',
                'Học từ vựng với thẻ ghi nhớ',
                Icons.flash_on,
                const Color(0xFFd63384),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeckListScreen()),
                ),
              ),
              _buildNavigationCard(
                context,
                'Quiz',
                'Kiểm tra kiến thức',
                Icons.quiz,
                const Color(0xFF28a745),
                () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tính năng Quiz đang phát triển')),
                ),
              ),
              _buildNavigationCard(
                context,
                'Tiến độ',
                'Xem kết quả học tập',
                Icons.timeline,
                const Color(0xFF17a2b8),
                () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tính năng Tiến độ đang phát triển')),
                ),
              ),
              _buildNavigationCard(
                context,
                'Từ điển',
                'Tra cứu từ vựng',
                Icons.book,
                const Color(0xFF6f42c1),
                () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tính năng Từ điển đang phát triển')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedDecks(BuildContext context) {
    final List<FeaturedDeck> decks = [
      FeaturedDeck(
        deckID: 1,
        name: 'Giao tiếp cơ bản',
        description: '500 từ vựng giao tiếp hàng ngày',
        icon: '💬',
        cardCount: 500,
        isFavorite: true,
      ),
      FeaturedDeck(
        deckID: 2,
        name: 'TOEIC Essential',
        description: 'Từ vựng cần thiết cho TOEIC',
        icon: '📝',
        cardCount: 800,
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Được đề xuất',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: decks.length,
              itemBuilder: (context, index) {
                return _buildDeckCard(context, decks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteDecks(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Yêu thích',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeckListScreen()),
                ),
                child: const Text('Xem tất cả'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Chưa có bộ thẻ yêu thích nào',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeckCard(BuildContext context, FeaturedDeck deck) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  deck.icon,
                  style: const TextStyle(fontSize: 24),
                ),
                const Spacer(),
                if (deck.isFavorite)
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 16,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              deck.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              deck.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '${deck.cardCount} thẻ',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'WordMaster v1.0',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Học từ vựng thông minh với công nghệ lặp lại ngắt quãng',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}