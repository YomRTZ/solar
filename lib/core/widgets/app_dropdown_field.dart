import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/constants/app_colors.dart';
import 'package:flutter_app/core/validation/app_form_validation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _DropdownOpenCubit extends Cubit<bool> {
  _DropdownOpenCubit() : super(false);

  void open() => emit(true);
  void closeDropdown() => emit(false);
}

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
  final double bottomSpacing;

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
    this.bottomSpacing = 16,
  });

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  final _openCubit = _DropdownOpenCubit();

  @override
  void dispose() {
    _openCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_DropdownOpenCubit, bool>(
      bloc: _openCubit,
      builder: (context, isOpen) => FormField<T>(
      key: ValueKey('${widget.label}:${widget.value}'),
      initialValue: widget.value,
      validator:
          widget.validator ??
          (value) => AppFormValidation.requiredSelection(
            value,
            fieldName: widget.label,
          ),
      builder: (field) {
        final hasError = field.errorText != null;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            SizedBox(
              height: 46,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: hasError
                        ? AppFormValidation.errorColor
                        : const Color(0xFFEDF1F3),
                    width: 1,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: field.value,
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
                        isOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
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
                    onChanged: widget.enabled
                        ? (value) {
                            field.didChange(value);
                            widget.onChanged?.call(value);
                          }
                        : null,
                    onTap: _openCubit.open,
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
            if (field.errorText != null) AppFormErrorText(field.errorText!),
            SizedBox(height: widget.bottomSpacing),
          ],
        );
      },
      ),
    );
  }

  @override
  void didUpdateWidget(AppDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset open state when dropdown closes
    if (oldWidget.value != widget.value) {
      _openCubit.closeDropdown();
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
  final double bottomSpacing;

  const AppDropdownFieldString({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.enabled = true,
    this.bottomSpacing = 16,
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
      bottomSpacing: bottomSpacing,
    );
  }
}
