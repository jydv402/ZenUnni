import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

final aiServiceProvider = Provider<AIService>((ref) {
  return AIService();
});

class AIService {
  final _storage = const FlutterSecureStorage();

  AIService();

  Future<String> _generateContent(
    String systemPrompt,
    List<Map<String, dynamic>> history,
    Map<String, dynamic>? generationConfig,
  ) async {
    final apiKey = await _storage.read(key: 'gemini_api_key');
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint('Error: Gemini API Key is missing from Secure Storage.');
      return 'API Key not configured. Please add your key in the App Settings.';
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite-preview:generateContent?key=$apiKey',
    );

    final body = {
      'systemInstruction': {
        'parts': [
          {'text': systemPrompt},
        ],
      },
      'contents': history,
      'generationConfig': ?generationConfig,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        return data['candidates'][0]['content']['parts'][0]['text'] ?? '';
      }
      return 'Error generating message';
    } else {
      debugPrint('Gemini API Error: ${response.statusCode} - ${response.body}');
      return 'Error communicating with AI service';
    }
  }

  Future<String> getMotivationalMessage(String mood, String username) async {
    final systemPrompt =
        '''
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

    return _generateContent(
      systemPrompt,
      [
        {
          'role': 'user',
          'parts': [
            {'text': userPrompt},
          ],
        },
      ],
      {'temperature': 0.8},
    );
  }

  Future<String> unniChat(
    String message,
    List history,
    String username,
    String about,
    String mood,
  ) async {
    final DateTime now = DateTime.now();

    final systemPrompt =
        """
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
    
    Current Time: $now
    User's mood: $mood
    About user: $about
    """;

    // Convert history to list of maps
    final List<Map<String, dynamic>> convertedHistory = [];
    for (var msg in history) {
      convertedHistory.add({
        'role': msg.isUser ? 'user' : 'model',
        'parts': [
          {'text': msg.text},
        ],
      });
    }

    // Add current message to history
    convertedHistory.add({
      'role': 'user',
      'parts': [
        {'text': message},
      ],
    });

    return _generateContent(systemPrompt, convertedHistory, {
      'temperature': 0.9,
    });
  }

  Future<String> schedGenerator(
    String userTasks,
    String about,
    String freeTime,
    String bedTime,
  ) async {
    final now = DateTime.now();

    final systemPrompt =
        """
    You are Unni, an intelligent and organized AI assistant specializing in **realistic and efficient scheduling** based on the user's tasks, priorities, and availability. Your goal is to create a balanced schedule that respects the user's **free time, bedtime, and logical sequencing** while prioritizing important tasks.  

    ## **User Input:**  
    The user has provided:
    - **Current Date & Time:** $now
    - **About User:** $about
    - **Free Time of User:** $freeTime 
    - **Bedtime:** $bedTime

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

    return _generateContent(
      systemPrompt,
      [
        {
          'role': 'user',
          'parts': [
            {'text': "Task List: \n$userTasks"},
          ],
        },
      ],
      {'temperature': 0.3, 'topP': 0.9, 'topK': 50},
    );
  }
}
