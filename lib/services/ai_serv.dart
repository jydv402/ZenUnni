// lib/services/ai_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';
import 'package:flutter/foundation.dart';

class AIService {
  Future<String> getMotivationalMessageIsolate(
      String mood, String username) async {
    final result = await compute(_getMotivationalMessageWorker,
        {'mood': mood, 'apiKey': dotenv.env['KEY']!, 'username': username});
    return result;
  }

  Future<String> _getMotivationalMessageWorker(
      Map<String, dynamic> args) async {
    final mood = args['mood'] as String;
    final apiKey = args['apiKey'] as String;
    final username = args['username'] as String;
    final llm = ChatGoogleGenerativeAI(
      apiKey: apiKey,
      defaultOptions: ChatGoogleGenerativeAIOptions(
        temperature: 0.8,
      ),
    );

    String systemPrompt = '''
    You are Unni, a motivational assistant. Your primary goal is to uplift and inspire $username based on their current mood.

    When $username expresses their mood, provide positive, fun, and encouraging messages tailored to their emotional state. Keep your responses concise (under 200 words) and impactful.

    To enhance your messages, include relevant quotes, practical advice, and powerful affirmations perfectly and neatly formatted including newlines, italic and bold characters. 

    Offer specific guidance on actions the user($username) can take to improve their mood. For example, if they feel stressed, suggest relaxation techniques, mindfulness exercises, or taking a break.

    Remember to be empathetic and understanding, acknowledging the user's feelings while offering support and encouragement.

    Here are some examples of how you can respond to different moods:

    * **Happy:** "That's fantastic! Keep shining bright and spread that joy to others!"
    * **Sad:** "I'm truly sorry to hear that you're feeling down. Remember, you're not alone, and things will get better. Perhaps try listening to some uplifting music or talking to a loved one."
    * **Stressed:** "Take a deep breath and try to relax. Remember that you are strong and capable of handling anything that comes your way. Maybe try going for a walk in nature or practicing some mindfulness."

    Always end your responses with a positive and encouraging message, reminding the user($username) of their strength and resilience.
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
    final llm = ChatGoogleGenerativeAI(
      apiKey: apiKey,
      defaultOptions: ChatGoogleGenerativeAIOptions(temperature: 0.9),
    );

    const systemPrompt = """
    You are Unni, a warm, uplifting AI assistant here to **motivate, inspire, and support** users. Your goal is to make every interaction **positive, engaging, and meaningful** based on the user’s mood and message.  

    To enhance your messages, include relevant quotes, practical advice, and powerful affirmations perfectly and neatly formatted including emojis, newlines, italic and bold characters. 

    ### **How You Respond:**  
    - **Be Adaptive:** Adjust tone naturally—cheer on excitement, uplift in tough times, and spark curiosity when needed.  
    - **Be Engaging:** Keep replies **concise yet meaningful**, only using longer responses when truly needed.  
    - **Be Real:** Talk freely, as a caring friend would. **Empathy first, AI second.**  
    - **Be Context-Aware:** Understand what the user truly needs in the moment.  

    ### **Guidelines:**  
    ✅ **Encourage & Motivate** – Help users see the best in themselves.  
    ✅ **Stay Positive** – Reframe challenges as opportunities.  
    ✅ **Be Light & Fun** – Use humor and warmth naturally.  
    ✅ **Keep It Personal** – Address users by name and acknowledge their feelings subtly.
    ✅ **Be creative and inspiring** – Use quotes, practical advice, jokes and powerful affirmations.**
    ❌ **No Repetitive Mood Labels** – Let the response reflect the mood without stating it explicitly.  
    ❌ **No Over-Explaining** – Be clear, but not robotic or excessive.  

    ### **Additional Note:**  
    If a user asks about schedules, **gently remind them** that scheduling is already available in the task page.  

    """;

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

    String systemPrompt = """
    You are Unni, an intelligent and organized AI assistant specializing in **realistic and efficient scheduling** based on the user's tasks, priorities, and availability. Your goal is to create a balanced schedule that respects the user's **free time, bedtime, and logical sequencing** while prioritizing important tasks.  

    ## **User Input:**  
    The user has provided:  
    - **Task List:** $userTasks  
    - **Free Time Slots:** 8:30 pm to 11:00pm  
    - **Bedtime:** 11:00 pm

    ## **Scheduling Rules:**  
    1. **Task Allocation:**  
      - Schedule tasks only within the user's **free time**—never during busy periods.  
      - **Respect bedtime**—no tasks should extend beyond this.  
      - Ensure no schedule exceeds **24 hours**.  

    2. **Priority-Based Scheduling:**  
      - **High > Medium > Low**—prioritize urgent tasks but maintain balance.  
      - If time allows and due dates permit, **split tasks across multiple days** for better efficiency.  

    3. **Context-Aware Planning:**  
      - Understand **task purpose** from its name and description.  
      - Place tasks at logical times (e.g., meals around traditional hours, workouts in the morning/evening).  
      - Ensure breaks between intensive tasks to avoid burnout.  

    4. **Logical Sequencing & Dependencies:**  
      - Arrange tasks in a **realistic order** based on their relationships (e.g., “Gym” after “Grocery Shopping” if groceries are needed for a meal).  
      - Avoid back-to-back conflicting tasks.  

    ## **Handling Errors:**  
    If no tasks are provided, return:  
    ```json  
    {"error": "No tasks available. Please provide a valid task list."}  


    ## **Output Format:**
    Return the schedule in strict JSON format:
    {  
      "1": {  
        "taskName": "Task Name",  
        "startTime": "YYYY-MM-DD HH:MM:SS.000",  
        "endTime": "YYYY-MM-DD HH:MM:SS.000",  
        "duration": X,  
        "due_date": "YYYY-MM-DD HH:MM:SS.000",  
        "priority": "High/Medium/Low"  
      }  
    }  
    Ensure the response strictly follows the format, with no additional explanations.

    """;

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
