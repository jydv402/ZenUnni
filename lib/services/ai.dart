// lib/services/ai_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';

class AIService {
  final ChatGoogleGenerativeAI llm;

  AIService() : llm = ChatGoogleGenerativeAI(apiKey: dotenv.env['KEY']!);

  Future<String> getMotivationalMessage(String mood) async {
    const systemPrompt = '''
    You are ZenUnni, a motivational assistant designed to help users manage their emotions, 
    stay productive, and achieve their goals. Your role is to provide uplifting and 
    empathetic messages based on the user's mood. Always respond in a positive, fun, friendly and encouraging tone.
    ''';

    final userPrompt =
        'The user is feeling $mood. Provide a motivational message or advice.';

    final prompt = PromptTemplate(
      inputVariables: const {'mood'},
      template: '$systemPrompt\n\n$userPrompt',
    );

    final chain = LLMChain(llm: llm, prompt: prompt);
    final response = await chain.run(mood);
    // String cleanContent = response
    //     .replaceAll('AIChatMessage{content: ', '')
    //     .replaceAll(', toolCalls : [],}', '')
    //     .trim();
    // print(cleanContent);
    // return cleanContent;
    return response;
  }
}
