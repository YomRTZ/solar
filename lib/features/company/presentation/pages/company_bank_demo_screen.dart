import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';

class DemoHomeScreen extends StatelessWidget {
  const DemoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Screens'),
        backgroundColor: const Color(0xFF003A8A),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.push(AppRoutes.companyDetails),
                style: _buttonStyle,
                child: const Text(
                  'Company Details Screen',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.push(AppRoutes.bankDetails),
                style: _buttonStyle,
                child: const Text(
                  'Bank Details Screen',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Flow: Company Details → Bank Details',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF003D82),
  foregroundColor: Colors.white,
  minimumSize: const Size(double.infinity, 56),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);
