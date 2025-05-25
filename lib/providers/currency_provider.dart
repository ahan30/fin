import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyProvider extends ChangeNotifier {
  String _selectedCurrency = 'USD';
  Map<String, double> _exchangeRates = {'USD': 1.0};
  
  String get selectedCurrency => _selectedCurrency;
  Map<String, double> get exchangeRates => _exchangeRates;
  
  final List<String> supportedCurrencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY', 'INR', 'BRL'
  ];
  
  CurrencyProvider() {
    _loadCurrency();
    _fetchExchangeRates();
  }
  
  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCurrency = prefs.getString('selected_currency') ?? 'USD';
    notifyListeners();
  }
  
  Future<void> setCurrency(String currency) async {
    _selectedCurrency = currency;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_currency', currency);
  }
  
  Future<void> _fetchExchangeRates() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _exchangeRates = Map<String, double>.from(data['rates']);
        _exchangeRates['USD'] = 1.0; // Base currency
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching exchange rates: $e');
    }
  }
  
  double convertAmount(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;
    
    final fromRate = _exchangeRates[fromCurrency] ?? 1.0;
    final toRate = _exchangeRates[toCurrency] ?? 1.0;
    
    // Convert to USD first, then to target currency
    final usdAmount = amount / fromRate;
    return usdAmount * toRate;
  }
  
  String formatCurrency(double amount, [String? currency]) {
    final curr = currency ?? _selectedCurrency;
    final symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CAD': 'C\$',
      'AUD': 'A\$',
      'CHF': 'CHF',
      'CNY': '¥',
      'INR': '₹',
      'BRL': 'R\$',
    };
    
    final symbol = symbols[curr] ?? curr;
    return '$symbol${amount.toStringAsFixed(2)}';
  }
}
