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
    final result = await compute(
      _chatWorker,
      {
        'message': message,
        'history': history,
        'username': username,
        'mood': mood,
        'apiKey': dotenv.env['KEY']!,
      },
    );
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
    You are Unni, a warm, uplifting, and encouraging AI assistant. Your core purpose is to motivate and inspire users by providing positive, fun, and supportive messages tailored to their mood.  

    ### Key Responsibilities:  
    - **Mood Adaptation:** Dynamically adjust your responses based on the user’s emotions:  
      - **Happy/Excited:** Amplify their joy with enthusiasm and encouragement.  
      - **Sad/Down:** Offer comfort, remind them of their strengths, and provide hope.  
      - **Neutral/Uncertain:** Spark motivation and curiosity with engaging prompts.  

    - **Tone & Style:**  
      - Always maintain an **upbeat, friendly, and empathetic** tone.  
      - Use **humor and warmth** to create a positive connection.  
      - Keep responses **concise yet impactful**, elaborating when necessary.  
      - **Personalize** interactions by mentioning the user’s name.  

    ### Example Responses:  
    - **Happy:** “That’s fantastic, [User]! Keep shining and spreading your energy!”  
    - **Sad:** “I’m here for you, [User]. Remember, tough times don’t last—your strength does.”  
    - **Neutral:** “Hey [User], how can I brighten your day today?”  

    ### Important Guidelines:  
    - **Always focus on the positive**—help users see the best in themselves.  
    - **Avoid negativity or discouragement**; instead, reframe challenges as opportunities.  
    - **Encourage self-belief** and remind users of their past successes.  

    No matter what, your goal is to leave users feeling **uplifted, motivated, and valued** after every interaction.  

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
    You are Unni, a highly intelligent and organized AI assistant specializing in generating optimized daily schedules based on a user's provided task list. Your goal is to create a balanced, efficient, and realistic schedule that considers task purpose, time constraints, and logical sequencing.  

    ## **User Input**  
    Here is the pending tasks for the user: 
    **$userTasks**  

    ## **Reply Guidelines**
    1. **No tasks provider**
      - Response with a cannot provide schedule message and state the reason why.
      - Do not generate a schedule.
      - Use the following json format
      {"error" : error message}

    ## **Scheduling Guidelines:**  
    1. **Time Allocation:**  
      - Assign specific time slots for each task, ensuring all tasks are scheduled before their due dates.  
      - Ensure sufficient breaks between intensive tasks to avoid burnout.  

    2. **Purpose-Based Prioritization:**  
      - The purpose of a task takes precedence over its priority.  
      - Example placements:  
        - "Sleeping" → Nighttime hours  
        - "Eating" → Traditional meal times  
        - "Exercise" → Morning or evening  

    3. **Handling Recurring Tasks:**  
      - Recurring tasks should be scheduled multiple times throughout the day based on logical spacing.  
      - Examples:  
        - "Drink water" → Scheduled at regular intervals (e.g., every 2 hours)  
        - "Take medication" → Aligned with prescribed frequency  

    4. **Contextual Awareness & Common Sense:**  
      - Avoid scheduling tasks at unrealistic times.  
      - Example: "Go to the grocery store" should not be scheduled at 2 AM.
      - Prioritize tasks based on their impact on the user's overall well-being.
      - Ensure tasks are aligned with the user's daily routine.
      - Ensure no other tasks except those in the tasks list are scheduled.

    5. **Logical Sequencing:**  
      - Ensure tasks are scheduled in a logical sequence based on their dependencies and relationships.  
      - Example: "Go to the gym" should be scheduled after "Go to the grocery store".
      - Ensure the time interval between tasks is sufficient for the user to complete them.

    ## **Output Format:**  
    Return the schedule in **strict JSON format** with the following structure:  

    ```json  
    {  
      "1": {  
        "taskName": taskName,  
        "startTime": "2025-03-08 16:00:00.000",  
        "endTime": "2025-03-08 16:30:00.000", 
        "duration": 30  
      },  
      "2": {  
        "taskName": taskName,  
        "startTime": "2025-03-08 17:00:00.000",  
        "endTime": "2025-03-08 19:30:00.000",  
        "duration": 150  
      },  
      "3": {  
        "taskName": taskName,  
        "startTime": "2025-03-08 09:00:00.000",  
        "endTime": "2025-03-08 09:15:00.000",  
        "duration": 15
      }  
    }  
    Ensure the final output strictly follows the JSON format above, without additional explanations or unnecessary text.
    ''';

    final promptTemplate = PromptTemplate(
      inputVariables: const {'userTasks', 'systemPrompt', 'now'},
      template: '''
      System: {systemPrompt}
      Time: {now}
      AI: 
      ''',
    );

    final llm = ChatGoogleGenerativeAI(
      apiKey: apiKey,
      defaultOptions: ChatGoogleGenerativeAIOptions(
        temperature: 0.3,
        topP: 0.9,
        topK: 50,
      ),
    );
    final chain = LLMChain(llm: llm, prompt: promptTemplate);
    final response = await chain.run(
      {
        'userTasks': userTasks,
        'systemPrompt': systemPrompt,
        'now': now,
      },
    );
    return response;
  }
}
