import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String selectedSize;
  final ValueChanged<String> onSizeSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: sizes.map((size) {
        final isSelected = size == selectedSize;
        return _SizeChip(
          size: size,
          isSelected: isSelected,
          onTap: () => onSizeSelected(size),
        );
      }).toList(),
    );
  }
}

class _SizeChip extends StatefulWidget {
  final String size;
  final bool isSelected;
  final VoidCallback onTap;

  const _SizeChip({
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SizeChip> createState() => _SizeChipState();
}

class _SizeChipState extends State<_SizeChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : (widget.isSelected ? 1.03 : 1.0),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minWidth: 46, minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected ? AppTheme.primary : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isSelected
                  ? AppTheme.primary
                  : Colors.black.withValues(alpha: 0.08),
              width: 1.2,
            ),
            boxShadow: [
              if (widget.isSelected)
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                color: widget.isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
                letterSpacing: 0.2,
              ),
              child: Text(
                widget.size,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
