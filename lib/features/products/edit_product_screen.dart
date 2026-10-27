import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_dropdown_field.dart';
import '../../core/widgets/app_continue_button.dart';
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
    _productNameController =
        TextEditingController(text: p?.title ?? 'Solar Trade');
    _modelNumberController =
        TextEditingController(text: p?.idNumber.replaceAll('#', '') ?? 'MB12345');
    _priceController =
        TextEditingController(text: p?.price ?? '1234');
    _taxAmountController = TextEditingController(text: '12');
    _minOrderQtyController = TextEditingController(text: '12');
    _warrantyController = TextEditingController(text: '09/2026');
    _dispatchDistController = TextEditingController(text: 'New Delhi');

    // Pre-select dropdowns
    _selectedCategory = p != null
        ? _categoryFromEnum(p.category)
        : 'Panel';
    _selectedBrand = 'Long';
    _selectedStock = p != null
        ? _stockFromEnum(p.status)
        : 'In Stock';
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
        statusBarColor: Color(0xFF003A8A),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Success Banner ───────────────────────────────────────
                    if (_showSuccessBanner) ...[
                      _buildSuccessBanner(),
                      const SizedBox(height: 20),
                    ],

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
                      onChanged: (v) => setState(() => _selectedCategory = v),
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
                      onChanged: (v) => setState(() => _selectedBrand = v),
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
                      onChanged: (v) => setState(() => _selectedStock = v),
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
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Header
  // ────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Edit Product',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FBF5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF217552).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Green check circle
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFF217552),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 10),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Updated!',
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF217552),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Product has been updated successfully',
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ),

          // Close button
          GestureDetector(
            onTap: () => setState(() => _showSuccessBanner = false),
            child: const Icon(
              Icons.close,
              color: Color(0xFF217552),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
