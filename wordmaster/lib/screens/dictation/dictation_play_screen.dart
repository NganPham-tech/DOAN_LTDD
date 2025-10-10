// lib/screens/dictation/dictation_play_screen.dart
import 'package:flutter/material.dart';
import '../../models/dictation.dart';
import '../../services/tts_services.dart';
import '../../services/dictation_scoring_service.dart';
import 'dictation_result_screen.dart';

class DictationPlayScreen extends StatefulWidget {
  final DictationLesson lesson;

  const DictationPlayScreen({super.key, required this.lesson});

  @override
  State<DictationPlayScreen> createState() => _DictationPlayScreenState();
}

class _DictationPlayScreenState extends State<DictationPlayScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isPlaying = false;
  bool _showTranscript = false;
  int _playCount = 0;
  int _currentSegmentIndex = 0;
  bool _isSegmentMode = false;
  DateTime? _startTime;
  
  @override
  void initState() {
    super.initState();
    TtsService.initialize();
    _startTime = DateTime.now();
  }
  
  Future<void> _playFullAudio() async {
    if (_isPlaying) return;
    
    setState(() {
      _isPlaying = true;
      _playCount++;
    });
    
    await TtsService.speak(widget.lesson.fullTranscript);
    
    setState(() {
      _isPlaying = false;
    });
  }
  
  Future<void> _playSegment(int index) async {
    if (_isPlaying || index >= widget.lesson.segments.length) return;
    
    setState(() {
      _isPlaying = true;
      _currentSegmentIndex = index;
    });
    
    final segment = widget.lesson.segments[index];
    await TtsService.speak(segment.text);
    
    setState(() {
      _isPlaying = false;
    });
  }
  
  void _toggleTranscript() {
    setState(() {
      _showTranscript = !_showTranscript;
    });
  }
  
  void _submitAnswer() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập câu trả lời')),
      );
      return;
    }
    
    final timeSpent = DateTime.now().difference(_startTime!).inSeconds;
    
    final result = DictationScoringService.scoreText(
      lessonId: widget.lesson.id,
      userInput: _textController.text,
      correctText: widget.lesson.fullTranscript,
      timeSpentSeconds: timeSpent,
    );
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DictationResultScreen(result: result),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.lesson.title),
        backgroundColor: const Color(0xFFd63384),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showTranscript ? Icons.visibility_off : Icons.visibility),
            onPressed: _toggleTranscript,
            tooltip: _showTranscript ? 'Ẩn script' : 'Xem script',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            _buildInfoCard(),
            const SizedBox(height: 24),
            
            // Play Mode Toggle
            _buildPlayModeToggle(),
            const SizedBox(height: 16),
            
            // Audio Controls
            if (!_isSegmentMode) _buildFullAudioControls() else _buildSegmentControls(),
            const SizedBox(height: 24),
            
            // Transcript (if shown)
            if (_showTranscript) _buildTranscriptCard(),
            const SizedBox(height: 24),
            
            // Input Area
            _buildInputArea(),
            const SizedBox(height: 24),
            
            // Submit Button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFd63384), Color(0xFFa61e4d)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.lesson.levelText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.access_time, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                '${widget.lesson.durationSeconds}s',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.lesson.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatChip(Icons.text_fields, '${widget.lesson.totalWords} từ'),
              const SizedBox(width: 8),
              _buildStatChip(Icons.format_list_numbered, '${widget.lesson.segments.length} câu'),
              const SizedBox(width: 8),
              _buildStatChip(Icons.replay, '$_playCount lần nghe'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPlayModeToggle() {
    return Container(
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
      child: Row(
        children: [
          Expanded(
            child: _buildModeButton(
              label: 'Toàn bộ',
              icon: Icons.play_circle_outline,
              isSelected: !_isSegmentMode,
              onTap: () => setState(() => _isSegmentMode = false),
            ),
          ),
          Expanded(
            child: _buildModeButton(
              label: 'Từng câu',
              icon: Icons.skip_next,
              isSelected: _isSegmentMode,
              onTap: () => setState(() => _isSegmentMode = true),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildModeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFd63384) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFullAudioControls() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Nhấn nút để nghe',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isPlaying ? null : _playFullAudio,
              icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
              label: Text(_isPlaying ? 'Đang phát...' : 'Phát toàn bộ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFd63384),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSegmentControls() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chọn câu để nghe',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...widget.lesson.segments.asMap().entries.map((entry) {
              final index = entry.key;
              final segment = entry.value;
              final isPlaying = _isPlaying && _currentSegmentIndex == index;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: _isPlaying ? null : () => _playSegment(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPlaying ? Colors.orange : Colors.white,
                    foregroundColor: isPlaying ? Colors.white : Colors.black87,
                    elevation: 1,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPlaying ? Icons.volume_up : Icons.play_arrow,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Câu ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        '${segment.wordCount} từ',
                        style: TextStyle(
                          fontSize: 12,
                          color: isPlaying ? Colors.white70 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTranscriptCard() {
    return Card(
      elevation: 2,
      color: Colors.yellow[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Script gốc',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: _toggleTranscript,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.lesson.fullTranscript,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInputArea() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nhập những gì bạn nghe được',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _textController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Gõ văn bản ở đây...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFd63384), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${_textController.text.split(' ').where((w) => w.isNotEmpty).length} từ',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _submitAnswer,
        icon: const Icon(Icons.check_circle),
        label: const Text('Nộp bài'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _textController.dispose();
    TtsService.stop();
    super.dispose();
  }
}