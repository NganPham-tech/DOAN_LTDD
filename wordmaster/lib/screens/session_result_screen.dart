import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../models/study_session.dart';

class SessionResultScreen extends StatelessWidget {
  final Deck deck;
  final int totalCards;
  final int rememberedCount;
  final int studyDuration;

  const SessionResultScreen({
    super.key,
    required this.deck,
    required this.totalCards,
    required this.rememberedCount,
    required this.studyDuration,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = (rememberedCount / totalCards) * 100;
    String message = '';
    Color messageColor = Colors.green;

    if (percentage >= 80) {
      message = 'Xuất sắc! 🎉';
    } else if (percentage >= 60) {
      message = 'Tốt lắm! 👍';
    } else if (percentage >= 40) {
      message = 'Cố gắng hơn nhé! 💪';
    } else {
      message = 'Đừng nản chí! 🌟';
      messageColor = Colors.orange;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả học tập')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: messageColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Bạn đã hoàn thành bộ thẻ "${deck.name}"',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            // Progress Circle
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Text(
                  '${percentage.toInt()}%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Stats
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildStatRow('Tổng số thẻ:', '$totalCards thẻ'),
                    _buildStatRow('Đã nhớ:', '$rememberedCount thẻ'),
                    _buildStatRow('Thời gian:', '${studyDuration ~/ 60} phút'),
                    _buildStatRow(
                      'Lần ôn tiếp theo:',
                      'Ngày mai',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text('Về trang chủ'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Học lại'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}