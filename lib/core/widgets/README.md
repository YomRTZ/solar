# Reusable Widgets Guide

This directory contains reusable UI components that can be used across all screens in the application for consistent styling and behavior.

## Available Widgets

### 1. 🎨 AppHeader
A gradient header component with a back button and title text.

**Location:** `lib/core/widgets/app_header.dart`

**Usage:**
```dart
import 'package:flutter_app/core/widgets/app_header.dart';

// Basic usage
const AppHeader(
  title: 'Create Account',
)

// Without back button
const AppHeader(
  title: 'Welcome',
  showBackButton: false,
)

// With custom back action
AppHeader(
  title: 'Profile',
  onBackPressed: () {
    // Custom action
    Navigator.popUntil(context, (route) => route.isFirst);
  },
)
```

**Properties:**
- `title` (required): The heading text to display
- `showBackButton` (optional): Show/hide back button (default: `true`)
- `onBackPressed` (optional): Custom back button action
- `height` (optional): Custom header height (default: `192`)
- `maxContentWidth` (optional): Maximum content width (default: `327`)

---

### 2. 🔘 AppContinueButton
A styled button with an arrow icon, perfect for navigation and form submissions.

**Location:** `lib/core/widgets/app_continue_button.dart`

**Usage:**
```dart
import 'package:flutter_app/core/widgets/app_continue_button.dart';

// Basic usage
AppContinueButton(
  text: 'Continue',
  onPressed: () {
    Navigator.push(context, MaterialPageRoute(...));
  },
)

// With loading state
AppContinueButton(
  text: 'Submitting',
  isLoading: true,
  onPressed: () {},
)

// Without arrow
AppContinueButton(
  text: 'Save',
  showArrow: false,
  onPressed: () {},
)

// Custom colors
AppContinueButton(
  text: 'Delete',
  backgroundColor: Colors.red,
  textColor: Colors.white,
  onPressed: () {},
)
```

**Properties:**
- `text` (required): Button text
- `onPressed` (required): Action when pressed
- `isLoading` (optional): Show loading spinner (default: `false`)
- `width` (optional): Custom width (default: full width)
- `height` (optional): Button height (default: `48`)
- `showArrow` (optional): Display arrow icon (default: `true`)
- `backgroundColor` (optional): Custom background color
- `textColor` (optional): Custom text color

---

### 3. 📝 AppTextField
A text input field with a label, consistent styling, and validation support.

**Location:** `lib/core/widgets/app_text_field.dart`

**Usage:**
```dart
import 'package:flutter_app/core/widgets/app_text_field.dart';

// Basic usage
AppTextField(
  label: 'Email Address',
  hint: 'example@email.com',
  controller: emailController,
)

// With keyboard type
AppTextField(
  label: 'Phone Number',
  hint: '+91 1234567890',
  controller: phoneController,
  keyboardType: TextInputType.phone,
)

// Password field with visibility toggle
AppTextField(
  label: 'Password',
  hint: 'Enter password',
  controller: passwordController,
  obscureText: _obscurePassword,
  suffixIcon: IconButton(
    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
    onPressed: () {
      setState(() => _obscurePassword = !_obscurePassword);
    },
  ),
)

// With validation
AppTextField(
  label: 'Email',
  hint: 'your@email.com',
  controller: emailController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    return null;
  },
)
```

**Properties:**
- `label` (required): Label text above the field
- `hint` (required): Placeholder text
- `controller` (required): TextEditingController
- `keyboardType` (optional): Input type (text, number, email, etc.)
- `obscureText` (optional): Hide text for passwords (default: `false`)
- `suffixIcon` (optional): Icon widget on the right side
- `validator` (optional): Validation function

---

## 🎯 Complete Screen Example

Here's a full example combining all three widgets:

```dart
import 'package:flutter/material.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_continue_button.dart';
import '../../core/widgets/app_text_field.dart';

class MyFormScreen extends StatefulWidget {
  const MyFormScreen({super.key});

  @override
  State<MyFormScreen> createState() => _MyFormScreenState();
}

class _MyFormScreenState extends State<MyFormScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header
            const AppHeader(title: 'Sign Up'),
            const SizedBox(height: 16),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Input fields
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
                    const SizedBox(height: 32),
                    
                    // Submit button
                    AppContinueButton(
                      text: 'Create Account',
                      onPressed: () {
                        // Handle submission
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

## 🎨 Design Consistency

All widgets follow the app's design system:
- **Colors**: Consistent blue gradient header (`#003A8A` to `#000F24`)
- **Typography**: Inter and Plus Jakarta Sans fonts
- **Spacing**: Standard 24px between form elements
- **Border Radius**: 12px for buttons, 10px for inputs
- **Heights**: 48px buttons, 46px input fields, 192px header

## 💡 Benefits

