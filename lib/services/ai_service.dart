import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _openAIKey = 'YOUR_OPENAI_API_KEY'; // Replace with your key
  static const String _baseUrl = 'https://api.openai.com/v1';

  Future<String> categorizeTransaction(String description, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAIKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a financial categorization assistant. Categorize transactions into one of these categories: 1-Food & Dining, 2-Transportation, 3-Shopping, 4-Entertainment, 5-Bills & Utilities, 6-Healthcare, 7-Education, 8-Travel, 9-Income, 10-Investment. Return only the category number.'
            },
            {
              'role': 'user',
              'content': 'Categorize this transaction: "$description" amount: \$${amount.toStringAsFixed(2)}'
            }
          ],
          'max_tokens': 10,
          'temperature': 0.1,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final categoryNumber = data['choices'][0]['message']['content'].trim();
        return categoryNumber;
      }
    } catch (e) {
      print('AI Categorization Error: $e');
    }
    
    // Default category if AI fails
    return '3'; // Shopping
  }

  Future<List<String>> generateFinancialInsights(
    List<Map<String, dynamic>> transactions,
    double totalIncome,
    double totalExpense,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAIKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a financial advisor. Analyze spending patterns and provide 3 brief, actionable insights. Keep each insight under 50 words.'
            },
            {
              'role': 'user',
              'content': 'Income: \$${totalIncome.toStringAsFixed(2)}, Expenses: \$${totalExpense.toStringAsFixed(2)}. Recent transactions: ${transactions.take(10).toString()}'
            }
          ],
          'max_tokens': 200,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final insights = data['choices'][0]['message']['content']
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .take(3)
            .toList();
        return insights;
      }
    } catch (e) {
      print('AI Insights Error: $e');
    }
    
    return [
      'Track your spending regularly to stay on budget',
      'Consider setting up automatic savings',
      'Review your subscriptions monthly'
    ];
  }

  Future<String> chatWithAI(String question, Map<String, dynamic> financialData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAIKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are FinGenius, a helpful financial assistant. Answer questions about the user\'s financial data. Be concise and helpful.'
            },
            {
              'role': 'user',
              'content': 'Financial data: $financialData\n\nQuestion: $question'
            }
          ],
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      }
    } catch (e) {
      print('AI Chat Error: $e');
    }
    
    return 'I\'m sorry, I couldn\'t process your question right now. Please try again later.';
  }
}
