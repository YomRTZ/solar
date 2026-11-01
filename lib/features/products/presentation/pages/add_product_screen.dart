import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_form_section.dart';
import 'package:flutter_app/core/widgets/app_text_field.dart';
import 'package:flutter_app/core/widgets/app_dropdown_field.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/products/presentation/cubit/product_editor_cubit.dart';
import 'package:flutter_app/features/products/data/datasources/products_data.dart';
import 'package:flutter_app/features/products/domain/entities/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  // Controllers
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _modelNumberController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _taxAmountController = TextEditingController();
  final TextEditingController _minOrderQtyController = TextEditingController();
  final TextEditingController _warrantyController = TextEditingController();
  final TextEditingController _dispatchDistController = TextEditingController();

  final ProductEditorCubit _editorCubit = ProductEditorCubit(
    initialState: const ProductEditorState(
      category: 'Panel',
      brand: 'Long',
      stock: 'In Stock',
    ),
  );

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
    _editorCubit.close();
    super.dispose();
  }

  void _handleContinue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _editorCubit.setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    _editorCubit.setLoading(false);
    final state = _editorCubit.state;
    final modelNumber = state.modelNumber.trim().replaceFirst(
      RegExp(r'^#'),
      '',
    );
    ProductsData.addProduct(
      Product(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: state.productName.trim(),
        idNumber: '#$modelNumber',
        price: state.price.trim(),
        imagePath: state.imagePaths.isEmpty
            ? ProductsData.defaultImagePath
            : state.imagePaths.first,
        status: _statusFromValue(state.stock),
        category: _categoryFromValue(state.category),
        brand: state.brand ?? '',
        taxAmount: state.taxAmount.trim(),
        minimumOrderQuantity: state.minimumOrderQuantity.trim(),
        warranty: state.warranty.trim(),
        dispatchDistrict: state.dispatchDistrict.trim(),
      ),
    );
    context.go(AppRoutes.myProducts);
  }

  ProductCategory _categoryFromValue(String? value) {
    switch (value) {
      case 'Battery':
        return ProductCategory.battery;
      case 'Inverter':
        return ProductCategory.inverter;
      case 'Controller':
        return ProductCategory.controller;
      default:
        return ProductCategory.panel;
    }
  }

  ProductStatus _statusFromValue(String? value) {
    switch (value) {
      case 'Low Stock':
        return ProductStatus.lowStock;
      case 'Out of Stock':
        return ProductStatus.outOfStock;
      default:
        return ProductStatus.inStock;
    }
  }

  // Pick an image from the gallery using image_picker
  Future<void> _addImage() async {
    try {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (xFile == null) return; // user cancelled
      _editorCubit.addImage(xFile.path);
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open image picker: $e')),
        );
      }
    }
  }

  void _removeImage(int index) {
    _editorCubit.removeImage(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductEditorCubit, ProductEditorState>(
      bloc: _editorCubit,
      builder: (context, state) => AnnotatedRegion<SystemUiOverlayStyle>(
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
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Add Images ──────────────────────────────────────────
                      _buildAddImages(),

                      Form(
                        key: _formKey,
                        child: AppFormSection(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // ── Product Name ─────────────────────────────────────────
                              AppTextField(
                                label: 'Product Name',
                                hint: 'Solar Trade',
                                controller: _productNameController,
                                onChanged: _editorCubit.updateProductName,
                              ),

                              // ── Select Category ──────────────────────────────────────
                              AppDropdownFieldString(
                                label: 'Select Category',
                                hint: 'Panel',
                                items: _categories,
                                value: state.category,
                                onChanged: _editorCubit.selectCategory,
                              ),

                              // ── Model Number ─────────────────────────────────────────
                              AppTextField(
                                label: 'Model Number',
                                hint: 'MB12345',
                                controller: _modelNumberController,
                                onChanged: _editorCubit.updateModelNumber,
                              ),

                              // ── Select Brand ─────────────────────────────────────────
                              AppDropdownFieldString(
                                label: 'Select Brand',
                                hint: 'Long',
                                items: _brands,
                                value: state.brand,
                                onChanged: _editorCubit.selectBrand,
                              ),

                              // ── Price (Excluding Tax) ────────────────────────────────
                              AppTextField(
                                label: 'Price (Excluding Tax)',
                                hint: '1234',
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                onChanged: _editorCubit.updatePrice,
                              ),

                              // ── Tax Amount ───────────────────────────────────────────
                              AppTextField(
                                label: 'Tax Amount',
                                hint: '12',
                                controller: _taxAmountController,
                                keyboardType: TextInputType.number,
                                onChanged: _editorCubit.updateTaxAmount,
                              ),

                              // ── Min Order Qty ────────────────────────────────────────
                              AppTextField(
                                label: 'Min Order Qty',
                                hint: '12',
                                controller: _minOrderQtyController,
                                keyboardType: TextInputType.number,
                                onChanged:
                                    _editorCubit.updateMinimumOrderQuantity,
                              ),

                              // ── Stock ────────────────────────────────────────────────
                              AppDropdownFieldString(
                                label: 'Stock',
                                hint: 'In Stock',
                                items: _stockOptions,
                                value: state.stock,
                                onChanged: _editorCubit.selectStock,
                              ),

                              // ── Warranty ─────────────────────────────────────────────
                              AppTextField(
                                label: 'Warranty',
                                hint: '09/2026',
                                controller: _warrantyController,
                                onChanged: _editorCubit.updateWarranty,
                              ),

                              // ── Dispatch Dist. ───────────────────────────────────────
                              AppTextField(
                                label: 'Dispatch Dist.',
                                hint: 'New Delhi',
                                controller: _dispatchDistController,
                                onChanged: _editorCubit.updateDispatchDistrict,
                                bottomSpacing: 0,
                              ),

                              // ── Continue Button ──────────────────────────────────────
                              Padding(
                                padding: const EdgeInsets.only(top: 18),
                                child: AppContinueButton(
                                  text: 'Continue',
                                  isLoading: state.isLoading,
                                  showArrow: false,
                                  onPressed: _handleContinue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────── Add Images Row
  Widget _buildAddImages() {
    return Container(
      width: double.infinity,
      height: 64,
      margin: const EdgeInsets.fromLTRB(18, 33, 15, 16),
      decoration: const BoxDecoration(color: Colors.white),
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
                ..._editorCubit.state.imagePaths.asMap().entries.map((entry) {
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
    final isAsset = imagePath.startsWith('assets/');
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
          child: isAsset
              ? Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFF5F5F5),
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                )
              : Image.file(
                  File(imagePath),
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
