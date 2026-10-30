/// PRODUCT CARD WIDGET USAGE EXAMPLES
/// 
/// This file demonstrates how to use the AppProductCard widget
/// DO NOT import this file - it's just for reference!
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/core/widgets/app_product_card.dart';
import 'package:flutter_app/core/widgets/app_header.dart';

/// Example 1: Single Product Card with "New" status
class SingleProductCardExample extends StatelessWidget {
  const SingleProductCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppProductCard.newStatus(
          imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
          title: '10 KW Solar Panel',
          rfqNumber: '#RFQ123456',
          price: '100000',
          onTap: () {
            debugPrint('Product card tapped');
          },
        ),
      ),
    );
  }
}

/// Example 2: Single Product Card with "Open" status
class OpenStatusProductCardExample extends StatelessWidget {
  const OpenStatusProductCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppProductCard.openStatus(
          imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
          title: '5 KW Solar Panel',
          rfqNumber: '#RFQ123456',
          price: '23000',
          onTap: () {
            debugPrint('Open product tapped');
          },
        ),
      ),
    );
  }
}

/// Example 3: List of Product Cards
class ProductListExample extends StatelessWidget {
  const ProductListExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Products'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  AppProductCard.newStatus(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: '10 KW Solar Panel',
                    rfqNumber: '#RFQ123456',
                    price: '100000',
                    onTap: () {
                      debugPrint('Product 1 tapped');
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  AppProductCard.openStatus(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: '5 KW Solar Panel',
                    rfqNumber: '#RFQ123456',
                    price: '23000',
                    onTap: () {
                      debugPrint('Product 2 tapped');
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  AppProductCard.newStatus(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: '15 KW Solar Panel',
                    rfqNumber: '#RFQ789012',
                    price: '150000',
                    onTap: () {
                      debugPrint('Product 3 tapped');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 4: Product Cards with Custom Status
class CustomStatusProductCardExample extends StatelessWidget {
  const CustomStatusProductCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom status with custom colors
            AppProductCard(
              imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
              title: '20 KW Solar Panel',
              rfqNumber: '#RFQ567890',
              price: '200000',
              statusText: 'Closed',
              statusBackgroundColor: const Color(0xFFFFE5E5),
              statusTextColor: const Color(0xFFD32F2F),
              onTap: () {
                debugPrint('Closed product tapped');
              },
            ),
            const SizedBox(height: 16),
            
            AppProductCard(
              imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
              title: '8 KW Solar Panel',
              rfqNumber: '#RFQ345678',
              price: '80000',
              statusText: 'Hot',
              statusBackgroundColor: const Color(0xFFFFF3E0),
              statusTextColor: const Color(0xFFFF6F00),
              onTap: () {
                debugPrint('Hot product tapped');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 5: Product Cards with Network Images
class NetworkImageProductCardExample extends StatelessWidget {
  const NetworkImageProductCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppProductCard.newStatus(
          imagePath: 'https://example.com/solar-panel.jpg',
          title: '12 KW Solar Panel',
          rfqNumber: '#RFQ111222',
          price: '120000',
          isNetworkImage: true,
          onTap: () {
            debugPrint('Network image product tapped');
          },
        ),
      ),
    );
  }
}

/// Example 6: Dynamic Product List from Data
class DynamicProductListExample extends StatelessWidget {
  const DynamicProductListExample({super.key});

  // Sample data
  static const List<Map<String, dynamic>> products = [
    {
      'image': 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      'title': '10 KW Solar Panel',
      'rfq': '#RFQ123456',
      'price': '100000',
      'status': 'new',
    },
    {
      'image': 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      'title': '5 KW Solar Panel',
      'rfq': '#RFQ123457',
      'price': '23000',
      'status': 'open',
    },
    {
      'image': 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      'title': '15 KW Solar Panel',
      'rfq': '#RFQ123458',
      'price': '150000',
      'status': 'new',
    },
    {
      'image': 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      'title': '8 KW Solar Panel',
      'rfq': '#RFQ123459',
      'price': '80000',
      'status': 'open',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Solar Products'),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(18),
                itemCount: products.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final isNew = product['status'] == 'new';
                  
                  return isNew
                      ? AppProductCard.newStatus(
                          imagePath: product['image'],
                          title: product['title'],
                          rfqNumber: product['rfq'],
                          price: product['price'],
                          onTap: () {
                            _showProductDetails(context, product);
                          },
                        )
                      : AppProductCard.openStatus(
                          imagePath: product['image'],
                          title: product['title'],
                          rfqNumber: product['rfq'],
                          price: product['price'],
                          onTap: () {
                            _showProductDetails(context, product);
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('RFQ: ${product['rfq']}'),
            Text('Price: Rs. ${product['price']}'),
            Text('Status: ${product['status']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Example 7: Scrollable Horizontal Product Cards
class HorizontalProductCardsExample extends StatelessWidget {
  const HorizontalProductCardsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'Featured Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                children: [
                  AppProductCard.newStatus(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: '10 KW Solar Panel',
                    rfqNumber: '#RFQ123456',
                    price: '100000',
                  ),
                  const SizedBox(width: 16),
                  
                  AppProductCard.openStatus(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: '5 KW Solar Panel',
                    rfqNumber: '#RFQ123457',
                    price: '23000',
                  ),
                  const SizedBox(width: 16),
                  
                  AppProductCard.newStatus(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: '15 KW Solar Panel',
                    rfqNumber: '#RFQ123458',
                    price: '150000',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 8: Product Cards in GridView
class GridProductCardsExample extends StatelessWidget {
  const GridProductCardsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'All Products'),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                padding: const EdgeInsets.all(18),
                mainAxisSpacing: 16,
                childAspectRatio: 327 / 103,
                children: [
                  AppProductCard.newStatus(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: '10 KW Solar Panel',
                    rfqNumber: '#RFQ123456',
                    price: '100000',
                  ),
                  AppProductCard.openStatus(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: '5 KW Solar Panel',
                    rfqNumber: '#RFQ123457',
                    price: '23000',
                  ),
                  AppProductCard.newStatus(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: '15 KW Solar Panel',
                    rfqNumber: '#RFQ123458',
                    price: '150000',
                  ),
                  AppProductCard.openStatus(
                    imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: '8 KW Solar Panel',
                    rfqNumber: '#RFQ123459',
                    price: '80000',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
SUMMARY:

AppProductCard Properties:
- imagePath (required): Asset or network image path
- title (required): Product name
- rfqNumber (required): RFQ/reference number
- price (required): Product price (without Rs. prefix)
- statusText (required): Badge text
- statusBackgroundColor: Badge background color
- statusTextColor: Badge text color
- isNetworkImage: true for network images, false for assets
- onTap: Callback when card is tapped
- maxWidth: Card width (default: 327)
- height: Card height (default: 103)

Factory Constructors:
- AppProductCard.newStatus(): Green badge for new items
- AppProductCard.openStatus(): Blue badge for open items

Custom Status:
- Use the main constructor with custom colors for other statuses
*/
