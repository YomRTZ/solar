import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/create_account_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/otp_verification_screen.dart';
import '../../features/bank/bank_details_screen.dart';
import '../../features/catalog/all_products_screen.dart';
import '../../features/company/company_bank_demo_screen.dart';
import '../../features/company/company_details_screen.dart';
import '../../features/documents/upload_documents_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/orders/order_details_screen.dart';
import '../../features/orders/order_status_update_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/orders/track_status_screen.dart';
import '../../features/plan/choose_plan_screen.dart';
import '../../features/products/add_product_screen.dart';
import '../../features/products/edit_product_screen.dart';
import '../../features/products/my_products_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/tender_profile_screen.dart';
import '../../features/profile/update_profile_screen.dart';
import '../../features/rfq/rfq_detail_screen.dart';
import '../../features/rfq/rfq_requests_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/tender/addtender_checkout_screen.dart';
import '../../features/tender/addtender_payment_status_screen.dart';
import '../../features/tender/addtender_rfq_requests_screen.dart';
import '../../features/tender/advtender_rfq_cart_screen.dart';
import '../../features/tender/advtender_rfq_status_screen.dart';
import '../../features/tender/advtender_supplier_details_screen.dart';
import '../../features/tender/tender_all_categories_screen.dart';
import '../../features/tender/tender_all_products_screen.dart';
import '../../features/tender/tender_home_screen.dart';
import '../../features/tender/tender_main_screen.dart';
import '../../features/terms/addtender_terms_of_service_screen.dart';
import '../../features/terms/terms_of_service_screen.dart';
import '../../features/verification/verification_status_screen.dart';
import '../../features/wallet/my_wallet_screen.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../models/rfq.dart';
import 'app_routes.dart';
import 'route_data.dart';

final GoRouter appRouter = createAppRouter();

GoRouter createAppRouter({String initialLocation = AppRoutes.splash}) {
  late final GoRouter router;
  router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      _route(AppRoutes.splash, (_) => const SplashScreen()),
      _route(AppRoutes.login, (_) => const LoginScreen()),
      _route(AppRoutes.otpVerification, (state) {
        final data = _requiredExtra<OtpRouteData>(state);
        return OtpVerificationScreen(
          mobileNumber: data.mobileNumber,
          role: data.role,
        );
      }),
      _route(AppRoutes.createAccount, (_) => const CreateAccountScreen()),
      _route(AppRoutes.companyDemo, (_) => const DemoHomeScreen()),
      _route(AppRoutes.companyDetails, (_) => const CompanyDetailsScreen()),
      _route(AppRoutes.bankDetails, (_) => const BankDetailsScreen()),
      _route(AppRoutes.uploadDocuments, (_) => const UploadDocumentsScreen()),
      _route(
        AppRoutes.termsOfService,
        (_) => TermsOfServiceScreen(
          onAccept: () => router.go(AppRoutes.verificationInProgress),
        ),
      ),
      _route(
        AppRoutes.verificationInProgress,
        (_) => const VerificationStatusScreen.inProgress(),
      ),
      _route(
        AppRoutes.verificationApproved,
        (_) => const VerificationStatusScreen.approved(),
      ),
      _route(
        AppRoutes.verificationRejected,
        (_) => const VerificationStatusScreen.rejected(),
      ),
      _route(AppRoutes.choosePlan, (_) => const ChoosePlanScreen()),
      _route(AppRoutes.home, (_) => const HomeScreen()),
      _route(AppRoutes.tenderMain, (_) => const TenderMainScreen()),
      _route(AppRoutes.addProduct, (_) => const AddProductScreen()),
      _route(
        AppRoutes.editProduct,
        (state) => EditProductScreen(product: _requiredExtra<Product>(state)),
      ),
      _route(AppRoutes.myProducts, (_) => const MyProductsScreen()),
      _route(AppRoutes.allProducts, (_) => const AllProductsScreen()),
      _route(AppRoutes.rfqRequests, (_) => const RFQRequestsScreen()),
      _route(
        AppRoutes.rfqDetail,
        (state) => RFQDetailScreen(rfq: _requiredExtra<RFQ>(state)),
      ),
      _route(AppRoutes.orders, (_) => const OrdersScreen()),
      _route(
        AppRoutes.orderDetails,
        (state) => OrderDetailsScreen(order: _requiredExtra<Order>(state)),
      ),
      _route(
        AppRoutes.orderStatusUpdate,
        (state) => OrderStatusUpdateScreen(order: _requiredExtra<Order>(state)),
      ),
      _route(
        AppRoutes.trackStatus,
        (state) => TrackStatusScreen(order: _requiredExtra<Order>(state)),
      ),
      _route(AppRoutes.profile, (_) => const ProfileScreen()),
      _route(AppRoutes.updateProfile, (_) => const UpdateProfileScreen()),
      _route(AppRoutes.tenderProfile, (_) => const TenderProfileScreen()),
      _route(AppRoutes.wallet, (_) => const MyWalletScreen()),
      _route(AppRoutes.tenderHome, (_) => const TenderHomeScreen()),
      _route(
        AppRoutes.tenderCategories,
        (_) => const TenderAllCategoriesScreen(),
      ),
      _route(
        AppRoutes.addTenderRfqRequests,
        (_) => const AddTenderRfqRequestsScreen(),
      ),
      _route(
        AppRoutes.tenderAllProducts,
        (_) => const TenderAllProductsScreen(),
      ),
      _route(
        AppRoutes.tenderSupplierDetails,
        (_) => const AdvTenderSupplierDetailsScreen(),
      ),
      _route(
        AppRoutes.addTenderCheckout,
        (_) => const AddTenderCheckoutScreen(),
      ),
      _route(
        AppRoutes.addTenderPaymentStatus,
        (state) => AddTenderPaymentStatusScreen(
          isSuccess: _requiredExtra<bool>(state),
        ),
      ),
      _route(AppRoutes.advTenderCart, (state) {
        final data = _requiredExtra<AdvTenderCartRouteData>(state);
        return AdvTenderRfqCartScreen(
          cartItems: data.cartItems,
          initialQuantities: data.initialQuantities,
        );
      }),
      _route(
        AppRoutes.advTenderRfqStatus,
        (_) => const AdvTenderRfqStatusScreen(),
      ),
      _route(
        AppRoutes.addTenderTerms,
        (_) => const AddTenderTermsOfServiceScreen(),
      ),
    ],
  );
  return router;
}

GoRoute _route(String path, Widget Function(GoRouterState state) builder) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: builder(state),
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.035),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    ),
  );
}

T _requiredExtra<T>(GoRouterState state) {
  final extra = state.extra;
  if (extra is T) return extra;
  throw FlutterError(
    'Route "${state.uri.path}" requires an extra value of type $T.',
  );
}