✅ **Consistent UI** - Same look and feel across all screens  
✅ **Easy to maintain** - Update once, changes everywhere  
✅ **Less code** - Reuse instead of copy-paste  
✅ **Type-safe** - Full IDE autocomplete and error checking  
✅ **Customizable** - Override properties as needed  

## 📚 Additional Resources

- See `widgets_usage_example.dart` for more detailed examples
- Check `create_account_screen.dart` for real-world implementation
- All widgets are fully documented with inline comments


---

### 4. 📤 AppFileUploadField
A file upload component with dashed border, upload icon, and file picker functionality.

**Location:** `lib/core/widgets/app_file_upload_field.dart`

**Usage:**
```dart
import 'package:flutter_app/core/widgets/app_file_upload_field.dart';
import 'package:file_picker/file_picker.dart';

// Basic usage
String? selectedFile;

Future<void> _pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'png', 'pdf'],
  );
  
  if (result != null) {
    setState(() {
      selectedFile = result.files.single.name;
    });
  }
}

// In build method
AppFileUploadField(
  label: 'Gst Certificate',
  onTap: _pickFile,
  selectedFileName: selectedFile,
)

// Custom text and file types
AppFileUploadField(
  label: 'Business License',
  selectText: 'Upload document',
  helperText: 'DOC, DOCX or PDF, file size no more than 20MB',
  onTap: _pickFile,
  selectedFileName: selectedFile,
)
```

**Properties:**
- `label` (required): Label text above the upload field
- `onTap` (required): Action when upload area is tapped
- `selectText` (optional): Main text in upload area (default: `"Select a file"`)
- `helperText` (optional): Format and size limit text (default: `"JPG, PNG or PDF, file size no more than 10MB"`)
- `selectedFileName` (optional): Display selected file name
- `maxWidth` (optional): Maximum width (default: `327`)
- `uploadHeight` (optional): Upload area height (default: `53`)

**Required Package:**
Add to `pubspec.yaml`:
```yaml
dependencies:
  file_picker: ^6.0.0  # For file selection
```

---


---

### 5. 🛒 AppProductCard
A product card component with image, title, RFQ number, price, and status badge.

**Location:** `lib/core/widgets/app_product_card.dart`

**Usage:**
```dart
import 'package:flutter_app/core/widgets/app_product_card.dart';

// Product with "New" status (green badge)
AppProductCard.newStatus(
  imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
  title: '10 KW Solar Panel',
  rfqNumber: '#RFQ123456',
  price: '100000',
  onTap: () {
    // Handle tap
  },
)

// Product with "Open" status (blue badge)
AppProductCard.openStatus(
  imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
  title: '5 KW Solar Panel',
  rfqNumber: '#RFQ123456',
  price: '23000',
  onTap: () {
    // Handle tap
  },
)

// Custom status with custom colors
AppProductCard(
  imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
  title: 'Product Name',
  rfqNumber: '#RFQ111222',
  price: '50000',
  statusText: 'Closed',
  statusBackgroundColor: Color(0xFFFFE5E5),
  statusTextColor: Color(0xFFD32F2F),
  onTap: () {
    // Handle tap
  },
)

// Network image
AppProductCard.newStatus(
  imagePath: 'https://example.com/image.jpg',
  title: 'Product Name',
  rfqNumber: '#RFQ333444',
  price: '75000',
  isNetworkImage: true,
)
```

**Properties:**
- `imagePath` (required): Asset path or network URL
- `title` (required): Product name/title
- `rfqNumber` (required): RFQ/reference number
- `price` (required): Price (without "Rs." prefix)
- `statusText` (required): Badge text (e.g., "New", "Open")
- `statusBackgroundColor` (optional): Badge background color
- `statusTextColor` (optional): Badge text color
- `isNetworkImage` (optional): true for network images (default: `false`)
- `onTap` (optional): Callback when card is tapped
- `maxWidth` (optional): Card width (default: `327`)
- `height` (optional): Card height (default: `103`)

**Factory Constructors:**
- `AppProductCard.newStatus()` - Green badge for new items
- `AppProductCard.openStatus()` - Blue badge for open items

**In a ListView:**
```dart
ListView.separated(
  padding: const EdgeInsets.all(18),
  itemCount: products.length,
  separatorBuilder: (context, index) => const SizedBox(height: 16),
  itemBuilder: (context, index) {
    final product = products[index];
    return AppProductCard.newStatus(
      imagePath: product.image,
      title: product.name,
      rfqNumber: product.rfq,
      price: product.price,
      onTap: () => _viewProduct(product),
    );
  },
)
```

---


---

### 6. 🔽 AppDropdownField
A dropdown selection field with the same styling as AppTextField, featuring up/down arrow icons.

**Location:** `lib/core/widgets/app_dropdown_field.dart`

