import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:io';

import '../../providers/expense_provider.dart';
import '../../models/transaction.dart';
import '../../services/ocr_service.dart';
import '../../widgets/category_selector.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  
  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategoryId = '';
  DateTime _selectedDate = DateTime.now();
  bool _isRecurring = false;
  File? _receiptImage;
  
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        actions: [
          TextButton(
            onPressed: _saveTransaction,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction Type Toggle
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTypeButton(
                          'Expense',
                          TransactionType.expense,
                          Icons.remove_circle,
                          Colors.red,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTypeButton(
                          'Income',
                          TransactionType.income,
                          Icons.add_circle,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Amount Input
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\$ ',
                          hintText: '0.00',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description Input
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              _isListening ? Icons.mic : Icons.mic_none,
                              color: _isListening ? Colors.red : null,
                            ),
                            onPressed: _toggleListening,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'What did you spend on?',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category Selection
              CategorySelector(
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: (categoryId) {
                  setState(() {
                    _selectedCategoryId = categoryId;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Date Selection
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Date'),
                  subtitle: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                  onTap: _selectDate,
                ),
              ),
              const SizedBox(height: 16),

              // Receipt Scanner
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Receipt',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _scanReceipt,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Scan Receipt'),
                          ),
                          const SizedBox(width: 16),
                          if (_receiptImage != null)
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(_receiptImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notes (Optional)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Add any additional notes...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Recurring Toggle
              Card(
                child: SwitchListTile(
                  title: const Text('Recurring Transaction'),
                  subtitle: const Text('This transaction repeats monthly'),
                  value: _isRecurring,
                  onChanged: (value) {
                    setState(() {
                      _isRecurring = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, TransactionType type, IconData icon, Color color) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
    } else {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        await _speechToText.listen(
          onResult: (result) {
            setState(() {
              _descriptionController.text = result.recognizedWords;
            });
          },
        );
      }
    }
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _scanReceipt() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      setState(() => _receiptImage = File(image.path));
      
      // Use OCR to extract transaction data
      final transaction = await OCRService.scanReceipt(File(image.path));
      if (transaction != null) {
        setState(() {
          _descriptionController.text = transaction.description;
          _amountController.text = transaction.amount.toString();
          _selectedDate = transaction.date;
        });
      }
    }
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final transaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: _descriptionController.text,
        amount: double.parse(_amountController.text),
        type: _selectedType,
        categoryId: _selectedCategoryId,
        date: _selectedDate,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        isRecurring: _isRecurring,
        receiptUrl: _receiptImage?.path,
      );

      await context.read<ExpenseProvider>().addTransaction(transaction);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction added successfully!')),
        );
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
