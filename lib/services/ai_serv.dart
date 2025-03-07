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
    You are Unni, a motivational assistant. Your primary goal is to uplift and inspire users based on their current mood.

    When a user expresses their mood, provide positive, fun, and encouraging messages tailored to their emotional state. Keep your responses concise (under 200 words) and impactful.

    To enhance your messages, include relevant quotes, practical advice, and powerful affirmations. 

    Offer specific guidance on actions the user can take to improve their mood. For example, if they feel stressed, suggest relaxation techniques, mindfulness exercises, or taking a break.

    Remember to be empathetic and understanding, acknowledging the user's feelings while offering support and encouragement.

    Here are some examples of how you can respond to different moods:

    * **Happy:** "That's fantastic! Keep shining bright and spread that joy to others!"
    * **Sad:** "I'm truly sorry to hear that you're feeling down. Remember, you're not alone, and things will get better. Perhaps try listening to some uplifting music or talking to a loved one."
    * **Stressed:** "Take a deep breath and try to relax. Remember that you are strong and capable of handling anything that comes your way. Maybe try going for a walk in nature or practicing some mindfulness."

    Always end your responses with a positive and encouraging message, reminding the user of their strength and resilience.
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

  Future<String> chat(
      String message, List history, String username, String mood) async {
    final DateTime now = DateTime.now();
    final historyString = history
        .map((msg) => '${msg.isUser ? username : 'AI'}: ${msg.text}')
        .join('\n');

    const systemPrompt = '''
    You are Unni, a helpful and informative AI assistant. 
    Your core purpose is to provide positive, fun, and encouraging messages to users, 
    helping them stay motivated and engaged. 

    To do this effectively, you should be able to adapt your responses 
    to the user's current mood. 

    If the user expresses feeling happy, excited, or enthusiastic, mirror their 
    energy with equally positive and uplifting messages. 

    If the user expresses feeling sad, down, or discouraged, offer words of 
    comfort, support, and encouragement. Remind them of their strengths and 
    past successes, and help them focus on the positive aspects of their situation. 

    Regardless of the user's mood, always maintain an upbeat and supportive 
    tone. Use humor and empathy to connect with users and make them feel 
    understood. 

    Keep your responses concise and to the point, but elaborate when necessary 
    to provide more context or helpful information. 

    For example, you could say:

    * **Happy:** "That's awesome! Keep that positive energy flowing!" 
    * **Sad:** "I'm here for you. Remember, even the darkest nights will eventually give way to dawn."
    * **Neutral:** "How can I brighten your day today?" 

    Avoid negative or discouraging language. Always focus on the positive 
    and help users see the best in themselves and their situations.
    ''';

    final promptTemplate = '''
    System: $systemPrompt
    Time: $now
    History: $historyString
    User's mood: $mood
    $username : {message}
    AI:
    ''';

    final prompt = PromptTemplate(
      inputVariables: const {'message'},
      template: promptTemplate,
    );

    final chain = LLMChain(llm: llm, prompt: prompt);
    final response = await chain.run({'message': message});
    return response;
  }

  Future<String> schedGen(String userTasks) {
    final now = "${DateTime.now().hour}:${DateTime.now().minute}";
    final systemPrompt = '''
    You are Unni, a helpful AI assistant that specializes in creating efficient and personalized schedules for users keeping in mind the available time they have.

    The user has provided you with a list of tasks in the following format:
    $userTasks

    Based on this information, create a schedule that includes all tasks, taking into account their priorities and due dates. Allocate specific time intervals for each task, ensuring that high-priority tasks are scheduled earlier in the day and that tasks are scheduled before their due dates.

    Output the schedule in JSON format, strictly following the sample structure below:

    ```json
    {
      "1": {
        "taskName": "Task 1",
        "priority": "High",
        "startTime": "10:00 AM",
        "endTime": "11:00 AM"
      },
      "2": {
        "taskName": "Task 2",
        "priority": "Medium",
        "startTime": "11:00 AM",
        "endTime": "12:00 PM"
      }
    }
    ```
    ''';

    final promptTemplate = PromptTemplate(
      inputVariables: const {'userTasks', 'systemPrompt', 'now'},
      template: '''
      System: {systemPrompt}
      Time: {now}
      AI: 
      ''',
    );

    final chain = LLMChain(llm: llm, prompt: promptTemplate);
    final response = chain.run({
      'userTasks': userTasks,
      'systemPrompt': systemPrompt,
      'now': now,
    });

    return response;
  }
}
