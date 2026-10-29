# Quick Start Guide - Reusable Widgets

## 🚀 Getting Started in 3 Steps

### Step 1: Import the Widgets
Instead of importing each widget separately, use the central export file:

```dart
// ❌ Old way (multiple imports)
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_continue_button.dart';
import '../../core/widgets/app_text_field.dart';

// ✅ New way (single import)
import '../../core/widgets/widgets.dart';
```

### Step 2: Use the Header
Replace your custom header code with:

```dart
const AppHeader(
  title: 'Your Screen Title',
)
```

### Step 3: Use the Continue Button
Replace your custom button with:

```dart
AppContinueButton(
  text: 'Continue',
  onPressed: () {
    // Your action here
  },
)
```

### Step 4: Use Text Fields
Use AppTextField for all input fields:

```dart
AppTextField(
  label: 'Field Label',
  hint: 'Placeholder text',
  controller: yourController,
)
```

---

## 📋 Common Use Cases

### 1️⃣ Login Screen
```dart
import 'package:flutter/material.dart';
import '../../core/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Login'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Email',
                      hint: 'your@email.com',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: 'Password',
                      hint: 'Enter password',
                      controller: passwordController,
                      obscureText: obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => obscurePassword = !obscurePassword);
                        },
                      ),
                    ),
                    const Spacer(),
                    AppContinueButton(
                      text: 'Login',
                      onPressed: () {
                        // Handle login
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
```

---

### 2️⃣ Registration Screen
```dart
import 'package:flutter/material.dart';
import '../../core/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Register'),
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
                    AppTextField(
                      label: 'Phone',
                      hint: '+91 1234567890',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 32),
                    AppContinueButton(
                      text: 'Register',
                      onPressed: () {
                        // Handle registration
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
```

---

