# Company & Bank Details Screens

Two connected form screens for capturing company and bank information using reusable widgets.

## 📁 Files Structure

```
lib/
└── features/
    ├── company/
    │   ├── company_details_screen.dart   # Company details form
    │   ├── company_bank_demo.dart        # Demo app
    │   └── README.md                     # This file
    └── bank/
        └── bank_details_screen.dart      # Bank details form
```

## 🎯 Features

### Company Details Screen

✅ **6 Input Fields:**
- Company Name
- Email Address
- Address
- Dispatch Location
- Gst Number
- Pan Number

✅ **Features:**
- Blue gradient header
- Form validation
- Auto-navigation to Bank Details
- Uses reusable `AppTextField` widget
- Uses reusable `AppContinueButton` widget

### Bank Details Screen

✅ **4 Input Fields:**
- Account Holder Name
- Account Number
- Ifsc Code
- Bank Name

✅ **Features:**
- Blue gradient header
- Form validation
- Success feedback
- Uses reusable `AppTextField` widget
- Uses reusable `AppContinueButton` widget

## 🚀 Quick Start

### Method 1: Run Demo App

```bash
# From project root
flutter run lib/features/company/company_bank_demo.dart
```

This opens a menu to test either screen individually or follow the flow.

### Method 2: Navigate in Code

```dart
import 'package:flutter_app/features/company/company_details_screen.dart';

// Navigate to Company Details
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const CompanyDetailsScreen(),
  ),
);
```

The Company Details screen automatically navigates to Bank Details when Continue is pressed.

## 🔄 User Flow

```
Company Details Screen
       ↓
  [Fill form]
       ↓
  [Tap Continue]
       ↓
Bank Details Screen
       ↓
  [Fill form]
       ↓
  [Tap Continue]
       ↓
   [Success!]
```

## 🎨 UI Components Used

Both screens use **identical reusable widgets**:

### 1. AppTextField
```dart
AppTextField(
  label: 'Company Name',
  hint: 'Solar Trade',
  controller: companyNameController,
)
```

### 2. AppContinueButton
```dart
AppContinueButton(
  text: 'Continue',
  onPressed: _handleContinue,
)
```

### 3. Custom Header
- Blue gradient background
- Back button (top-left)
- Large title (28px, bold)

## 📝 Form Fields

### Company Details Fields

| Field | Label | Hint | Type |
|-------|-------|------|------|
| 1 | Company Name | Solar Trade | Text |
| 2 | Email Address | Solar@gmail.com | Email |
| 3 | Address | 12-223 Salest, New Delhi | Text |
| 4 | Dispatch Location | 12-223 Salest, New Delhi | Text |
| 5 | Gst Number | 08TGC45879 | Text |
| 6 | Pan Number | 123456789 | Text |

### Bank Details Fields

| Field | Label | Hint | Type |
|-------|-------|------|------|
| 1 | Account Holder Name | Solar Trade | Text |
| 2 | Account Number | 123456789 | Number |
| 3 | Ifsc Code | Hdfc1002 | Text |
| 4 | Bank Name | Hdfc Bank | Text |

## 🔧 Customization

### Change Header Title

```dart
Text(
  'Your Custom Title',  // Change this
  style: GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ),
)
```

### Change Header Colors

```dart
colors: [
  Color(0xFF003A8A),  // Start color
  Color(0xFF000F24),  // End color
]
```

### Add More Fields

```dart
AppTextField(
  label: 'New Field',
  hint: 'Enter value',
  controller: newFieldController,
),
const SizedBox(height: 24),
```

### Change Button Text

```dart
AppContinueButton(
  text: 'Submit',  // Change from 'Continue'
  onPressed: _handleContinue,
)
```

## ✅ Validation

Both screens include form validation:

```dart
void _handleContinue() {
  // Check if any field is empty
  if (companyNameController.text.isEmpty ||
      emailController.text.isEmpty ||
      // ... other fields
  ) {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill all fields'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }
  
  // All fields filled - proceed
  Navigator.push(...);
}
```

