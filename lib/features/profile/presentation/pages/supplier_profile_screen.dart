import 'package:flutter/material.dart';

import 'package:flutter_app/features/profile/presentation/pages/profile_screen.dart';

class SupplierProfileScreen extends StatelessWidget {
  const SupplierProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen(showSupplierActions: true);
  }
}
