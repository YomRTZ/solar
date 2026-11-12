import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/features/account/presentation/pages/create_account_screen.dart';
import 'package:flutter_app/features/transporter/domain/entities/transporter_job.dart';
import 'package:flutter_app/features/transporter/presentation/pages/bid_status_screen.dart';
import 'package:flutter_app/features/transporter/presentation/pages/create_transporter_account_screen.dart';
import 'package:flutter_app/features/transporter/presentation/pages/transporter_dashboard_screen.dart';
import 'package:flutter_app/features/transporter/presentation/pages/transporter_delivery_status_screen.dart';
import 'package:flutter_app/features/transporter/presentation/pages/transporter_my_bids_screen.dart';
import 'package:flutter_app/features/transporter/presentation/pages/transporter_my_trips_screen.dart';
import 'package:flutter_app/features/transporter/presentation/pages/transporter_profile_screen.dart';
import 'package:flutter_app/features/transporter/presentation/pages/place_bid_screen.dart';
import 'package:flutter_app/features/transporter/presentation/pages/transporter_trip_verified_screen.dart';
import 'package:flutter_app/features/transporter/presentation/pages/transporter_verify_delivery_screen.dart';
import 'package:flutter_app/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter_app/features/auth/presentation/pages/otp_verification_screen.dart';
import 'package:flutter_app/features/bank/presentation/pages/bank_details_screen.dart';
import 'package:flutter_app/features/catalog/presentation/pages/all_products_screen.dart';
import 'package:flutter_app/features/company/presentation/pages/company_bank_demo_screen.dart';
import 'package:flutter_app/features/company/presentation/pages/company_details_screen.dart';
import 'package:flutter_app/features/documents/presentation/pages/upload_documents_screen.dart';
import 'package:flutter_app/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:flutter_app/features/orders/presentation/pages/order_details_screen.dart';
import 'package:flutter_app/features/orders/presentation/pages/create_shipment_screen.dart';
import 'package:flutter_app/features/orders/presentation/pages/bids_received_screen.dart';
import 'package:flutter_app/features/orders/presentation/pages/order_status_update_screen.dart';
import 'package:flutter_app/features/orders/presentation/pages/orders_screen.dart';
import 'package:flutter_app/features/orders/presentation/pages/track_status_screen.dart';
import 'package:flutter_app/features/plan/presentation/pages/choose_plan_screen.dart';
import 'package:flutter_app/features/products/presentation/pages/add_product_screen.dart';
import 'package:flutter_app/features/products/presentation/pages/edit_product_screen.dart';
import 'package:flutter_app/features/products/presentation/pages/my_products_screen.dart';
import 'package:flutter_app/features/profile/presentation/pages/account_details_screen.dart';
import 'package:flutter_app/features/profile/presentation/pages/supplier_profile_screen.dart';
import 'package:flutter_app/features/profile/presentation/pages/update_profile_screen.dart';
import 'package:flutter_app/features/profile/presentation/pages/vendor_profile_screen.dart';
import 'package:flutter_app/features/rfq/presentation/pages/rfq_detail_screen.dart';
import 'package:flutter_app/features/rfq/presentation/pages/rfq_requests_screen.dart';
import 'package:flutter_app/features/splash/presentation/pages/splash_screen.dart';
import 'package:flutter_app/features/shopping/presentation/pages/checkout_screen.dart';
import 'package:flutter_app/features/shopping/presentation/pages/payment_status_screen.dart';
import 'package:flutter_app/features/shopping/presentation/pages/rfq_cart_screen.dart';
import 'package:flutter_app/features/shopping/presentation/pages/rfq_status_screen.dart';
import 'package:flutter_app/features/catalog/presentation/pages/catalog_vendor_details_screen.dart';
import 'package:flutter_app/features/catalog/presentation/pages/catalog_categories_screen.dart';
import 'package:flutter_app/features/catalog/presentation/pages/catalog_all_products_screen.dart';
import 'package:flutter_app/features/catalog/presentation/pages/catalog_browse_screen.dart';
import 'package:flutter_app/features/shopping/presentation/pages/shopping_rfq_list_screen.dart';
import 'package:flutter_app/features/dashboard/presentation/pages/marketplace_screen.dart';
import 'package:flutter_app/features/documents/presentation/pages/my_documents_screen.dart';
import 'package:flutter_app/features/bank/presentation/pages/bank_details_edit_screen.dart';
import 'package:flutter_app/features/terms/presentation/pages/vendor_terms_of_service_screen.dart';
import 'package:flutter_app/features/terms/presentation/pages/terms_of_service_screen.dart';
import 'package:flutter_app/features/verification/presentation/pages/verification_status_screen.dart';
import 'package:flutter_app/features/wallet/presentation/pages/my_wallet_screen.dart';
import 'package:flutter_app/features/orders/domain/entities/order.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_rfq_request.dart';
import 'package:flutter_app/features/products/domain/entities/product.dart';
import 'package:flutter_app/features/rfq/domain/entities/rfq.dart';
import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/app/routing/route_data.dart';

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
      _route(
        AppRoutes.transporterCreateAccount,
        (_) => const CreateTransporterAccountScreen(),
      ),
      _route(
        AppRoutes.transporterHome,
        (_) => const TransporterDashboardScreen(),
      ),
      _route(
        AppRoutes.transporterProfile,
        (_) => const TransporterProfileScreen(),
      ),
      _route(
        AppRoutes.transporterMyBids,
        (_) => const TransporterMyBidsScreen(),
      ),
      _route(
        AppRoutes.transporterMyTrips,
        (_) => const TransporterMyTripsScreen(),
      ),
      _route(
        AppRoutes.transporterTripVerified,
        (state) => TransporterTripVerifiedScreen(
          trip: _requiredExtra<TransporterTrip>(state),
        ),
      ),
      _route(
        AppRoutes.transporterDeliveryVerify,
        (state) => TransporterVerifyDeliveryScreen(
          trip: _requiredExtra<TransporterTrip>(state),
        ),
      ),
      _route(
        AppRoutes.transporterDeliveryStatus,
        (_) => const TransporterDeliveryStatusScreen(),
      ),
      _route(
        AppRoutes.transporterPlaceBid,
        (state) => PlaceBidScreen(job: _requiredExtra<TransporterJob>(state)),
      ),
      _route(AppRoutes.transporterBidStatus, (_) => const BidStatusScreen()),
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
      _route(AppRoutes.home, (_) => const DashboardScreen()),
      _route(AppRoutes.vendorMain, (_) => const MarketplaceScreen()),
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
      _route(AppRoutes.createShipment, (_) => const CreateShipmentScreen()),
      _route(AppRoutes.bidsReceived, (_) => const BidsReceivedScreen()),
      _route(
        AppRoutes.orderStatusUpdate,
        (state) => OrderStatusUpdateScreen(order: _requiredExtra<Order>(state)),
      ),
      _route(
        AppRoutes.trackStatus,
        (state) => TrackStatusScreen(order: _requiredExtra<Order>(state)),
      ),
      _route(AppRoutes.profile, (_) => const VendorProfileScreen()),
      _route(AppRoutes.updateProfile, (_) => const UpdateProfileScreen()),
      _route(AppRoutes.accountDetails, (_) => const AccountDetailsScreen()),
      _route(AppRoutes.vendorProfile, (_) => const SupplierProfileScreen()),
      _route(AppRoutes.wallet, (_) => const MyWalletScreen()),
      _route(AppRoutes.vendorHome, (_) => const CatalogBrowseScreen()),
      _route(
        AppRoutes.vendorCategories,
        (_) => const CatalogCategoriesScreen(),
      ),
      _route(
        AppRoutes.catalogRfqRequests,
        (_) => const ShoppingRfqListScreen(),
      ),
      _route(
        AppRoutes.vendorAllProducts,
        (_) => const CatalogAllProductsScreen(),
      ),
      _route(
        AppRoutes.supplierDetails,
        (_) => const CatalogVendorDetailsScreen(),
      ),
      _route(
        AppRoutes.vendorCheckout,
        (state) => CheckoutScreen(
          request: state.extra is CatalogRfqRequest
              ? state.extra as CatalogRfqRequest
              : null,
        ),
      ),
      _route(
        AppRoutes.vendorPaymentStatus,
        (state) => PaymentStatusScreen(isSuccess: _requiredExtra<bool>(state)),
      ),
      _route(AppRoutes.vendorCart, (state) {
        final data = _requiredExtra<VendorCartRouteData>(state);
        return RfqCartScreen(
          cartItems: data.cartItems,
          initialQuantities: data.initialQuantities,
        );
      }),
      _route(AppRoutes.vendorRfqStatus, (_) => const RfqStatusScreen()),
      _route(AppRoutes.vendorTerms, (_) => const VendorTermsOfServiceScreen()),
      _route(AppRoutes.vendorUploadDocuments, (_) => const MyDocumentsScreen()),
      _route(AppRoutes.vendorBankDetails, (_) => const BankDetailsEditScreen()),
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
