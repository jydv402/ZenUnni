// lib/services/ai_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';

class AIService {
  final ChatGoogleGenerativeAI llm;
  final DateTime now = DateTime.now();

  AIService() : llm = ChatGoogleGenerativeAI(apiKey: dotenv.env['KEY']!);

  Future<String> getMotivationalMessage(String mood) async {
    const systemPrompt = '''
    You are Unni, a motivational assistant. 
    Provide positive, fun, and encouraging messages 
    (under 200 words) based on the user's mood.
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

    print(response);
    return response;
  }

  Future<String> chat(String message, List history, String username) async {
    final DateTime now = DateTime.now();
    final historyString = history
        .map((msg) => '${msg.isUser ? username : 'AI'}: ${msg.text}')
        .join('\n');

    const systemPrompt = '''
    You are Unni, a helpful and informative AI assistant.
    Provide positive, fun, and encouraging messages.
    Limit to concise responses, Longer if necessary.
    '''; // Define your system prompt here

    final promptTemplate = '''
    System: $systemPrompt
    Time: $now
    History: $historyString
    $username : {message}
    AI:
    ''';

    print(promptTemplate);

    final prompt = PromptTemplate(
      inputVariables: const {'message'},
      template: promptTemplate,
    );

    final chain = LLMChain(llm: llm, prompt: prompt);
    final response = await chain.run({'message': message});
    return response;
  }
}