### 3️⃣ Settings Screen (No Back Button)
```dart
import 'package:flutter/material.dart';
import '../../core/widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(
              title: 'Settings',
              showBackButton: false,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Your settings items here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎨 Customization Examples

### Custom Button Colors
```dart
AppContinueButton(
  text: 'Delete Account',
  backgroundColor: Colors.red,
  textColor: Colors.white,
  onPressed: () {},
)
```

### Button Without Arrow
```dart
AppContinueButton(
  text: 'Save',
  showArrow: false,
  onPressed: () {},
)
```

### Loading State
```dart
AppContinueButton(
  text: 'Processing',
  isLoading: true,
  onPressed: () {},
)
```

### Custom Back Action
```dart
AppHeader(
  title: 'Checkout',
  onBackPressed: () {
    // Show confirmation dialog
    showDialog(...);
  },
)
```

---

## 📝 Widget Properties Cheat Sheet

### AppHeader
| Property | Type | Required | Default |
|----------|------|----------|---------|
| title | String | ✅ | - |
| showBackButton | bool | ❌ | true |
| onBackPressed | VoidCallback | ❌ | Navigator.pop |
| height | double | ❌ | 192 |
| maxContentWidth | double | ❌ | 327 |

### AppContinueButton
| Property | Type | Required | Default |
|----------|------|----------|---------|
| text | String | ✅ | - |
| onPressed | VoidCallback | ✅ | - |
| isLoading | bool | ❌ | false |
| width | double | ❌ | full width |
| height | double | ❌ | 48 |
| showArrow | bool | ❌ | true |
| backgroundColor | Color | ❌ | #003D82 |
| textColor | Color | ❌ | white |

### AppTextField
| Property | Type | Required | Default |
|----------|------|----------|---------|
| label | String | ✅ | - |
| hint | String | ✅ | - |
| controller | TextEditingController | ✅ | - |
| keyboardType | TextInputType | ❌ | text |
| obscureText | bool | ❌ | false |
| suffixIcon | Widget | ❌ | null |
| validator | Function | ❌ | null |

### AppFileUploadField
| Property | Type | Required | Default |
|----------|------|----------|---------|
| label | String | ✅ | - |
| onTap | VoidCallback | ✅ | - |
| selectText | String | ❌ | "Select a file" |
| helperText | String | ❌ | "JPG, PNG or PDF..." |
| selectedFileName | String | ❌ | null |
| maxWidth | double | ❌ | 327 |
| uploadHeight | double | ❌ | 53 |

### AppProductCard
| Property | Type | Required | Default |
|----------|------|----------|---------|
| imagePath | String | ✅ | - |
| title | String | ✅ | - |
| rfqNumber | String | ✅ | - |
| price | String | ✅ | - |
| statusText | String | ✅ | - |
| statusBackgroundColor | Color | ❌ | #D3F3E1 |
| statusTextColor | Color | ❌ | #217552 |
| isNetworkImage | bool | ❌ | false |
| onTap | VoidCallback | ❌ | null |
| maxWidth | double | ❌ | 327 |
| height | double | ❌ | 103 |

### AppDropdownFieldString
| Property | Type | Required | Default |
|----------|------|----------|---------|
| label | String | ✅ | - |
| hint | String | ✅ | - |
| items | List\<String\> | ✅ | - |
| onChanged | Function | ✅ | - |
| value | String | ❌ | null |
| validator | Function | ❌ | null |
| enabled | bool | ❌ | true |

### AppExpandableCard
| Property | Type | Required | Default |
|----------|------|----------|---------|
| imagePath | String | ✅ | - |
| title | String | ✅ | - |
| idNumber | String | ✅ | - |
| price | String | ✅ | - |
| statusText | String | ✅ | - |
| statusBackgroundColor | Color | ❌ | #D3F3E1 |
| statusTextColor | Color | ❌ | #217552 |
| isNetworkImage | bool | ❌ | false |
| onTap | VoidCallback | ❌ | null |
| showArrow | bool | ❌ | true |

---

## 💡 Pro Tips

1. **Always dispose controllers**: Don't forget to dispose TextEditingController in the dispose() method
2. **Use SafeArea with top: false**: This allows the header gradient to extend to the status bar
3. **Consistent spacing**: Use 24px spacing between form elements
4. **Loading states**: Set isLoading=true on buttons during async operations
5. **Keyboard types**: Use appropriate keyboardType for better UX (email, phone, number)

---

## 🆘 Need Help?

- Check `README.md` for detailed documentation
- See `widgets_usage_example.dart` for comprehensive examples
- Look at `create_account_screen.dart` for a real implementation


---

## 📤 File Upload Widget Usage

### Basic File Upload Example
```dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/widgets/widgets.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  String? gstCertificate;
  String? panCard;

  Future<void> _pickFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        if (type == 'gst') {
          gstCertificate = result.files.single.name;
        } else if (type == 'pan') {
          panCard = result.files.single.name;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Upload Documents'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    AppFileUploadField(
                      label: 'Gst Certificate',
                      onTap: () => _pickFile('gst'),
                      selectedFileName: gstCertificate,
                    ),
                    const SizedBox(height: 24),
                    
                    AppFileUploadField(
                      label: 'Pan Card',
                      onTap: () => _pickFile('pan'),
                      selectedFileName: panCard,
                    ),
                    const Spacer(),
                    
                    AppContinueButton(
                      text: 'Upload Documents',
                      onPressed: () {
                        // Handle upload
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
```

### 📦 Required Package Setup

Add to your `pubspec.yaml`:
```yaml
dependencies:
  file_picker: ^6.0.0
```

Then run:
```bash
flutter pub get
```

### 🍎 iOS Configuration
Add to `ios/Runner/Info.plist`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to select photos</string>
```

### 🤖 Android Configuration
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

---

## 🎯 Complete Form Example (All Widgets)

```dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/widgets/widgets.dart';

class CompleteFormScreen extends StatefulWidget {
  const CompleteFormScreen({super.key});

  @override
  State<CompleteFormScreen> createState() => _CompleteFormScreenState();
}

class _CompleteFormScreenState extends State<CompleteFormScreen> {
  final businessNameController = TextEditingController();
  final emailController = TextEditingController();
  String? gstCertificate;
  bool isLoading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        gstCertificate = result.files.single.name;
      });
    }
  }

  Future<void> _submit() async {
    setState(() => isLoading = true);
    
    // Your API call here
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    businessNameController.dispose();
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
            // 1. Header
            const AppHeader(title: 'Business Registration'),
            
            // 2. Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // 3. Text Fields
                    AppTextField(
                      label: 'Business Name',
                      hint: 'Solar Trade',
                      controller: businessNameController,
                    ),
                    const SizedBox(height: 24),
                    
                    AppTextField(
                      label: 'Email Address',
                      hint: 'business@email.com',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    
                    // 4. File Upload
                    AppFileUploadField(
                      label: 'Gst Certificate',
                      onTap: _pickFile,
                      selectedFileName: gstCertificate,
                    ),
                    const SizedBox(height: 32),
                    
                    // 5. Submit Button
                    AppContinueButton(
                      text: 'Submit',
                      onPressed: _submit,
                      isLoading: isLoading,
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
```

---


---

## 🛒 Product Card Widget Usage

### Simple Product List Example
```dart
import 'package:flutter/material.dart';
import '../../core/widgets/widgets.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Products'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  // New product with green badge
                  AppProductCard.newStatus(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: '10 KW Solar Panel',
                    rfqNumber: '#RFQ123456',
                    price: '100000',
                    onTap: () {
                      print('Product 1 tapped');
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Open product with blue badge
                  AppProductCard.openStatus(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: '5 KW Solar Panel',
                    rfqNumber: '#RFQ123456',
                    price: '23000',
                    onTap: () {
                      print('Product 2 tapped');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Dynamic Product List with Data
```dart
import 'package:flutter/material.dart';
import '../../core/widgets/widgets.dart';

class Product {
  final String image;
  final String title;
  final String rfq;
  final String price;
  final bool isNew;

  Product({
    required this.image,
    required this.title,
    required this.rfq,
    required this.price,
    required this.isNew,
  });
}

class DynamicProductListScreen extends StatelessWidget {
  DynamicProductListScreen({super.key});

  final List<Product> products = [
    Product(
      image: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      title: '10 KW Solar Panel',
      rfq: '#RFQ123456',
      price: '100000',
      isNew: true,
    ),
    Product(
      image: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      title: '5 KW Solar Panel',
      rfq: '#RFQ123457',
      price: '23000',
      isNew: false,
    ),
    Product(
      image: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      title: '15 KW Solar Panel',
      rfq: '#RFQ123458',
      price: '150000',
      isNew: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'All Products'),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(18),
                itemCount: products.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final product = products[index];
                  
                  return product.isNew
                      ? AppProductCard.newStatus(
                          imagePath: product.image,
                          title: product.title,
                          rfqNumber: product.rfq,
                          price: product.price,
                          onTap: () => _viewProduct(context, product),
                        )
                      : AppProductCard.openStatus(
                          imagePath: product.image,
                          title: product.title,
                          rfqNumber: product.rfq,
                          price: product.price,
                          onTap: () => _viewProduct(context, product),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewProduct(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }
}
```

### Custom Status Colors
```dart
// Closed status with red colors
AppProductCard(
  imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
  title: '20 KW Solar Panel',
  rfqNumber: '#RFQ567890',
  price: '200000',
  statusText: 'Closed',
  statusBackgroundColor: const Color(0xFFFFE5E5),
  statusTextColor: const Color(0xFFD32F2F),
  onTap: () {},
)

// Pending status with orange colors
AppProductCard(
  imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
  title: '12 KW Solar Panel',
  rfqNumber: '#RFQ345678',
  price: '120000',
  statusText: 'Pending',
  statusBackgroundColor: const Color(0xFFFFF3E0),
  statusTextColor: const Color(0xFFFF6F00),
  onTap: () {},
)
```

### 💡 Common Status Color Combinations

| Status | Background Color | Text Color |
|--------|------------------|------------|
| New | `Color(0xFFD3F3E1)` | `Color(0xFF217552)` |
| Open | `Color(0xFFC3E1FE)` | `Color(0xFF113CF5)` |
| Closed | `Color(0xFFFFE5E5)` | `Color(0xFFD32F2F)` |
| Pending | `Color(0xFFFFF3E0)` | `Color(0xFFFF6F00)` |
| Hot | `Color(0xFFFFEBEE)` | `Color(0xFFE53935)` |

---


---

## 🔽 Dropdown Field Widget Usage

### Simple Dropdown Example
```dart
import 'package:flutter/material.dart';
import '../../core/widgets/widgets.dart';

class BrandSelectionScreen extends StatefulWidget {
  const BrandSelectionScreen({super.key});

  @override
  State<BrandSelectionScreen> createState() => _BrandSelectionScreenState();
}

class _BrandSelectionScreenState extends State<BrandSelectionScreen> {
  String? selectedBrand;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Select Brand'),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  AppDropdownFieldString(
                    label: 'Select Brand',
                    hint: 'Choose a brand',
                    items: const [
                      'Long',
                      'Havells',
                      'Luminous',
                      'Microtek',
                      'Exide',
                    ],
                    value: selectedBrand,
                    onChanged: (value) {
                      setState(() {
                        selectedBrand = value;
                      });
                      print('Selected: $value');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Mixing Text Fields and Dropdowns
```dart
import 'package:flutter/material.dart';
import '../../core/widgets/widgets.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final nameController = TextEditingController();
  String? selectedBrand;
  String? selectedCapacity;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Product Details'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Text input
                    AppTextField(
                      label: 'Product Name',
                      hint: 'Solar Panel',
                      controller: nameController,
                    ),
                    const SizedBox(height: 24),
                    
                    // Dropdown 1
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
                    
                    // Dropdown 2
                    AppDropdownFieldString(
                      label: 'Capacity',
                      hint: 'Select capacity',
                      items: const ['5 KW', '10 KW', '15 KW', '20 KW'],
                      value: selectedCapacity,
                      onChanged: (value) {
                        setState(() => selectedCapacity = value);
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    // Submit button
                    AppContinueButton(
                      text: 'Submit',
                      onPressed: () {
                        print('Name: ${nameController.text}');
                        print('Brand: $selectedBrand');
                        print('Capacity: $selectedCapacity');
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
```

### Dependent Dropdowns (Cascade Selection)
```dart
import 'package:flutter/material.dart';
import '../../core/widgets/widgets.dart';

class DependentDropdownScreen extends StatefulWidget {
  const DependentDropdownScreen({super.key});

  @override
  State<DependentDropdownScreen> createState() => _DependentDropdownScreenState();
}

class _DependentDropdownScreenState extends State<DependentDropdownScreen> {
  String? selectedCategory;
  String? selectedProduct;

  final Map<String, List<String>> products = {
    'Solar Panels': ['5 KW Panel', '10 KW Panel', '15 KW Panel'],
    'Inverters': ['5 KW Inverter', '10 KW Inverter'],
    'Batteries': ['150 Ah Battery', '200 Ah Battery'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // First dropdown
            AppDropdownFieldString(
              label: 'Category',
              hint: 'Select category',
              items: products.keys.toList(),
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                  selectedProduct = null; // Reset dependent dropdown
                });
              },
            ),
            const SizedBox(height: 24),
            
            // Second dropdown (depends on first)
            AppDropdownFieldString(
              label: 'Product',
              hint: 'Select product',
              items: selectedCategory != null 
                  ? products[selectedCategory]! 
                  : [],
              value: selectedProduct,
              onChanged: selectedCategory != null
                  ? (value) {
                      setState(() => selectedProduct = value);
                    }
                  : null,
              enabled: selectedCategory != null,
            ),
          ],
        ),
      ),
    );
  }
}
```

### 💡 Common Dropdown Patterns

**1. Simple Selection**
```dart
AppDropdownFieldString(
  label: 'Brand',
  hint: 'Choose',
  items: ['Option 1', 'Option 2'],
  value: selected,
  onChanged: (v) => setState(() => selected = v),
)
```

**2. Disabled State**
```dart
AppDropdownFieldString(
  label: 'Brand',
  hint: 'Choose',
  items: ['Option 1'],
  value: 'Option 1',
  onChanged: (v) {},
  enabled: false,
)
```

**3. With All Other Fields**
```dart
Column(
  children: [
    AppTextField(...),           // Text input
    AppDropdownFieldString(...), // Dropdown
    AppFileUploadField(...),     // File upload
    AppContinueButton(...),      // Submit
  ],
)
```

---

## 📝 Field Comparison

| Widget | Use Case | Input Method |
|--------|----------|--------------|
| **AppTextField** | Free text entry | Keyboard |
| **AppDropdownField** | Select from options | Tap & choose |
| **AppFileUploadField** | Upload files | File picker |

All three have **identical label and border styling** for visual consistency! 🎨

---


---

## 📋 Expandable Card Widget Usage

### Simple Inventory List Example
```dart
import 'package:flutter/material.dart';
import '../../core/widgets/widgets.dart';

class InventoryListScreen extends StatelessWidget {
  const InventoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Stock Inventory'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // In Stock - Green
                  AppExpandableCard.inStock(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: 'Solar Trade',
                    idNumber: '#MB12345',
                    price: '11234',
                    onTap: () {
                      print('Item details');
                    },
                  ),
                  
                  // Low Stock - Orange
                  AppExpandableCard.lowStock(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: 'Solar Panel 5KW',
                    idNumber: '#MB12346',
                    price: '5000',
                    onTap: () {
                      print('Low stock alert');
                    },
                  ),
                  
                  // Out of Stock - Red
                  AppExpandableCard.outOfStock(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: 'Solar Panel 10KW',
                    idNumber: '#MB12347',
                    price: '10000',
                    onTap: () {
                      print('Out of stock');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Dynamic List with Navigation
```dart
import 'package:flutter/material.dart';
import '../../core/widgets/widgets.dart';

class Product {
  final String image;
  final String title;
  final String id;
  final String price;
  final String status;

  Product({
    required this.image,
    required this.title,
    required this.id,
    required this.price,
    required this.status,
  });
}

class DynamicInventoryScreen extends StatelessWidget {
  DynamicInventoryScreen({super.key});

  final List<Product> products = [
    Product(
      image: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      title: 'Solar Trade',
      id: '#MB12345',
      price: '11234',
      status: 'in_stock',
    ),
    Product(
      image: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      title: '5KW Panel',
      id: '#MB12346',
      price: '5000',
      status: 'low_stock',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Products'),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  
                  if (product.status == 'in_stock') {
                    return AppExpandableCard.inStock(
                      imagePath: product.image,
                      title: product.title,
                      idNumber: product.id,
                      price: product.price,
                      onTap: () => _navigateToDetails(context, product),
                    );
                  } else if (product.status == 'low_stock') {
                    return AppExpandableCard.lowStock(
                      imagePath: product.image,
                      title: product.title,
                      idNumber: product.id,
                      price: product.price,
                      onTap: () => _navigateToDetails(context, product),
                    );
                  } else {
                    return AppExpandableCard.outOfStock(
                      imagePath: product.image,
                      title: product.title,
                      idNumber: product.id,
                      price: product.price,
                      onTap: () => _navigateToDetails(context, product),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }
}
```

### 💡 Status Badge Colors

| Status | Background Color | Text Color | Factory Method |
|--------|------------------|------------|----------------|
| In Stock | `#D3F3E1` 🟢 | `#217552` | `.inStock()` |
| Low Stock | `#FFF3E0` 🟠 | `#FF6F00` | `.lowStock()` |
| Out of Stock | `#FFE5E5` 🔴 | `#D32F2F` | `.outOfStock()` |

### Custom Status Example
```dart
AppExpandableCard(
  imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
  title: 'Premium Product',
  idNumber: '#PREM001',
  price: '99999',
  statusText: 'Premium',
  statusBackgroundColor: Color(0xFFFFF3E0),
  statusTextColor: Color(0xFFFF6F00),
  onTap: () {},
)
```

---

## 🎨 All Reusable Widgets Summary

You now have **7 powerful reusable widgets**:

1. **AppHeader** - Gradient header with back button
2. **AppContinueButton** - Action button with arrow
3. **AppTextField** - Text input field
4. **AppDropdownField** - Selection dropdown
5. **AppFileUploadField** - File upload with dashed border
6. **AppProductCard** - Product card with image & badge
7. **AppExpandableCard** - Inventory card with status (NEW!)

All widgets are:
- ✅ Fully documented
- ✅ Consistent styling
- ✅ Easy to customize
- ✅ Ready to use across all screens

---
