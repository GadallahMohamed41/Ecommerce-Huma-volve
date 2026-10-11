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
      spacing: 8,
      runSpacing: 6,
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
    final isLongText = widget.size.length > 3;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : (widget.isSelected ? 1.05 : 1.0),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: isLongText ? null : 32,
          height: 32,
          padding: isLongText
              ? const EdgeInsets.symmetric(horizontal: 10)
              : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: widget.isSelected ? AppTheme.primary : Colors.white,
            shape: isLongText ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: isLongText ? BorderRadius.circular(16) : null,
            border: Border.all(
              color: widget.isSelected
                  ? AppTheme.primary
                  : Colors.black.withValues(alpha: 0.12),
              width: 1.2,
            ),
            boxShadow: [
              if (widget.isSelected)
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
            ],
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                color: widget.isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: isLongText ? 11 : 12,
                letterSpacing: 0.1,
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
