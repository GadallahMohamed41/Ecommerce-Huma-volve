import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class ColorSelector extends StatelessWidget {
  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: colors.map((color) {
        final isSelected = color == selectedColor;
        return _ColorSwatch(
          color: color,
          isSelected: isSelected,
          onTap: () => onColorSelected(color),
        );
      }).toList(),
    );
  }
}

class _ColorSwatch extends StatefulWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorSwatch({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ColorSwatch> createState() => _ColorSwatchState();
}

class _ColorSwatchState extends State<_ColorSwatch> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isBright = widget.color.computeLuminance() > 0.6;
    final checkColor = isBright ? const Color(0xFF1E2022) : Colors.white;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : (widget.isSelected ? 1.08 : 1.0),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.isSelected
                  ? AppTheme.primary
                  : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              if (widget.isSelected)
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: widget.isSelected
                ? Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: checkColor,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
