import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/app_form_section.dart';
import 'package:flutter_app/core/widgets/app_text_field.dart';
import 'package:flutter_app/core/validation/app_form_validation.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/orders/data/datasources/order_dispatch_updates.dart';
import 'package:flutter_app/features/orders/data/datasources/orders_data.dart';
import 'package:flutter_app/features/orders/domain/entities/order.dart';
import 'package:flutter_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderStatusUpdateScreen extends StatefulWidget {
  final Order order;

  const OrderStatusUpdateScreen({super.key, required this.order});

  @override
  State<OrderStatusUpdateScreen> createState() =>
      _OrderStatusUpdateScreenState();
}

class _OrderStatusUpdateScreenState extends State<OrderStatusUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  static const _addImageAsset =
      'assets/icons/5ceff9d5d9cae078a369c65ead35be73405d7dcd.png';
  late final TextEditingController _transporterController;
  late final TextEditingController _trackingNumberController;
  late final TextEditingController _dispatchDateController;
  late final OrderDispatchFormCubit _dispatchCubit;

  @override
  void initState() {
    super.initState();
    final update = OrderDispatchUpdates.forOrder(widget.order.id);
    _transporterController = TextEditingController(
      text: update?.transporter ?? 'Ekart',
    );
    _trackingNumberController = TextEditingController(
      text: update?.trackingNumber ?? '12,340',
    );
    _dispatchDateController = TextEditingController(
      text: update?.dispatchDate ?? '20 Oct 2026',
    );
    _dispatchCubit = OrderDispatchFormCubit(
      initialState: OrderDispatchFormState(
        transporter: _transporterController.text,
        trackingNumber: _trackingNumberController.text,
        dispatchDate: _dispatchDateController.text,
        proofImageAssetPath: update?.proofImageAssetPath ?? _addImageAsset,
        proofImageBytes: update?.proofImageBytes,
      ),
    );
  }

  @override
  void dispose() {
    _transporterController.dispose();
    _trackingNumberController.dispose();
    _dispatchDateController.dispose();
    _dispatchCubit.close();
    super.dispose();
  }

  Future<void> _addProofImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (!mounted) return;
      _dispatchCubit.setProofImage(bytes);
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
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final currentOrder = OrdersData.getById(widget.order.id) ?? widget.order;
    if (currentOrder.status == OrderStatus.delivered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This order has already been delivered.')),
      );
      return;
    }
    OrderDispatchUpdates.save(
      widget.order.id,
      OrderDispatchUpdate(
        transporter: _dispatchCubit.state.transporter.trim(),
        trackingNumber: _dispatchCubit.state.trackingNumber.trim(),
        dispatchDate: _dispatchCubit.state.dispatchDate.trim(),
        proofImageAssetPath: _dispatchCubit.state.proofImageAssetPath,
        proofImageBytes: _dispatchCubit.state.proofImageBytes,
      ),
    );
    OrdersData.updateStatus(widget.order.id, OrderStatus.dispatched);
    context.go(AppRoutes.orders);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDispatchFormCubit, OrderDispatchFormState>(
      bloc: _dispatchCubit,
      builder: (context, state) => AnnotatedRegion<SystemUiOverlayStyle>(
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
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 32),
                  child: Form(
                    key: _formKey,
                    child: AppFormSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            label: 'Transporter',
                            hint: 'Ekart',
                            controller: _transporterController,
                            onChanged: _dispatchCubit.setTransporter,
                          ),
                          AppTextField(
                            label: 'Tracking Number',
                            hint: '12,340',
                            controller: _trackingNumberController,
                            onChanged: _dispatchCubit.setTrackingNumber,
                          ),
                          AppTextField(
                            label: 'Dispatch Date',
                            hint: '20 Oct 2026',
                            controller: _dispatchDateController,
                            onChanged: _dispatchCubit.setDispatchDate,
                          ),
                          _buildProofImageSection(state),
                          Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: AppContinueButton(
                              text: 'Mark As Dispatched',
                              showArrow: false,
                              onPressed: _markAsDispatched,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProofImageSection(OrderDispatchFormState state) {
    final hasProof =
        state.proofImageAssetPath != null || state.proofImageBytes != null;
    return FormField<bool>(
      key: ValueKey('proof:$hasProof'),
      initialValue: hasProof,
      validator: (value) => AppFormValidation.requiredSelection(
        value == true ? value : null,
        fieldName: 'Proof of dispatch',
      ),
      builder: (field) => Column(
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
                    child: state.proofImageBytes != null
                        ? Image.memory(
                            state.proofImageBytes!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            state.proofImageAssetPath!,
                            fit: BoxFit.cover,
                          ),
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
          if (field.errorText != null) AppFormErrorText(field.errorText!),
        ],
      ),
    );
  }
}
