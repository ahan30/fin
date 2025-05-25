import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategoryId;
  final Function(String) onCategorySelected;

  const CategorySelector({
    Key? key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: expenseProvider.categories.map((category) {
                    final isSelected = category.id == selectedCategoryId;
                    return GestureDetector(
                      onTap: () => onCategorySelected(category.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? category.color.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? category.color : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(category.icon, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 4),
                            Text(
                              category.name,
                              style: TextStyle(
                                color: isSelected ? category.color : null,
                                fontWeight: isSelected ? FontWeight.bold : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
