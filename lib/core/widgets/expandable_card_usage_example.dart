/// EXPANDABLE CARD WIDGET USAGE EXAMPLES
/// 
/// This file demonstrates how to use the AppExpandableCard widget
/// DO NOT import this file - it's just for reference!
library;

import 'package:flutter/material.dart';
import 'app_expandable_card.dart';
import 'app_header.dart';

/// Example 1: Single Card with "In Stock" status
class SingleExpandableCardExample extends StatelessWidget {
  const SingleExpandableCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppExpandableCard.inStock(
          imagePath: 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
          title: 'Solar Trade',
          idNumber: '#MB12345',
          price: '11234',
          onTap: () {
            print('Card tapped');
          },
        ),
      ),
    );
  }
}

/// Example 2: List of Expandable Cards
class ExpandableCardListExample extends StatelessWidget {
  const ExpandableCardListExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Inventory'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  AppExpandableCard.inStock(
                    imagePath: 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: 'Solar Trade',
                    idNumber: '#MB12345',
                    price: '11234',
                    onTap: () {
                      print('Item 1 tapped');
                    },
                  ),
                  AppExpandableCard.inStock(
                    imagePath: 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: 'Solar Trade',
                    idNumber: '#MB12345',
                    price: '11234',
                    onTap: () {
                      print('Item 2 tapped');
                    },
                  ),
                  AppExpandableCard.lowStock(
                    imagePath: 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: 'Solar Panel 5KW',
                    idNumber: '#MB12346',
                    price: '5000',
                    onTap: () {
                      print('Low stock item tapped');
                    },
                  ),
                  AppExpandableCard.outOfStock(
                    imagePath: 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
                    title: 'Solar Panel 10KW',
                    idNumber: '#MB12347',
                    price: '10000',
                    onTap: () {
                      print('Out of stock item tapped');
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

/// Example 3: Different Status Types
class DifferentStatusCardsExample extends StatelessWidget {
  const DifferentStatusCardsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // In Stock - Green
            AppExpandableCard.inStock(
              imagePath: 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
              title: 'Solar Trade',
              idNumber: '#MB12345',
              price: '11234',
            ),
            const SizedBox(height: 16),
            
            // Low Stock - Orange
            AppExpandableCard.lowStock(
              imagePath: 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
              title: 'Solar Panel 5KW',
              idNumber: '#MB12346',
              price: '5000',
            ),
            const SizedBox(height: 16),
            
            // Out of Stock - Red
            AppExpandableCard.outOfStock(
              imagePath: 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
              title: 'Solar Panel 10KW',
              idNumber: '#MB12347',
              price: '10000',
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 4: Custom Status Colors
class CustomStatusCardExample extends StatelessWidget {
  const CustomStatusCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppExpandableCard(
              imagePath: 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
              title: 'Premium Solar',
              idNumber: '#MB12348',
              price: '50000',
              statusText: 'Premium',
              statusBackgroundColor: const Color(0xFFFFF3E0),
              statusTextColor: const Color(0xFFFF6F00),
              onTap: () {},
            ),
            const SizedBox(height: 16),
            
            AppExpandableCard(
              imagePath: 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
              title: 'Discounted Solar',
              idNumber: '#MB12349',
              price: '8000',
              statusText: 'Sale',
              statusBackgroundColor: const Color(0xFFFFEBEE),
              statusTextColor: const Color(0xFFE53935),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 5: Dynamic List from Data
class DynamicExpandableListExample extends StatelessWidget {
  const DynamicExpandableListExample({super.key});

  // Sample data
  static const List<Map<String, dynamic>> items = [
    {
      'image': 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      'title': 'Solar Trade',
      'id': '#MB12345',
      'price': '11234',
      'status': 'in_stock',
    },
    {
      'image': 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      'title': '5 KW Solar Panel',
      'id': '#MB12346',
      'price': '5000',
      'status': 'low_stock',
    },
    {
      'image': 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      'title': '10 KW Solar Panel',
      'id': '#MB12347',
      'price': '10000',
      'status': 'out_of_stock',
    },
    {
      'image': 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      'title': '15 KW Solar Panel',
      'id': '#MB12348',
      'price': '15000',
      'status': 'in_stock',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Stock Inventory'),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  
                  // Choose card type based on status
                  if (item['status'] == 'in_stock') {
                    return AppExpandableCard.inStock(
                      imagePath: item['image'],
                      title: item['title'],
                      idNumber: item['id'],
                      price: item['price'],
                      onTap: () => _showDetails(context, item),
                    );
                  } else if (item['status'] == 'low_stock') {
                    return AppExpandableCard.lowStock(
                      imagePath: item['image'],
                      title: item['title'],
                      idNumber: item['id'],
                      price: item['price'],
                      onTap: () => _showDetails(context, item),
                    );
                  } else {
                    return AppExpandableCard.outOfStock(
                      imagePath: item['image'],
                      title: item['title'],
                      idNumber: item['id'],
                      price: item['price'],
                      onTap: () => _showDetails(context, item),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${item['id']}'),
            Text('Price: Rs. ${item['price']}'),
            Text('Status: ${item['status']}'),
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

/// Example 6: Without Arrow Icon
class NoArrowCardExample extends StatelessWidget {
  const NoArrowCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppExpandableCard.inStock(
          imagePath: 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
          title: 'Solar Trade',
          idNumber: '#MB12345',
          price: '11234',
          showArrow: false, // No arrow
          onTap: () {
            print('Card without arrow tapped');
          },
        ),
      ),
    );
  }
}

/// Example 7: Network Images
class NetworkImageCardExample extends StatelessWidget {
  const NetworkImageCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppExpandableCard.inStock(
          imagePath: 'https://example.com/solar-panel.jpg',
          title: 'Solar Trade',
          idNumber: '#MB12345',
          price: '11234',
          isNetworkImage: true,
          onTap: () {},
        ),
      ),
    );
  }
}

/// Example 8: Filterable List
class FilterableExpandableListExample extends StatefulWidget {
  const FilterableExpandableListExample({super.key});

  @override
  State<FilterableExpandableListExample> createState() =>
      _FilterableExpandableListExampleState();
}

class _FilterableExpandableListExampleState
    extends State<FilterableExpandableListExample> {
  String selectedFilter = 'all';

  final List<Map<String, dynamic>> allItems = [
    {
      'image': 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      'title': 'Solar Trade 1',
      'id': '#MB12345',
      'price': '11234',
      'status': 'in_stock',
    },
    {
      'image': 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      'title': 'Solar Trade 2',
      'id': '#MB12346',
      'price': '5000',
      'status': 'low_stock',
    },
    {
      'image': 'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      'title': 'Solar Trade 3',
      'id': '#MB12347',
      'price': '10000',
      'status': 'out_of_stock',
    },
  ];

  List<Map<String, dynamic>> get filteredItems {
    if (selectedFilter == 'all') return allItems;
    return allItems.where((item) => item['status'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Inventory'),
            
            // Filter buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildFilterButton('all', 'All'),
                  const SizedBox(width: 8),
                  _buildFilterButton('in_stock', 'In Stock'),
                  const SizedBox(width: 8),
                  _buildFilterButton('low_stock', 'Low'),
                  const SizedBox(width: 8),
                  _buildFilterButton('out_of_stock', 'Out'),
                ],
              ),
            ),
            
            // Filtered list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  
                  if (item['status'] == 'in_stock') {
                    return AppExpandableCard.inStock(
                      imagePath: item['image'],
                      title: item['title'],
                      idNumber: item['id'],
                      price: item['price'],
                    );
                  } else if (item['status'] == 'low_stock') {
                    return AppExpandableCard.lowStock(
                      imagePath: item['image'],
                      title: item['title'],
                      idNumber: item['id'],
                      price: item['price'],
                    );
                  } else {
                    return AppExpandableCard.outOfStock(
                      imagePath: item['image'],
                      title: item['title'],
                      idNumber: item['id'],
                      price: item['price'],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String value, String label) {
    final isSelected = selectedFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = value;
          });
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF003D82) : Colors.white,
            border: Border.all(color: const Color(0xFF003D82)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF003D82),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
SUMMARY:

AppExpandableCard Properties:
- imagePath (required): Asset or network image path
- title (required): Item title
- idNumber (required): ID/reference number
- price (required): Price (without Rs. prefix)
- statusText (required): Status badge text
- statusBackgroundColor: Badge background color
- statusTextColor: Badge text color
- isNetworkImage: true for network images
- onTap: Callback when card is tapped
- maxWidth: Card width (default: 327)
- height: Card height (default: 103)
- showArrow: Show/hide arrow icon (default: true)

Factory Constructors:
- AppExpandableCard.inStock(): Green badge
- AppExpandableCard.lowStock(): Orange badge
- AppExpandableCard.outOfStock(): Red badge

Features:
- Bottom border separator
- 90° rotated arrow icon (pointing right)
- Automatic image placeholder on error
- Consistent styling across all cards
*/
