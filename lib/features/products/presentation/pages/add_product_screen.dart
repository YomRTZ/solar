import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/widgets/app_text_field.dart';
import 'package:flutter_app/core/widgets/app_dropdown_field.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // Controllers
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _modelNumberController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _taxAmountController = TextEditingController();
  final TextEditingController _minOrderQtyController = TextEditingController();
  final TextEditingController _warrantyController = TextEditingController();
  final TextEditingController _dispatchDistController = TextEditingController();

  // Dropdown values
  String? _selectedCategory;
  String? _selectedBrand;
  String? _selectedStock;

  // Image paths (simulated picks)
  final List<String> _selectedImages = [
    'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
  ];

  bool _isLoading = false;

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
    setState(() => _isLoading = false);
    // TODO: save product and navigate
    Navigator.pop(context);
  }

  // Simulate adding an image
  void _addImage() {
    setState(() {
      _selectedImages.add(
        'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      );
    });
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
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
            const SecondAppHeader(title: 'Add Product'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Add Images ──────────────────────────────────────────
                    _buildAddImages(),
                    const SizedBox(height: 20),

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

  // ──────────────────────────────────────────────────────────── Add Images Row
  Widget _buildAddImages() {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Images',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 1.6,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.24,
              color: const Color(0xFF6C7278),
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 41,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ..._selectedImages.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: _buildImageThumb(entry.value, entry.key),
                  );
                }),
                GestureDetector(
                  onTap: _addImage,
                  child: Container(
                    width: 41,
                    height: 41,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/icons/5ceff9d5d9cae078a369c65ead35be73405d7dcd.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageThumb(String imagePath, int index) {
    return Stack(
      children: [
        Container(
          width: 41,
          height: 41,
          decoration: BoxDecoration(
            color: const Color(0x1F084EAD),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFFF5F5F5),
              child: const Icon(Icons.image, color: Colors.grey),
            ),
          ),
        ),
        // Remove button
        Positioned(
          top: 2,
          right: 2,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFF003D82),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 11),
            ),
          ),
        ),
      ],
    );
  }
}
