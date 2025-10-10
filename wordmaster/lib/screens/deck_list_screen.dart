import 'package:flutter/material.dart';
import '../../models/deck.dart';
import 'flashcard_list_screen.dart';

class DeckListScreen extends StatefulWidget {
  const DeckListScreen({super.key});

  @override
  _DeckListScreenState createState() => _DeckListScreenState();
}

class _DeckListScreenState extends State<DeckListScreen> {
  List<DeckCategory> categories = [];
  List<Deck> allDecks = [];
  List<Deck> filteredDecks = [];
  DeckCategory? selectedCategory;
  String searchQuery = '';
  bool showUserDecksOnly = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadDecks();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadCategories() {
    setState(() {
      categories = [
        DeckCategory(
          categoryID: 1,
          name: 'Tất cả',
          description: 'Tất cả chủ đề',
          icon: '📚',
        ),
        DeckCategory(
          categoryID: 2,
          name: 'Giao tiếp',
          description: 'Hội thoại hàng ngày',
          icon: '💬',
        ),
        DeckCategory(
          categoryID: 3,
          name: 'Du lịch',
          description: 'Từ vựng du lịch',
          icon: '✈️',
        ),
        DeckCategory(
          categoryID: 4,
          name: 'Công việc',
          description: 'Tiếng Anh công sở',
          icon: '💼',
        ),
        DeckCategory(
          categoryID: 5,
          name: 'Học thuật',
          description: 'Từ vựng học thuật',
          icon: '🎓',
        ),
        DeckCategory(
          categoryID: 6,
          name: 'TOEIC',
          description: 'Ôn thi TOEIC',
          icon: '📝',
        ),
      ];
      selectedCategory = categories[0];
    });
  }

