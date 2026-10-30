/// REUSABLE WIDGETS USAGE GUIDE
/// 
/// This file demonstrates how to use the reusable widgets across different screens
/// DO NOT import this file - it's just for reference!
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/core/widgets/app_header.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/app_text_field.dart';

/// Example 1: Using AppHeader with different titles
class ExampleScreen1 extends StatelessWidget {
  const ExampleScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Simple usage with just title
          const AppHeader(
            title: 'Sign In',
          ),
          // Your other content here
        ],
      ),
    );
  }
}

/// Example 2: Using AppHeader without back button
class ExampleScreen2 extends StatelessWidget {
  const ExampleScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(
            title: 'Welcome',
            showBackButton: false,
          ),
          // Your other content here
        ],
      ),
    );
  }
}

/// Example 3: Using AppHeader with custom back action
class ExampleScreen3 extends StatelessWidget {
  const ExampleScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            title: 'Settings',
            onBackPressed: () {
              // Custom back action
              debugPrint('Custom back action');
              Navigator.pop(context);
            },
          ),
          // Your other content here
        ],
      ),
    );
  }
}

/// Example 4: Using AppContinueButton with different texts
class ExampleScreen4 extends StatelessWidget {
  const ExampleScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Continue button
            AppContinueButton(
              text: 'Continue',
              onPressed: () {
                // Navigate to next screen
                debugPrint('Continued');
              },
            ),
            const SizedBox(height: 16),
            
            // Next button
            AppContinueButton(
              text: 'Next',
              onPressed: () {
                debugPrint('Next pressed');
              },
            ),
            const SizedBox(height: 16),
            
            // Submit button
            AppContinueButton(
              text: 'Submit',
              onPressed: () {
                debugPrint('Submitted');
              },
            ),
            const SizedBox(height: 16),
            
            // Loading state
            const AppContinueButton(
              text: 'Processing',
              onPressed: null,
              isLoading: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 5: Using AppContinueButton without arrow
class ExampleScreen5 extends StatelessWidget {
  const ExampleScreen5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AppContinueButton(
              text: 'Save',
              showArrow: false,
              onPressed: () {
                debugPrint('Saved');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 6: Using AppContinueButton with custom colors
class ExampleScreen6 extends StatelessWidget {
  const ExampleScreen6({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AppContinueButton(
              text: 'Danger Action',
              backgroundColor: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                debugPrint('Danger action');
              },
            ),
            const SizedBox(height: 16),
            
            AppContinueButton(
              text: 'Success',
              backgroundColor: Colors.green,
              onPressed: () {
                debugPrint('Success');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 7: Using AppTextField with different configurations
class ExampleScreen7 extends StatefulWidget {
  const ExampleScreen7({super.key});

  @override
  State<ExampleScreen7> createState() => _ExampleScreen7State();
}

class _ExampleScreen7State extends State<ExampleScreen7> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Simple text field
            AppTextField(
              label: 'Email Address',
              hint: 'enter your email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            
            // Password field with visibility toggle
            AppTextField(
              label: 'Password',
              hint: 'enter your password',
              controller: passwordController,
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            
            // Phone number field
            AppTextField(
              label: 'Phone Number',
              hint: '+91 9876543210',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 8: Complete screen using all three widgets
class CompleteExampleScreen extends StatefulWidget {
  const CompleteExampleScreen({super.key});

  @override
  State<CompleteExampleScreen> createState() => _CompleteExampleScreenState();
}

class _CompleteExampleScreenState extends State<CompleteExampleScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
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
            // Header with custom title
            const AppHeader(
              title: 'Contact Us',
            ),
            const SizedBox(height: 16),
            
            // Scrollable content
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
                      label: 'Email Address',
                      hint: 'john@example.com',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    
                    AppTextField(
                      label: 'Message',
                      hint: 'Type your message here',
                      controller: messageController,
                    ),
                    const SizedBox(height: 32),
                    
                    // Continue button
                    AppContinueButton(
                      text: 'Send Message',
                      onPressed: () {
                        // Handle form submission
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

/* 
SUMMARY OF REUSABLE WIDGETS:

1. AppHeader - Gradient header with back button
   - title: String (required) - The header title
   - showBackButton: bool (optional) - Show/hide back button (default: true)
   - onBackPressed: VoidCallback (optional) - Custom back action
   - height: double (optional) - Header height (default: 192)
   - maxContentWidth: double (optional) - Max width (default: 327)

2. AppContinueButton - Styled button with arrow icon
   - text: String (required) - Button text
   - onPressed: VoidCallback (required) - Action on press
   - isLoading: bool (optional) - Show loading indicator (default: false)
   - width: double (optional) - Custom width (default: full width)
   - height: double (optional) - Custom height (default: 48)
   - showArrow: bool (optional) - Show arrow icon (default: true)
   - backgroundColor: Color (optional) - Custom background color
   - textColor: Color (optional) - Custom text color

3. AppTextField - Input field with label
   - label: String (required) - Field label
   - hint: String (required) - Placeholder text
   - controller: TextEditingController (required)
   - keyboardType: TextInputType (optional)
   - obscureText: bool (optional) - Hide text for passwords
   - suffixIcon: Widget (optional) - Icon at the end
   - validator: Function (optional) - Validation function
*/
