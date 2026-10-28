import '../models/advtender_supplier.dart';
import '../models/catalog_product.dart';

/// Mock data for the advtender screens.
class AdvTenderData {
  static const String _img =
      'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png';

  static const String _aboutText =
      'Lorem Ipsum is simply dummy text of the printing and typesetting '
      'industry. Lorem Ipsum has been the industry standard dummy text ever '
      'since the 1500s, when an unknown printer took a galley of type and '
      'scrambled it.';

  // ── Main products shown on supplier detail page ─────────────
  static const List<CatalogProduct> supplierProducts = [
    CatalogProduct(
      id: 'sp_1',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.100+',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'sp_2',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.100+',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'sp_3',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.100+',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'sp_4',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.100+',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'sp_5',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.100+',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'sp_6',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.100+',
      imagePath: _img,
    ),
  ];

  // ── Demo supplier ────────────────────────────────────────────
  static final AdvTenderSupplier demoSupplier = AdvTenderSupplier(
    id: 'sup_1',
    name: 'SunTech Energy Solutions',
    badge: 'Verified Seller',
    rating: 4.8,
    totalOrders: 500,
    aboutText: _aboutText,
    iconPath: 'assets/images/a_clean_high_resolution_vector_like_logo_image_on.png',
    mainProducts: supplierProducts,
  );

  // ── RFQ cart demo items ───────────────────────────────────────
  static const List<CatalogProduct> rfqCartItems = [
    CatalogProduct(
      id: 'rfq_1',
      name: 'Solar Trade',
      subtitle: 'By SunTech Sol.',
      price: 'Rs.10000+',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'rfq_2',
      name: 'Solar Trade',
      subtitle: 'By SunTech Sol.',
      price: 'Rs.10000+',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'rfq_3',
      name: 'Solar Trade',
      subtitle: 'By SunTech Sol.',
      price: 'Rs.10000+',
      imagePath: _img,
    ),
  ];
}
