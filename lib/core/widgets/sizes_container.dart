import 'package:final_project/core/widgets/custom_text.dart';
import 'package:final_project/features/product_details/data/models/sizes_model.dart';
import 'package:flutter/material.dart';

class SizesContainer extends StatelessWidget {
  const SizesContainer({
    super.key,
    required this.sizesModel,
    required this.isSelected,
    required this.onTap,
  });

  final SizesModel sizesModel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
          border: isSelected
              ? null
              : Border.all(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Center(
          child: CustomText(
            text: sizesModel.size,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
