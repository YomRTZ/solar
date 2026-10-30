# My Products Feature

A complete product listing screen with search, filtering, and reusable card widgets.

## 📁 Files Structure

```
lib/
└── features/
    └── products/
        ├── data/
        │   └── datasources/
        │       └── products_data.dart
        ├── domain/
        │   └── entities/
        │       └── product.dart
        ├── presentation/
        │   └── pages/
        │       ├── my_products_screen.dart
        │       ├── products_demo.dart
        │       ├── add_product_screen.dart
        │       └── edit_product_screen.dart
        └── README.md
```

## 🎯 Features

✅ **Search Functionality**
- Real-time search by product name or ID
- Clear button to reset search

✅ **Category Filtering**
- All, Panel, Battery tabs
- Visual feedback for active tab

✅ **Product Cards**
- Uses reusable `AppExpandableCard` widget
- Shows image, title, ID, price, and status
- Three status types: In Stock, Low Stock, Out of Stock

✅ **Empty State**
- Shows when no products match filters

✅ **Responsive Design**
- Adapts to different screen sizes
- Proper spacing and alignment

## 🚀 Quick Start

### 1. Import the screen

```dart
import 'package:flutter_app/features/products/presentation/pages/my_products_screen.dart';

// Navigate to products screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const MyProductsScreen(),
  ),
);
```

### 2. Run the demo

```bash
# From project root
flutter run lib/features/products/presentation/pages/products_demo.dart
```

## 📊 Product Model

```dart
class Product {
  final String id;
  final String title;
  final String idNumber;
  final String price;
  final String imagePath;
  final ProductStatus status;
  final ProductCategory category;
}
```

### Product Status
- `ProductStatus.inStock` - Green badge
- `ProductStatus.lowStock` - Orange badge
- `ProductStatus.outOfStock` - Red badge

### Product Category
- `ProductCategory.all` - All products
- `ProductCategory.panel` - Solar panels
- `ProductCategory.battery` - Batteries
- `ProductCategory.inverter` - Inverters

## 📝 Sample Data

The app comes with 9 sample products:

**Panels (5 items)**
- Solar Trade panels with various IDs
- All in stock
- Price: Rs. 11234

**Batteries (2 items)**
- 150Ah Battery - In Stock (Rs. 8500)
- 200Ah Battery - Low Stock (Rs. 12000)

**Inverters (2 items)**
- 5KW Inverter - In Stock (Rs. 15000)
- 10KW Inverter - Out of Stock (Rs. 25000)

## 🎨 UI Components

### Header
- Blue gradient background
- Back button
- "My Products" title

### Search Bar
- Magnifying glass icon
- "Search Product..." placeholder
- Clear button (when text present)

### Category Tabs
- All / Panel / Battery
- Active tab: blue background, white text
- Inactive tab: white background, grey text

### Product Cards
- Uses `AppExpandableCard` reusable widget
- 80×81px product image
- Title, ID, price
- Status badge (In Stock/Low Stock/Out of Stock)
- Right arrow for navigation
- Bottom border separator

## 🔧 Customization

### Add More Products

Edit `lib/features/products/data/datasources/products_data.dart`:

```dart
Product(
  id: '10',
  title: 'New Product',
  idNumber: '#NEW001',
  price: '50000',
  imagePath: 'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
  status: ProductStatus.inStock,
  category: ProductCategory.panel,
)
```

### Add New Categories

1. Edit `lib/features/products/domain/entities/product.dart`:
```dart
enum ProductCategory {
  all,
  panel,
  battery,
  inverter,
  controller, // New category
}
```

2. Update the extension:
```dart
extension ProductCategoryExtension on ProductCategory {
  String get displayName {
    switch (this) {
      // ... existing cases
      case ProductCategory.controller:
        return 'Controller';
    }
  }
}
```

3. Add tab in `my_products_screen.dart`:
```dart
_buildCategoryTab(ProductCategory.controller),
```

### Change Colors

Edit colors in `my_products_screen.dart`:

```dart
// Header gradient
colors: [Color(0xFF003A8A), Color(0xFF000F24)]

// Active tab
color: isSelected ? Color(0xFF003D82) : Colors.white

// Search bar border
border: Border.all(color: Color(0xFFE0E0E0))
```

## 📱 Screen Flow

1. **User opens screen** → Shows all products
2. **User types in search** → Filters products in real-time
3. **User taps category tab** → Shows products in that category
4. **User taps product card** → Shows product details dialog (TODO: navigate to detail screen)
5. **No products found** → Shows empty state

## 🎯 Next Steps

### Recommended Improvements

1. **Product Detail Screen**
   - Create a new screen to show full product details
   - Update `_viewProductDetails()` to navigate instead of showing dialog

2. **Add to Cart**
   - Add shopping cart functionality
   - Quantity selector
   - Cart badge on header

3. **Sorting**
   - Sort by price (low to high, high to low)
   - Sort by name (A-Z, Z-A)
   - Sort by stock status

4. **Persistent Search**
   - Save search history
   - Quick search suggestions

5. **Pull to Refresh**
   - Add RefreshIndicator
   - Reload products from API

6. **Infinite Scroll**
   - Pagination for large product lists
   - Load more as user scrolls

## 🔗 Related Widgets

This screen uses these reusable widgets:

- `AppExpandableCard` - Product cards
- Can also integrate:
  - `AppTextField` - Advanced search
  - `AppDropdownField` - Sort options
  - `AppContinueButton` - Action buttons

## 💡 Pro Tips

1. **Performance**: The list is already optimized with `ListView.builder`
2. **Images**: All products use the same placeholder image - replace with real images
3. **Data**: Currently uses static data - integrate with your API
4. **State Management**: Consider using Provider/Riverpod for larger apps

## 🆘 Need Help?

- Check the demo app: `products_demo.dart`
- See sample data: `lib/features/products/data/datasources/products_data.dart`
- View entity: `lib/features/products/domain/entities/product.dart`
- Widget docs: `lib/core/widgets/README.md`

Happy coding! 🚀
