import 'package:flutter/material.dart';
import 'package:flutter_app/app/routing/app_router.dart';
import 'package:flutter_app/app/routing/app_routes.dart';

/// Demo app to test Company and Bank Details screens
class CompanyBankDemoApp extends StatelessWidget {
  const CompanyBankDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Company & Bank Details Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF003D82)),
        useMaterial3: true,
      ),
      routerConfig: createAppRouter(initialLocation: AppRoutes.companyDemo),
    );
  }
}

/// Run this to test the screens
void main() {
  runApp(const CompanyBankDemoApp());
}
