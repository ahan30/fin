import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../services/ai_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AIService _aiService = AIService();
  
  List<TransactionModel> _transactions = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  double _totalIncome = 0;
  double _totalExpense = 0;
  
  List<TransactionModel> get transactions => _transactions;
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get balance => _totalIncome - _totalExpense;

  ExpenseProvider() {
    _loadDefaultCategories();
    _loadTransactions();
  }

  Future<void> _loadDefaultCategories() async {
    _categories = [
      CategoryModel(id: '1', name: 'Food & Dining', icon: '🍽️', color: Colors.orange),
      CategoryModel(id: '2', name: 'Transportation', icon: '🚗', color: Colors.blue),
      CategoryModel(id: '3', name: 'Shopping', icon: '🛍️', color: Colors.pink),
      CategoryModel(id: '4', name: 'Entertainment', icon: '🎬', color: Colors.purple),
      CategoryModel(id: '5', name: 'Bills & Utilities', icon: '💡', color: Colors.red),
      CategoryModel(id: '6', name: 'Healthcare', icon: '🏥', color: Colors.green),
      CategoryModel(id: '7', name: 'Education', icon: '📚', color: Colors.indigo),
      CategoryModel(id: '8', name: 'Travel', icon: '✈️', color: Colors.teal),
      CategoryModel(id: '9', name: 'Income', icon: '💰', color: Colors.green),
      CategoryModel(id: '10', name: 'Investment', icon: '📈', color: Colors.deepPurple),
    ];
    notifyListeners();
  }

  Future<void> _loadTransactions() async {
    if (_auth.currentUser == null) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();

      _transactions = snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();

      _calculateTotals();
    } catch (e) {
      print('Error loading transactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateTotals() {
    _totalIncome = _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, t) => sum + t.amount);
    
    _totalExpense = _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    if (_auth.currentUser == null) return;

    try {
      // Use AI to categorize if no category is provided
      if (transaction.categoryId.isEmpty) {
        final suggestedCategory = await _aiService.categorizeTransaction(
          transaction.description,
          transaction.amount,
        );
        transaction = transaction.copyWith(categoryId: suggestedCategory);
      }

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('transactions')
          .add(transaction.toFirestore());

      _transactions.insert(0, transaction);
      _calculateTotals();
      notifyListeners();
    } catch (e) {
      print('Error adding transaction: $e');
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    if (_auth.currentUser == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('transactions')
          .doc(transactionId)
          .delete();

      _transactions.removeWhere((t) => t.id == transactionId);
      _calculateTotals();
      notifyListeners();
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }

  List<TransactionModel> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _transactions.where((t) => 
        t.date.isAfter(start.subtract(const Duration(days: 1))) &&
        t.date.isBefore(end.add(const Duration(days: 1)))
    ).toList();
  }

  Map<String, double> getCategoryExpenses() {
    final Map<String, double> categoryTotals = {};
    
    for (final transaction in _transactions) {
      if (transaction.type == TransactionType.expense) {
        final category = _categories.firstWhere(
          (c) => c.id == transaction.categoryId,
          orElse: () => CategoryModel(id: '', name: 'Other', icon: '📦', color: Colors.grey),
        );
        categoryTotals[category.name] = (categoryTotals[category.name] ?? 0) + transaction.amount;
      }
    }
    
    return categoryTotals;
  }
}
