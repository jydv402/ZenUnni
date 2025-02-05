// lib/services/ai_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';

class AIService {
  final ChatGoogleGenerativeAI llm;

  AIService() : llm = ChatGoogleGenerativeAI(apiKey: dotenv.env['KEY']!);

  Future<String> getMotivationalMessage(String mood) async {
    const systemPrompt = '''
    You are ZenUnni, a motivational assistant. 
    Provide positive, fun, and encouraging messages 
    (under 350 words) based on the user's mood. 
    Include quotes, advice, and affirmations. 
    Guide the user on taking action to improve their mood.
    ''';

    final userPrompt =
        'The user is feeling $mood. Provide a motivational message or advice.';

    final prompt = PromptTemplate(
      inputVariables: const {'mood'},
      template: '$systemPrompt\n\n$userPrompt',
    );

    final chain = LLMChain(llm: llm, prompt: prompt);
    final response = await chain.run(mood);
    return response;
  }

  Future<String> chat(String message) async {
    return '';
  }
}