**Usage:**
```dart
import 'package:flutter_app/core/widgets/app_dropdown_field.dart';

// Simple string dropdown
String? selectedBrand;

AppDropdownFieldString(
  label: 'Select Brand',
  hint: 'Choose a brand',
  items: ['Long', 'Havells', 'Luminous', 'Microtek'],
  value: selectedBrand,
  onChanged: (value) {
    setState(() {
      selectedBrand = value;
    });
  },
)

// Custom object dropdown
class Brand {
  final String id;
  final String name;
  Brand(this.id, this.name);
}

Brand? selectedBrand;
List<Brand> brands = [
  Brand('1', 'Long'),
  Brand('2', 'Havells'),
];

AppDropdownField<Brand>(
  label: 'Select Brand',
  hint: 'Choose a brand',
  items: brands,
  itemToString: (brand) => brand.name,
  value: selectedBrand,
  onChanged: (value) {
    setState(() {
      selectedBrand = value;
    });
  },
)

// Disabled dropdown
AppDropdownFieldString(
  label: 'Select Brand',
  hint: 'Choose a brand',
  items: ['Long', 'Havells'],
  value: 'Long',
  onChanged: (value) {},
  enabled: false,
)
```

**Properties:**
- `label` (required): Label text above the dropdown
- `hint` (required): Placeholder text when nothing is selected
- `items` (required): List of options to display
- `onChanged` (required): Callback when selection changes
- `value` (optional): Currently selected value
- `itemToString` (required for generic): Function to convert object to string (AppDropdownField only)
- `validator` (optional): Validation function
- `enabled` (optional): Enable/disable the dropdown (default: `true`)

**Features:**
- ⬇️ Shows down arrow when closed
- ⬆️ Shows up arrow when opened
- Same styling as AppTextField
- Supports both string and custom objects
- Can be enabled/disabled

**In Forms:**
```dart
Column(
  children: [
    AppTextField(
      label: 'Name',
      hint: 'Enter name',
      controller: nameController,
    ),
    const SizedBox(height: 24),
    
    AppDropdownFieldString(
      label: 'Brand',
      hint: 'Select brand',
      items: ['Long', 'Havells'],
      value: selectedBrand,
      onChanged: (value) => setState(() => selectedBrand = value),
    ),
  ],
)
```

---


---

### 7. 📋 AppExpandableCard
An expandable list card with image, title, ID, price, status badge, and right arrow icon.

**Location:** `lib/core/widgets/app_expandable_card.dart`

**Usage:**
```dart
import 'package:flutter_app/core/widgets/app_expandable_card.dart';

// In Stock (green badge)
AppExpandableCard.inStock(
  imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
  title: 'Solar Trade',
  idNumber: '#MB12345',
  price: '11234',
  onTap: () {
    // Handle tap
  },
)

// Low Stock (orange badge)
AppExpandableCard.lowStock(
  imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
  title: 'Solar Panel 5KW',
  idNumber: '#MB12346',
  price: '5000',
  onTap: () {
    // Handle tap
  },
)

// Out of Stock (red badge)
AppExpandableCard.outOfStock(
  imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
  title: 'Solar Panel 10KW',
  idNumber: '#MB12347',
  price: '10000',
  onTap: () {
    // Handle tap
  },
)

// Custom status
AppExpandableCard(
  imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
  title: 'Product Name',
  idNumber: '#ID12345',
  price: '50000',
  statusText: 'Reserved',
  statusBackgroundColor: Color(0xFFE3F2FD),
  statusTextColor: Color(0xFF1976D2),
  onTap: () {},
)
```

**Properties:**
- `imagePath` (required): Asset path or network URL
- `title` (required): Item title/name
- `idNumber` (required): ID/reference number
- `price` (required): Price (without "Rs." prefix)
- `statusText` (required): Status badge text
- `statusBackgroundColor` (optional): Badge background color
- `statusTextColor` (optional): Badge text color
- `isNetworkImage` (optional): true for network images (default: `false`)
- `onTap` (optional): Callback when card is tapped
- `maxWidth` (optional): Card width (default: `327`)
- `height` (optional): Card height (default: `103`)
- `showArrow` (optional): Show/hide arrow (default: `true`)

**Factory Constructors:**
- `AppExpandableCard.inStock()` - Green badge for in-stock items
- `AppExpandableCard.lowStock()` - Orange badge for low stock
- `AppExpandableCard.outOfStock()` - Red badge for out of stock

**In a ListView:**
```dart
ListView(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  children: [
    AppExpandableCard.inStock(
      imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      title: 'Solar Trade',
      idNumber: '#MB12345',
      price: '11234',
      onTap: () => _viewDetails(),
    ),
    AppExpandableCard.lowStock(
      imagePath: 'assets/solarimages/8c95b22c561eba1d7752be96d662579cfd873d93.jpg',
      title: 'Solar Panel',
      idNumber: '#MB12346',
      price: '5000',
      onTap: () => _viewDetails(),
    ),
  ],
)
```

**Features:**
- ➡️ Right-pointing arrow icon (90° rotation)
- Bottom border separator between cards
- Status badge with custom colors
- Automatic image placeholder on error
- Perfect for inventory/stock lists

---
