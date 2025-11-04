import '../services/api_service.dart';
import '../models/quiz_topic.dart';

class QuizAPI {
  
  static Future<List<QuizTopic>> getTopics() async {
    final response = await ApiService.get('/quiz/topics');
    if (response['success'] == true) {
      List<dynamic> data = response['data'];
      return data.map((json) => QuizTopic.fromMap(json)).toList();
    }
    return [];
  }

  
  static Future<List<QuizQuestion>> getQuestions(int topicId) async {
    final response = await ApiService.get('/quiz/questions?topicId=$topicId');
    if (response['success'] == true) {
      List<dynamic> data = response['data'];
      return data.map((json) => QuizQuestion.fromMap(json)).toList();
    }
    return [];
  }
}
