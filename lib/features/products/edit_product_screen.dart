import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_dropdown_field.dart';
import '../../core/widgets/app_continue_button.dart';
import '../../core/widgets/second_app_header.dart';
import '../../models/product.dart';

class EditProductScreen extends StatefulWidget {
  /// Pass an existing product to pre-fill the form.
  /// If null, fields start empty.
  final Product? product;

  const EditProductScreen({super.key, this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // Controllers
  late final TextEditingController _productNameController;
  late final TextEditingController _modelNumberController;
  late final TextEditingController _priceController;
  late final TextEditingController _taxAmountController;
  late final TextEditingController _minOrderQtyController;
  late final TextEditingController _warrantyController;
  late final TextEditingController _dispatchDistController;

  // Dropdown values
  String? _selectedCategory;
  String? _selectedBrand;
  String? _selectedStock;

  // UI state
  bool _isLoading = false;
  bool _showSuccessBanner = true; // shown immediately on edit screen

  // Dropdown options
  static const List<String> _categories = [
    'Panel',
    'Battery',
    'Inverter',
    'Controller',
  ];
  static const List<String> _brands = [
    'Long',
    'Havells',
    'Luminous',
    'Microtek',
    'Exide',
  ];
  static const List<String> _stockOptions = [
    'In Stock',
    'Low Stock',
    'Out of Stock',
  ];

  @override
  void initState() {
    super.initState();

    final p = widget.product;

    // Pre-fill controllers from passed product (or defaults matching screenshot)
    _productNameController = TextEditingController(
      text: p?.title ?? 'Solar Trade',
    );
    _modelNumberController = TextEditingController(
      text: p?.idNumber.replaceAll('#', '') ?? 'MB12345',
    );
    _priceController = TextEditingController(text: p?.price ?? '1234');
    _taxAmountController = TextEditingController(text: '12');
    _minOrderQtyController = TextEditingController(text: '12');
    _warrantyController = TextEditingController(text: '09/2026');
    _dispatchDistController = TextEditingController(text: 'New Delhi');

    // Pre-select dropdowns
    _selectedCategory = p != null ? _categoryFromEnum(p.category) : 'Panel';
    _selectedBrand = 'Long';
    _selectedStock = p != null ? _stockFromEnum(p.status) : 'In Stock';
  }

  String _categoryFromEnum(ProductCategory cat) {
    switch (cat) {
      case ProductCategory.panel:
        return 'Panel';
      case ProductCategory.battery:
        return 'Battery';
      case ProductCategory.inverter:
        return 'Inverter';
      default:
        return 'Panel';
    }
  }

  String _stockFromEnum(ProductStatus s) {
    switch (s) {
      case ProductStatus.inStock:
        return 'In Stock';
      case ProductStatus.lowStock:
        return 'Low Stock';
      case ProductStatus.outOfStock:
        return 'Out of Stock';
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _modelNumberController.dispose();
    _priceController.dispose();
    _taxAmountController.dispose();
    _minOrderQtyController.dispose();
    _warrantyController.dispose();
    _dispatchDistController.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _productNameController.text.isNotEmpty &&
      _selectedCategory != null &&
      _modelNumberController.text.isNotEmpty &&
      _selectedBrand != null &&
      _priceController.text.isNotEmpty &&
      _taxAmountController.text.isNotEmpty &&
      _minOrderQtyController.text.isNotEmpty &&
      _selectedStock != null &&
      _warrantyController.text.isNotEmpty &&
      _dispatchDistController.text.isNotEmpty;

  void _handleContinue() async {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _showSuccessBanner = true;
    });
    // Re-show banner after save
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showSuccessBanner = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            const SecondAppHeader(title: 'Edit Product'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_showSuccessBanner) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: _buildSuccessBanner(),
                      ),
                      const SizedBox(height: 20),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Product Name ─────────────────────────────────────────
                          AppTextField(
                            label: 'Product Name',
                            hint: 'Solar Trade',
                            controller: _productNameController,
                          ),
                          const SizedBox(height: 20),

                          // ── Select Category ──────────────────────────────────────
                          AppDropdownFieldString(
                            label: 'Select Category',
                            hint: 'Panel',
                            items: _categories,
                            value: _selectedCategory,
                            onChanged: (v) =>
                                setState(() => _selectedCategory = v),
                          ),
                          const SizedBox(height: 20),

                          // ── Model Number ─────────────────────────────────────────
                          AppTextField(
                            label: 'Model Number',
                            hint: 'MB12345',
                            controller: _modelNumberController,
                          ),
                          const SizedBox(height: 20),

                          // ── Select Brand ─────────────────────────────────────────
                          AppDropdownFieldString(
                            label: 'Select Brand',
                            hint: 'Long',
                            items: _brands,
                            value: _selectedBrand,
                            onChanged: (v) =>
                                setState(() => _selectedBrand = v),
                          ),
                          const SizedBox(height: 20),

                          // ── Price (Excluding Tax) ────────────────────────────────
                          AppTextField(
                            label: 'Price (Excluding Tax)',
                            hint: '1234',
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),

                          // ── Tax Amount ───────────────────────────────────────────
                          AppTextField(
                            label: 'Tax Amount',
                            hint: '12',
                            controller: _taxAmountController,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),

                          // ── Min Order Qty ────────────────────────────────────────
                          AppTextField(
                            label: 'Min Order Qty',
                            hint: '12',
                            controller: _minOrderQtyController,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),

                          // ── Stock ────────────────────────────────────────────────
                          AppDropdownFieldString(
                            label: 'Stock',
                            hint: 'In Stock',
                            items: _stockOptions,
                            value: _selectedStock,
                            onChanged: (v) =>
                                setState(() => _selectedStock = v),
                          ),
                          const SizedBox(height: 20),

                          // ── Warranty ─────────────────────────────────────────────
                          AppTextField(
                            label: 'Warranty',
                            hint: '09/2026',
                            controller: _warrantyController,
                          ),
                          const SizedBox(height: 20),

                          // ── Dispatch Dist. ───────────────────────────────────────
                          AppTextField(
                            label: 'Dispatch Dist.',
                            hint: 'New Delhi',
                            controller: _dispatchDistController,
                          ),
                          const SizedBox(height: 28),

                          // ── Continue Button ──────────────────────────────────────
                          AppContinueButton(
                            text: 'Continue',
                            isLoading: _isLoading,
                            showArrow: false,
                            onPressed: _handleContinue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Success Banner
  // ────────────────────────────────────────────────────────────
  Widget _buildSuccessBanner() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 332),
      height: 85,
      decoration: BoxDecoration(
        color: const Color(0xFF20315C),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 16,
            right: 37,
            height: 52,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/icons/green-check-icon.svg',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Updated!',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          height: 1.2,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        'Product has been updated successfully',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          height: 1.69,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9FAED7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 16,
            child: Center(
              child: GestureDetector(
                onTap: () => setState(() => _showSuccessBanner = false),
                child: SvgPicture.asset(
                  'assets/icons/cross-icon.svg',
                  width: 10,
                  height: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