  void _loadDecks() {
    setState(() {
      allDecks = [
        // Deck hệ thống
        Deck(
          deckID: 1,
          userID: 1,
          categoryID: 2,
          name: 'Giao tiếp cơ bản',
          description: '500 từ vựng giao tiếp hàng ngày',
          isPublic: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          cardCount: 500,
          learnedCount: 150,
          isFavorite: true,
          isUserCreated: false,
          authorName: 'Hệ thống',
        ),
        Deck(
          deckID: 2,
          userID: 1,
          categoryID: 3,
          name: 'Du lịch cơ bản',
          description: 'Từ vựng cho các tình huống du lịch',
          isPublic: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          cardCount: 300,
          learnedCount: 45,
          isFavorite: false,
          isUserCreated: false,
          authorName: 'Hệ thống',
        ),
        Deck(
          deckID: 3,
          userID: 1,
          categoryID: 4,
          name: 'Business English',
          description: 'Tiếng Anh thương mại và công sở',
          isPublic: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          cardCount: 450,
          learnedCount: 0,
          isFavorite: true,
          isUserCreated: false,
          authorName: 'Hệ thống',
        ),
        // Deck tự tạo
        Deck(
          deckID: 4,
          userID: 2,
          categoryID: 2,
          name: 'Từ vựng cá nhân',
          description: 'Bộ từ vựng tự tạo',
          isPublic: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          cardCount: 50,
          learnedCount: 25,
          isFavorite: false,
          isUserCreated: true,
          authorName: 'Bạn',
        ),
        Deck(
          deckID: 5,
          userID: 2,
          categoryID: 5,
          name: 'IELTS Advanced',
          description: 'Từ vựng IELTS band 7.0+',
          isPublic: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          cardCount: 600,
          learnedCount: 120,
          isFavorite: false,
          isUserCreated: true,
          authorName: 'Bạn',
        ),
      ];
      filteredDecks = allDecks;
    });
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text;
      _filterDecks();
    });
  }

  void _filterDecks() {
    List<Deck> filtered = allDecks;

    // Lọc theo category
    if (selectedCategory != null && selectedCategory!.categoryID != 1) {
      filtered = filtered
          .where((deck) => deck.categoryID == selectedCategory!.categoryID)
          .toList();
    }

    // Lọc theo tìm kiếm
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (deck) =>
                deck.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                (deck.description?.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ??
                    false),
          )
          .toList();
    }

    // Lọc chỉ deck của user
    if (showUserDecksOnly) {
      filtered = filtered.where((deck) => deck.isUserCreated).toList();
    }

    setState(() {
      filteredDecks = filtered;
    });
  }

  void _toggleFavorite(Deck deck) {
    setState(() {
      // Trong thực tế, gọi API để cập nhật FavoriteDeck
      final index = allDecks.indexWhere((d) => d.deckID == deck.deckID);
      if (index != -1) {
        allDecks[index] = deck.copyWith(isFavorite: !deck.isFavorite);
      }
      _filterDecks();
    });

    // Hiển thị thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          deck.isFavorite ? 'Đã xóa khỏi yêu thích' : 'Đã thêm vào yêu thích',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _createNewDeck() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildCreateDeckSheet(),
    );
  }

  Widget _buildCreateDeckSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tạo bộ thẻ mới',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Tên bộ thẻ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Chủ đề',
              border: OutlineInputBorder(),
            ),
            items: categories
                .where((cat) => cat.categoryID != 1)
                .map(
                  (category) => DropdownMenuItem(
                    value: category.categoryID,
                    child: Text(category.name),
                  ),
                )
                .toList(),
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Mô tả',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Xử lý tạo deck mới
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã tạo bộ thẻ mới')),
                    );
                  },
                  child: const Text('Tạo'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bộ thẻ Flashcard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewDeck,
            tooltip: 'Tạo bộ thẻ mới',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bộ thẻ...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          // Category Filter
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category.name),
                    selected:
                        selectedCategory?.categoryID == category.categoryID,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = selected ? category : categories[0];
                        _filterDecks();
                      });
                    },
                    avatar: Text(category.icon),
                  ),
                );
              }).toList(),
            ),
          ),
          // User Decks Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('Chỉ hiển thị bộ thẻ của tôi'),
                const Spacer(),
                Switch(
                  value: showUserDecksOnly,
                  onChanged: (value) {
                    setState(() {
                      showUserDecksOnly = value;
                      _filterDecks();
                    });
                  },
                ),
              ],
            ),
          ),
          // Deck Count
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Text(
                  '${filteredDecks.length} bộ thẻ',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Deck List
          Expanded(
            child: filteredDecks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredDecks.length,
                    itemBuilder: (context, index) {
                      final deck = filteredDecks[index];
                      return _buildDeckCard(deck);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeckCard(Deck deck) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getCategoryColor(deck.categoryID ?? 1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              _getCategoryIcon(deck.categoryID ?? 1),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                deck.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (deck.isUserCreated)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Của tôi',
                  style: TextStyle(fontSize: 10, color: Colors.blue),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(deck.description ?? 'Không có mô tả'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: deck.progress,
                    backgroundColor: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(deck.progressText, style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Tác giả: ${deck.authorName}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            deck.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: deck.isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: () => _toggleFavorite(deck),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlashcardListScreen(deck: deck),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder_open, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Không tìm thấy bộ thẻ nào',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty
                ? 'Thử tìm kiếm với từ khóa khác'
                : 'Hãy tạo bộ thẻ đầu tiên của bạn',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _createNewDeck,
            child: const Text('Tạo bộ thẻ mới'),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(int categoryID) {
    switch (categoryID) {
      case 2: // Giao tiếp
        return const Color(0xFFd63384);
      case 3: // Du lịch
        return const Color(0xFF28a745);
      case 4: // Công việc
        return const Color(0xFF17a2b8);
      case 5: // Học thuật
        return const Color(0xFF6f42c1);
      case 6: // TOEIC
        return const Color(0xFFfd7e14);
      default:
        return const Color(0xFF6c757d);
    }
  }

  String _getCategoryIcon(int categoryID) {
    switch (categoryID) {
      case 2: // Giao tiếp
        return '💬';
      case 3: // Du lịch
        return '✈️';
      case 4: // Công việc
        return '💼';
      case 5: // Học thuật
        return '🎓';
      case 6: // TOEIC
        return '📝';
      default:
        return '📚';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
