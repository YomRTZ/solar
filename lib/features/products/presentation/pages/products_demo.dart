import 'package:flutter/material.dart';
import 'package:flutter_app/features/products/presentation/pages/my_products_screen.dart';

/// Demo app to test the My Products screen
class ProductsDemoApp extends StatelessWidget {
  const ProductsDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Products Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF003D82)),
        useMaterial3: true,
      ),
      home: const MyProductsScreen(),
    );
  }
}

/// Run this to test the products screen
void main() {
  runApp(const ProductsDemoApp());
}
