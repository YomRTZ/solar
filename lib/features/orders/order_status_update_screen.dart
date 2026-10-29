import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/widgets/app_continue_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/second_app_header.dart';
import '../../data/order_dispatch_updates.dart';
import '../../models/order.dart';

class OrderStatusUpdateScreen extends StatefulWidget {
  final Order order;

  const OrderStatusUpdateScreen({super.key, required this.order});

  @override
  State<OrderStatusUpdateScreen> createState() =>
      _OrderStatusUpdateScreenState();
}

class _OrderStatusUpdateScreenState extends State<OrderStatusUpdateScreen> {
  static const _addImageAsset =
      'assets/images/icons/5ceff9d5d9cae078a369c65ead35be73405d7dcd.png';
  static const _proofImageAsset =
      'assets/images/solarimages/03f133a91b6e5ade2638722f368e27d2f92f051b.png';

  final _transporterController = TextEditingController(text: 'Ekart');
  final _trackingNumberController = TextEditingController(text: '12,340');
  final _dispatchDateController = TextEditingController(text: '20 Oct 2026');
  String? _proofImageAssetPath = _proofImageAsset;
  Uint8List? _proofImageBytes;

  @override
  void dispose() {
    _transporterController.dispose();
    _trackingNumberController.dispose();
    _dispatchDateController.dispose();
    super.dispose();
  }

  Future<void> _addProofImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() {
        _proofImageAssetPath = null;
        _proofImageBytes = bytes;
      });
    } on PlatformException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Unable to select a proof image.'),
        ),
      );
    }
  }

  void _markAsDispatched() {
    if (_transporterController.text.trim().isEmpty ||
        _trackingNumberController.text.trim().isEmpty ||
        _dispatchDateController.text.trim().isEmpty ||
        (_proofImageAssetPath == null && _proofImageBytes == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all dispatch details.')),
      );
      return;
    }

    OrderDispatchUpdates.save(
      widget.order.id,
      OrderDispatchUpdate(
        transporter: _transporterController.text.trim(),
        trackingNumber: _trackingNumberController.text.trim(),
        dispatchDate: _dispatchDateController.text.trim(),
        proofImageAssetPath: _proofImageAssetPath,
        proofImageBytes: _proofImageBytes,
      ),
    );

    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SecondAppHeader(
              title: 'Update Status',
              onBackPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Transporter',
                      hint: 'Ekart',
                      controller: _transporterController,
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      label: 'Tracking Number',
                      hint: '12,340',
                      controller: _trackingNumberController,
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      label: 'Dispatch Date',
                      hint: '20 Oct 2026',
                      controller: _dispatchDateController,
                    ),
                    const SizedBox(height: 20),
                    _buildProofImageSection(),
                    const SizedBox(height: 32),
                    AppContinueButton(
                      text: 'Mark As Dispatched',
                      showArrow: false,
                      onPressed: _markAsDispatched,
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

  Widget _buildProofImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Proof of dispatch',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            height: 1.6,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.24,
            color: const Color(0xFF6C7278),
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: 41,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                  width: 41,
                  height: 41,
                  child: _proofImageBytes != null
                      ? Image.memory(_proofImageBytes!, fit: BoxFit.cover)
                      : Image.asset(_proofImageAssetPath!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _addProofImage,
                child: Image.asset(
                  _addImageAsset,
                  width: 41,
                  height: 41,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
