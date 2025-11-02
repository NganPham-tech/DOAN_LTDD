// lib/screens/dictation/dictation_play_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dictation_play_controller.dart';
import '../../models/dictation.dart';
import 'dictation_result_screen.dart';
import '../../services/tts_service.dart';
class DictationPlayScreen extends StatelessWidget {
  final DictationLesson lesson;

  const DictationPlayScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DictationPlayController(lesson));
    
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(lesson.title),
          backgroundColor: const Color(0xFFd63384),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(controller.showTranscript.value ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                controller.showTranscript.toggle();
              },
              tooltip: controller.showTranscript.value ? 'Ẩn script' : 'Xem script',
            ),
          ],
        ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Card
                _buildInfoCard(controller),
                const SizedBox(height: 16),
                
                // Speed Control
                _buildSpeedControl(controller),
                const SizedBox(height: 16),
                
                // Play Mode Toggle
                _buildPlayModeToggle(controller),
                const SizedBox(height: 16),
                
                // Audio Controls
                Builder(builder: (context) {
                  print('🎛️ Building audio controls: isSegmentMode=${controller.isSegmentMode.value}');
                  return !controller.isSegmentMode.value 
                    ? _buildFullAudioControls(controller) 
                    : _buildSegmentControls(controller);
                }),
                const SizedBox(height: 24),
                
                // Transcript (if shown)
                if (controller.showTranscript.value) _buildTranscriptCard(controller),
                const SizedBox(height: 24),
                
                // Input Area
                _buildInputArea(controller),
                const SizedBox(height: 24),
                
                // Submit Button
                _buildSubmitButton(controller),
              ],
            ),
          ),
        );
    });
  }
  
  Widget _buildInfoCard(DictationPlayController controller) {
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
                  lesson.levelText,
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
                '${lesson.durationSeconds}s',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            lesson.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatChip(Icons.text_fields, '${lesson.totalWords} từ'),
              const SizedBox(width: 8),
              _buildStatChip(Icons.format_list_numbered, '${lesson.segments.length} câu'),
              const SizedBox(width: 8),
              _buildStatChip(Icons.replay, '${controller.playCount.value} lần nghe'),
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
  
  Widget _buildSpeedControl(DictationPlayController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tốc độ đọc',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.speed, size: 20, color: Color(0xFFd63384)),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: controller.speechRate.value,
                    min: 0.3,
                    max: 1.0,
                    divisions: 7,
                    label: controller.getSpeedLabel(controller.speechRate.value),
                    activeColor: const Color(0xFFd63384),
                    onChanged: (value) async {
                      controller.speechRate.value = value;
                      await TtsService.setSpeechRate(value);
                    },
                  ),
                ),
                Text(
                  controller.getSpeedLabel(controller.speechRate.value),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPlayModeToggle(DictationPlayController controller) {
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
              isSelected: !controller.isSegmentMode.value,
              onTap: () {
                print('🔄 Setting segment mode to false');
                controller.isSegmentMode.value = false;
              },
            ),
          ),
          Expanded(
            child: _buildModeButton(
              label: 'Từng câu',
              icon: Icons.skip_next,
              isSelected: controller.isSegmentMode.value,
              onTap: () {
                print('🔄 Setting segment mode to true');
                controller.isSegmentMode.value = true;
              },
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
  
  Widget _buildFullAudioControls(DictationPlayController controller) {
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
              onPressed: controller.isPlaying.value ? null : () => controller.playFullAudio(),
              icon: Icon(controller.isPlaying.value ? Icons.volume_up : Icons.play_arrow),
              label: Text(controller.isPlaying.value ? 'Đang phát...' : 'Phát toàn bộ'),
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
  
  Widget _buildSegmentControls(DictationPlayController controller) {
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
            ...lesson.segments.asMap().entries.map((entry) {
              final index = entry.key;
              final segment = entry.value;
              final isPlaying = controller.isPlaying.value && controller.currentSegmentIndex.value == index;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: controller.isPlaying.value ? null : () => controller.playSegment(index),
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
  
  Widget _buildTranscriptCard(DictationPlayController controller) {
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
                  onPressed: () {
                    controller.showTranscript.value = false;
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              lesson.fullTranscript,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInputArea(DictationPlayController controller) {
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
              controller: controller.textController,
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
              '${controller.textController.text.split(' ').where((w) => w.isNotEmpty).length} từ',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSubmitButton(DictationPlayController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => controller.submitAnswer(),
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
}