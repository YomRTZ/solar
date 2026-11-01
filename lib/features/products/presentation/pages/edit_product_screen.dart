import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/widgets/app_text_field.dart';
import 'package:flutter_app/core/widgets/app_dropdown_field.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/app_form_section.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/products/data/datasources/products_data.dart';
import 'package:flutter_app/features/products/domain/entities/product.dart';
import 'package:flutter_app/features/products/presentation/cubit/product_editor_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProductScreen extends StatefulWidget {
  // Pass an existing product to pre-fill the form. If null, fields start empty.
  final Product? product;

  const EditProductScreen({super.key, this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  // Controllers
  late final TextEditingController _productNameController;
  late final TextEditingController _modelNumberController;
  late final TextEditingController _priceController;
  late final TextEditingController _taxAmountController;
  late final TextEditingController _minOrderQtyController;
  late final TextEditingController _warrantyController;
  late final TextEditingController _dispatchDistController;

  late final ProductEditorCubit _editorCubit;

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
    _taxAmountController = TextEditingController(
      text: p?.taxAmount.isNotEmpty == true ? p!.taxAmount : '12',
    );
    _minOrderQtyController = TextEditingController(
      text: p?.minimumOrderQuantity.isNotEmpty == true
          ? p!.minimumOrderQuantity
          : '12',
    );
    _warrantyController = TextEditingController(
      text: p?.warranty.isNotEmpty == true ? p!.warranty : '09/2026',
    );
    _dispatchDistController = TextEditingController(
      text: p?.dispatchDistrict.isNotEmpty == true
          ? p!.dispatchDistrict
          : 'New Delhi',
    );

    _editorCubit = ProductEditorCubit(
      initialState: ProductEditorState(
        productName: _productNameController.text,
        modelNumber: _modelNumberController.text,
        price: _priceController.text,
        taxAmount: _taxAmountController.text,
        minimumOrderQuantity: _minOrderQtyController.text,
        warranty: _warrantyController.text,
        dispatchDistrict: _dispatchDistController.text,
        category: p != null ? _categoryFromEnum(p.category) : 'Panel',
        brand: p?.brand.isNotEmpty == true ? p!.brand : 'Long',
        stock: p != null ? _stockFromEnum(p.status) : 'In Stock',
        imagePaths: [p?.imagePath ?? ProductsData.defaultImagePath],
        showSuccessBanner: false,
        isUpdated: false,
      ),
    );
  }

  String _categoryFromEnum(ProductCategory cat) {
    switch (cat) {
      case ProductCategory.panel:
        return 'Panel';
      case ProductCategory.battery:
        return 'Battery';
      case ProductCategory.inverter:
        return 'Inverter';
      case ProductCategory.controller:
        return 'Controller';
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
    _scrollController.dispose();
    _editorCubit.close();
    super.dispose();
  }

  void _handleContinue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_editorCubit.state.isUpdated) {
      // ── First click: "Update" ──────────────────────────
      // Show loading, then display the success banner and switch button to "Continue"
      _editorCubit.setLoading(true);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      _editorCubit.setLoading(false);
      final state = _editorCubit.state;
      final modelNumber = state.modelNumber.trim().replaceFirst(
        RegExp(r'^#'),
        '',
      );
      final updatedProduct = Product(
        id:
            widget.product?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
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
      );
      if (widget.product == null) {
        ProductsData.addProduct(updatedProduct);
      } else {
        ProductsData.updateProduct(updatedProduct);
      }
      _editorCubit.markUpdated();
      _editorCubit.setSuccessBanner(true);
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted || !_scrollController.hasClients) return;
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      // ── Second click: "Continue" ──────────────────────
      // Proceed back to the previous screen
      if (mounted) Navigator.pop(context, true);
    }
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
              const SecondAppHeader(title: 'Edit Product'),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.showSuccessBanner) ...[
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 12, 18, 16),
                          child: _buildSuccessBanner(),
                        ),
                      ],
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
                                onChanged: _editorCubit.updatePrice,
                                keyboardType: TextInputType.number,
                              ),

                              // ── Tax Amount ───────────────────────────────────────────
                              AppTextField(
                                label: 'Tax Amount',
                                hint: '12',
                                controller: _taxAmountController,
                                onChanged: _editorCubit.updateTaxAmount,
                                keyboardType: TextInputType.number,
                              ),

                              // ── Min Order Qty ────────────────────────────────────────
                              AppTextField(
                                label: 'Min Order Qty',
                                hint: '12',
                                controller: _minOrderQtyController,
                                onChanged:
                                    _editorCubit.updateMinimumOrderQuantity,
                                keyboardType: TextInputType.number,
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
                                  text: state.isUpdated ? 'Continue' : 'Update',
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

  // ──────────────────────────────────────────────────────────── Success Banner
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/icons/green-check-icon.svg',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 248,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Updated!',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          height: 1,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
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
                          letterSpacing: 0,
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
            top: 28,
            right: 22,
            child: GestureDetector(
              onTap: () => _editorCubit.setSuccessBanner(false),
              child: SvgPicture.asset(
                'assets/icons/cross-icon.svg',
                width: 9.096354484558105,
                height: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