## 📱 Screen Flow Examples

### Example 1: Standalone Company Details

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const CompanyDetailsScreen(),
  ),
);
```

### Example 2: Standalone Bank Details

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const BankDetailsScreen(),
  ),
);
```

### Example 3: Sequential Flow (Built-in)

```dart
// Start with Company Details
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const CompanyDetailsScreen(),
  ),
);

// Automatically navigates to Bank Details when Continue is pressed
```

## 💾 Saving Data

Currently, the screens have sample data pre-filled. To save real data:

### Option 1: Pass data to next screen

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BankDetailsScreen(
      companyName: companyNameController.text,
      email: emailController.text,
      // ... other fields
    ),
  ),
);
```

### Option 2: Use state management

```dart
// With Provider
context.read<CompanyProvider>().saveCompanyDetails({
  'name': companyNameController.text,
  'email': emailController.text,
  // ...
});
```

### Option 3: Save to database

```dart
await DatabaseService.saveCompanyDetails({
  'company_name': companyNameController.text,
  'email': emailController.text,
  // ...
});
```

## 🎨 Design Consistency

Both screens follow the same design pattern:

✅ Blue gradient header
✅ Large title (28px)
✅ Back button (top-left)
✅ 24px padding around form
✅ 24px spacing between fields
✅ Continue button at bottom
✅ White background
✅ Same typography (Google Fonts Inter)

## 🔗 Related Widgets

These screens use:

- ✅ `AppTextField` - All input fields
- ✅ `AppContinueButton` - Submit button

Can also integrate:

- `AppDropdownField` - For dropdown selections (e.g., bank names)
- `AppFileUploadField` - For document uploads (e.g., GST certificate)
- `AppHeader` - Alternative header style

## 💡 Best Practices

1. **Always dispose controllers:**
   ```dart
   @override
   void dispose() {
     companyNameController.dispose();
     emailController.dispose();
     super.dispose();
   }
   ```

2. **Use proper keyboard types:**
   ```dart
   keyboardType: TextInputType.emailAddress  // For email
   keyboardType: TextInputType.number        // For account number
   ```

3. **Validate before proceeding:**
   - Check all required fields are filled
   - Validate email format
   - Validate number formats

4. **Provide feedback:**
   - Show loading states
   - Display success/error messages
   - Disable button during submission

5. **Handle navigation properly:**
   - Use Navigator.push for forward navigation
   - Use Navigator.pop to go back
   - Consider using named routes for complex flows

## 🆘 Common Issues

### Issue: TextFields not scrollable

**Solution:** Wrap in `SingleChildScrollView`
```dart
SingleChildScrollView(
  child: Column(
    children: [
      // Your fields here
    ],
  ),
)
```

### Issue: Keyboard covers input

**Solution:** Already handled with `SingleChildScrollView`

### Issue: Back button doesn't work

**Solution:** Check navigation stack
```dart
if (Navigator.canPop(context)) {
  Navigator.pop(context);
}
```

## 🎯 Next Steps

### Recommended Enhancements

1. **Add form validation**
   - Email format validation
   - GST number format validation
   - IFSC code format validation

2. **Add loading states**
   - Show spinner while saving
   - Disable button during submission

3. **Add error handling**
   - Handle network errors
   - Show user-friendly messages

4. **Persist data**
   - Save to local storage
   - Sync with backend API

5. **Add edit functionality**
   - Allow users to edit saved details
   - Show confirmation dialog

## 📚 Additional Resources

- [AppTextField Documentation](../../core/widgets/README.md#apptextfield)
- [AppContinueButton Documentation](../../core/widgets/README.md#appcontinuebutton)
- [Flutter Form Validation](https://docs.flutter.dev/cookbook/forms/validation)

Happy coding! 🚀
