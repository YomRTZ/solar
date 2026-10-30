import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/constants/app_colors.dart';

// Reusable dropdown field widget with the same styling as AppTextField but with dropdown
class AppDropdownField<T> extends StatefulWidget {
  // The label text displayed above the dropdown
  final String label;
  
  // The hint text shown when no value is selected
  final String hint;
  
  // List of items to display in dropdown
  final List<T> items;
  
  // Function to convert item to display string
  final String Function(T) itemToString;
  
  // Currently selected value
  final T? value;
  
  // Callback when value changes
  final void Function(T?)? onChanged;
  
  // Optional validator function
  final String? Function(T?)? validator;
  
  // Whether the dropdown is enabled (default: true)
  final bool enabled;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.itemToString,
    required this.onChanged,
    this.value,
    this.validator,
    this.enabled = true,
  });

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label section (same as AppTextField)
        SizedBox(
          height: 21,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.label,
              maxLines: 1,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 1.6,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.24,
                color: const Color(0xFF6C7278),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        
        // Dropdown section (same height and styling as AppTextField)
        SizedBox(
          height: 46,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEDF1F3), width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: widget.value,
                hint: Text(
                  widget.hint,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColors.textGreyLight,
                  ),
                ),
                isExpanded: true,
                icon: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Icon(
                    _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xFF202020),
                    size: 24,
                  ),
                ),
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF000000),
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                onChanged: widget.enabled ? widget.onChanged : null,
                onTap: () {
                  setState(() {
                    _isOpen = true;
                  });
                },
                items: widget.items.map((T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      widget.itemToString(item),
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(AppDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset open state when dropdown closes
    if (oldWidget.value != widget.value) {
      setState(() {
        _isOpen = false;
      });
    }
  }
}

// Simplified dropdown field for String values
class AppDropdownFieldString extends StatelessWidget {
  // The label text displayed above the dropdown
  final String label;
  
  // The hint text shown when no value is selected
  final String hint;
  
  // List of string items to display in dropdown
  final List<String> items;
  
  // Currently selected value
  final String? value;
  
  // Callback when value changes
  final void Function(String?)? onChanged;
  
  // Optional validator function
  final String? Function(String?)? validator;
  
  // Whether the dropdown is enabled (default: true)
  final bool enabled;

  const AppDropdownFieldString({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppDropdownField<String>(
      label: label,
      hint: hint,
      items: items,
      itemToString: (item) => item,
      value: value,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
    );
  }
}
