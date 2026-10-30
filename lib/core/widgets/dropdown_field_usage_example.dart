// DROPDOWN FIELD WIDGET USAGE EXAMPLES This file demonstrates how to use the AppDropdownField
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/core/widgets/app_dropdown_field.dart';
import 'package:flutter_app/core/widgets/app_text_field.dart';
import 'package:flutter_app/core/widgets/app_header.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';

// Example 1: Simple String Dropdown
class SimpleDropdownExample extends StatefulWidget {
  const SimpleDropdownExample({super.key});

  @override
  State<SimpleDropdownExample> createState() => _SimpleDropdownExampleState();
}

class _SimpleDropdownExampleState extends State<SimpleDropdownExample> {
  String? selectedBrand;

  final List<String> brands = [
    'Long',
    'Havells',
    'Luminous',
    'Microtek',
    'Exide',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppDropdownFieldString(
              label: 'Select Brand',
              hint: 'Choose a brand',
              items: brands,
              value: selectedBrand,
              onChanged: (value) {
                setState(() {
                  selectedBrand = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Example 2: Multiple Dropdowns in a Form
class MultipleDropdownFormExample extends StatefulWidget {
  const MultipleDropdownFormExample({super.key});

  @override
  State<MultipleDropdownFormExample> createState() =>
      _MultipleDropdownFormExampleState();
}

class _MultipleDropdownFormExampleState
    extends State<MultipleDropdownFormExample> {
  String? selectedBrand;
  String? selectedCapacity;
  String? selectedType;

  final List<String> brands = ['Long', 'Havells', 'Luminous', 'Microtek'];
  final List<String> capacities = ['5 KW', '10 KW', '15 KW', '20 KW'];
  final List<String> types = ['Monocrystalline', 'Polycrystalline', 'Thin Film'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Solar Panel Details'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    AppDropdownFieldString(
                      label: 'Select Brand',
                      hint: 'Choose a brand',
                      items: brands,
                      value: selectedBrand,
                      onChanged: (value) {
                        setState(() {
                          selectedBrand = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    AppDropdownFieldString(
                      label: 'Capacity',
                      hint: 'Select capacity',
                      items: capacities,
                      value: selectedCapacity,
                      onChanged: (value) {
                        setState(() {
                          selectedCapacity = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    AppDropdownFieldString(
                      label: 'Panel Type',
                      hint: 'Choose type',
                      items: types,
                      value: selectedType,
                      onChanged: (value) {
                        setState(() {
                          selectedType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    AppContinueButton(
                      text: 'Continue',
                      onPressed: () {
                        debugPrint('Brand: $selectedBrand');
                        debugPrint('Capacity: $selectedCapacity');
                        debugPrint('Type: $selectedType');
                      },
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
}

// Example 3: Mixing Text Fields and Dropdowns
class MixedFormExample extends StatefulWidget {
  const MixedFormExample({super.key});

  @override
  State<MixedFormExample> createState() => _MixedFormExampleState();
}

class _MixedFormExampleState extends State<MixedFormExample> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  String? selectedBrand;
  String? selectedCapacity;

  final List<String> brands = ['Long', 'Havells', 'Luminous'];
  final List<String> capacities = ['5 KW', '10 KW', '15 KW'];

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Product Order'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Text field
                    AppTextField(
                      label: 'Product Name',
                      hint: 'Solar Panel',
                      controller: nameController,
                    ),
                    const SizedBox(height: 24),
                    
                    // Dropdown field
                    AppDropdownFieldString(
                      label: 'Select Brand',
                      hint: 'Choose a brand',
                      items: brands,
                      value: selectedBrand,
                      onChanged: (value) {
                        setState(() {
                          selectedBrand = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Dropdown field
                    AppDropdownFieldString(
                      label: 'Capacity',
                      hint: 'Select capacity',
                      items: capacities,
                      value: selectedCapacity,
                      onChanged: (value) {
                        setState(() {
                          selectedCapacity = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Text field
                    AppTextField(
                      label: 'Quantity',
                      hint: '10',
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 32),
                    
                    AppContinueButton(
                      text: 'Submit Order',
                      onPressed: () {
                        debugPrint('Order submitted');
                      },
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
}

// Example 4: Custom Object Dropdown
class CustomObjectDropdownExample extends StatefulWidget {
  const CustomObjectDropdownExample({super.key});

  @override
  State<CustomObjectDropdownExample> createState() =>
      _CustomObjectDropdownExampleState();
}

class Brand {
  final String id;
  final String name;
  final String country;

  Brand({required this.id, required this.name, required this.country});
}

class _CustomObjectDropdownExampleState
    extends State<CustomObjectDropdownExample> {
  Brand? selectedBrand;

  final List<Brand> brands = [
    Brand(id: '1', name: 'Long', country: 'India'),
    Brand(id: '2', name: 'Havells', country: 'India'),
    Brand(id: '3', name: 'Luminous', country: 'India'),
    Brand(id: '4', name: 'Microtek', country: 'India'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppDropdownField<Brand>(
              label: 'Select Brand',
              hint: 'Choose a brand',
              items: brands,
              itemToString: (brand) => '${brand.name} (${brand.country})',
              value: selectedBrand,
              onChanged: (value) {
                setState(() {
                  selectedBrand = value;
                });
                debugPrint('Selected: ${value?.id} - ${value?.name}');
              },
            ),
            const SizedBox(height: 24),
            
            if (selectedBrand != null)
              Text(
                'Selected: ${selectedBrand!.name} from ${selectedBrand!.country}',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}

// Example 5: Disabled Dropdown
class DisabledDropdownExample extends StatelessWidget {
  const DisabledDropdownExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppDropdownFieldString(
              label: 'Select Brand',
              hint: 'Choose a brand',
              items: const ['Long', 'Havells'],
              value: 'Long',
              onChanged: (value) {},
              enabled: false, // Disabled dropdown
            ),
          ],
        ),
      ),
    );
  }
}

// Example 6: Dependent Dropdowns
class DependentDropdownsExample extends StatefulWidget {
  const DependentDropdownsExample({super.key});

  @override
  State<DependentDropdownsExample> createState() =>
      _DependentDropdownsExampleState();
}

class _DependentDropdownsExampleState extends State<DependentDropdownsExample> {
  String? selectedCategory;
  String? selectedProduct;

  final Map<String, List<String>> categoryProducts = {
    'Solar Panels': ['5 KW Panel', '10 KW Panel', '15 KW Panel'],
    'Inverters': ['5 KW Inverter', '10 KW Inverter'],
    'Batteries': ['150 Ah Battery', '200 Ah Battery'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Select Product'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Category dropdown
                    AppDropdownFieldString(
                      label: 'Category',
                      hint: 'Select category',
                      items: categoryProducts.keys.toList(),
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                          selectedProduct = null; // Reset product
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Product dropdown (depends on category)
                    AppDropdownFieldString(
                      label: 'Product',
                      hint: 'Select product',
                      items: selectedCategory != null
                          ? categoryProducts[selectedCategory]!
                          : [],
                      value: selectedProduct,
                      onChanged: selectedCategory != null
                          ? (value) {
                              setState(() {
                                selectedProduct = value;
                              });
                            }
                          : null,
                      enabled: selectedCategory != null,
                    ),
                    const Spacer(),
                    
                    AppContinueButton(
                      text: 'Continue',
                      onPressed: selectedCategory != null && selectedProduct != null
                          ? () {
                              debugPrint('Category: $selectedCategory');
                              debugPrint('Product: $selectedProduct');
                            }
                          : () {},
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
}

// Example 7: Complete Form with All Field Types
class CompleteFormExample extends StatefulWidget {
  const CompleteFormExample({super.key});

  @override
  State<CompleteFormExample> createState() => _CompleteFormExampleState();
}

class _CompleteFormExampleState extends State<CompleteFormExample> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? selectedBrand;
  String? selectedCapacity;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Complete Form'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Full Name',
                      hint: 'John Doe',
                      controller: nameController,
                    ),
                    const SizedBox(height: 24),
                    
                    AppTextField(
                      label: 'Email',
                      hint: 'john@example.com',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    
                    AppDropdownFieldString(
                      label: 'Select Brand',
                      hint: 'Choose a brand',
                      items: const ['Long', 'Havells', 'Luminous'],
                      value: selectedBrand,
                      onChanged: (value) {
                        setState(() => selectedBrand = value);
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    AppDropdownFieldString(
                      label: 'Capacity',
                      hint: 'Select capacity',
                      items: const ['5 KW', '10 KW', '15 KW'],
                      value: selectedCapacity,
                      onChanged: (value) {
                        setState(() => selectedCapacity = value);
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    AppContinueButton(
                      text: 'Submit',
                      onPressed: () {
                        debugPrint('Form submitted');
                      },
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
}

// SUMMARY: AppDropdownFieldString (for String values)
