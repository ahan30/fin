import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String description;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final DateTime date;
  final String? notes;
  final List<String> tags;
  final bool isRecurring;
  final String? receiptUrl;

  TransactionModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.notes,
    this.tags = const [],
    this.isRecurring = false,
    this.receiptUrl,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      description: data['description'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      type: data['type'] == 'income' ? TransactionType.income : TransactionType.expense,
      categoryId: data['categoryId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      notes: data['notes'],
      tags: List<String>.from(data['tags'] ?? []),
      isRecurring: data['isRecurring'] ?? false,
      receiptUrl: data['receiptUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'description': description,
      'amount': amount,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'categoryId': categoryId,
      'date': Timestamp.fromDate(date),
      'notes': notes,
      'tags': tags,
      'isRecurring': isRecurring,
      'receiptUrl': receiptUrl,
    };
  }

  TransactionModel copyWith({
    String? id,
    String? description,
    double? amount,
    TransactionType? type,
    String? categoryId,
    DateTime? date,
    String? notes,
    List<String>? tags,
    bool? isRecurring,
    String? receiptUrl,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      isRecurring: isRecurring ?? this.isRecurring,
      receiptUrl: receiptUrl ?? this.receiptUrl,
    );
  }
}
