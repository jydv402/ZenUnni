// lib/services/ai_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';
import 'package:flutter/foundation.dart';

class AIService {
  Future<String> getMotivationalMessageIsolate(String mood) async {
    final result = await compute(_getMotivationalMessageWorker, {
      'mood': mood,
      'apiKey': dotenv.env['KEY']!,
    });
    return result;
  }

  Future<String> _getMotivationalMessageWorker(
      Map<String, dynamic> args) async {
    final mood = args['mood'] as String;
    final apiKey = args['apiKey'] as String;
    final llm = ChatGoogleGenerativeAI(apiKey: apiKey);

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

  Future<String> chatIsolate(
      String message, List history, String username, String mood) async {
    final result = await compute(_chatWorker, {
      'message': message,
      'history': history,
      'username': username,
      'mood': mood,
      'apiKey': dotenv.env['KEY']!,
    });
    return result;
  }

  Future<String> _chatWorker(Map<String, dynamic> args) async {
    final DateTime now = DateTime.now();
    final message = args['message'] as String;
    final username = args['username'] as String;
    final historyString = args['history']
        .map((msg) => '${msg.isUser ? username : 'AI'}: ${msg.text}')
        .join('\n');
    final mood = args['mood'] as String;
    final apiKey = args['apiKey'] as String;
    final llm = ChatGoogleGenerativeAI(apiKey: apiKey);
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

  Future<String> schedGenIsolate(String userTasks) async {
    final result = await compute(_schedGenWorker, {
      'userTasks': userTasks,
      'apiKey': dotenv.env['KEY']!,
    });
    return result;
  }

  Future<String> _schedGenWorker(Map<String, dynamic> args) async {
    final userTasks = args['userTasks'] as String;
    final apiKey = args['apiKey'] as String;
    final now = "${DateTime.now().hour}:${DateTime.now().minute}";

    final systemPrompt = '''
    You are Unni, a helpful AI assistant that specializes in creating efficient and personalized schedules for users based on their available time and the purpose of their tasks.

    The user has provided you with a list of tasks in the following format:
    $userTasks

    Based on this information, create a realistic and efficient schedule for the day that includes all tasks. Allocate specific time intervals for each task, ensuring that all tasks are scheduled before their due dates.

    **Prioritize Purpose:**
    * The purpose of a task is more important than its priority when scheduling.
    * For example, "Sleeping" should be scheduled during nighttime hours, "Eating" should be scheduled around typical meal times, and "Exercise" might be best scheduled in the morning or evening.

    **Handle Recurring Tasks:**
    * Split recurring tasks into multiple time slots throughout the day.
    * For example, "Drink water" should be scheduled multiple times a day, and "Take medication" should be scheduled according to its prescribed frequency.

    **Use Common Sense:**
    * Apply common sense and contextual awareness when scheduling tasks.
    * For example, "Go to the grocery store" shouldn't be scheduled in the middle of the night.

    **Output the schedule in JSON format, strictly following the JSON structure and fields below:**
    ```json
    {

      "1": {
        "taskName": "Go to the grocery store",
        "startTime": "2025-03-08 16:00:00.000",
        "endTime": "2025-03-08 16:30:00.000",
        "duration": 30
      },
      "2": {
        "taskName": "Go to the gym",
        "startTime": "2025-03-08 17:00:00.000",
        "endTime": "2025-03-08 19:30:00.000",
        "duration": 150
      },
      "3": {
        "taskName": "Drink water",
        "startTime": "2025-03-08 09:00:00.000",
        "endTime": "2025-03-08 09:15:00.000"
        "duration": 15
      },
      // ... other tasks
    }
    ''';

    final promptTemplate = PromptTemplate(
      inputVariables: const {'userTasks', 'systemPrompt', 'now'},
      template: '''
      System: {systemPrompt}
      Time: {now}
      AI: 
      ''',
    );

    final llm = ChatGoogleGenerativeAI(apiKey: apiKey);
    final chain = LLMChain(llm: llm, prompt: promptTemplate);
    final response = await chain.run({
      'userTasks': userTasks,
      'systemPrompt': systemPrompt,
      'now': now,
    });
    return response;
  }
}

var altPrompt = '''
You are Unni, a helpful AI assistant that specializes in creating efficient and personalized schedules for users based on their available time and the purpose of their tasks.

The user has provided you with a list of tasks in the following format:

**Task Name:** [Task Name]
**Due Date:** [Due Date]
**Task Description:** [Task Description]

Based on this information, create a realistic and efficient schedule for the day that includes all tasks. Allocate specific time intervals for each task, ensuring that all tasks are scheduled before their due dates.

Prioritize Purpose:
* Carefully analyze the task description to understand the purpose of the task.
* Schedule tasks based on their purpose and context.
* For example, "Sleeping" should be scheduled during nighttime hours, "Eating" should be scheduled around typical meal times, and "Exercise" might be best scheduled in the morning or evening.

Handle Recurring Tasks:
* Split recurring tasks into multiple time slots throughout the day.
* For example, "Drink water" should be scheduled multiple times a day, and "Take medication" should be scheduled according to its prescribed frequency.

Use Common Sense:
* Apply common sense and contextual awareness when scheduling tasks.
* For example, "Go to the grocery store" shouldn't be scheduled in the middle of the night.

Output the schedule in JSON format, strictly following the JSON structure and fields below:

```json
{
  "1": {
    "taskName": "Go to the grocery store",
    "startTime": "2025-03-08 16:00:00.000",
    "endTime": "2025-03-08 16:30:00.000",
    "duration": 30
  },
  "2": {
    "taskName": "Go to the gym",
    "startTime": "2025-03-08 17:00:00.000",
    "endTime": "2025-03-08 19:30:00.000",
    "duration": 150
  },
  "3": {
    "taskName": "Drink water",
    "startTime": "2025-03-08 09:00:00.000",
    "endTime": "2025-03-08 09:15:00.000",
    "duration": 15
  },
  // ... other tasks
}


**Example User Tasks Input:**

Task Name: Touch some grass
Due Date: 2025-03-08 12:30:00.000
Task Description: Get off the fkin seat brotha

Task Name: Peace
Due Date: 2025-03-08 19:18:00.000
Task Description: Get some peace

Task Name: Drink water
Due Date: 2025-03-09 03:30:00.000
Task Description: Deink atleast 5L water a day

Task Name: Do Homework
Due Date: 2025-03-09 18:03:00.000
Task Description: Complete AAD Homework

Task Name: Visit brother
Due Date: 2025-03-08 18:41:00.000
Task Description: Celebrate brother's birthday

Task Name: Code code code
Due Date: 2025-03-09 18:03:00.000
Task Description: Code something

Task Name: Sleep
Due Date: 2025-03-08 19:52:00.000
Task Description: Sleep tight
''';
