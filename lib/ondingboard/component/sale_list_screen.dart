import 'package:flutter/material.dart';
import 'sale_filter_screen.dart';
import 'package:buid_app/ondingboard/theme/theme.dart' as theme;

class SaleListScreen extends StatelessWidget {
  const SaleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sales',
          style: TextStyle(
            color: theme.AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.AppColors.primaryGradient.colors.first,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => DraggableScrollableSheet(
                  initialChildSize: 0.9,
                  minChildSize: 0.5,
                  maxChildSize: 0.95,
                  expand: false,
                  builder: (context, scrollController) {
                    return SaleFilterBottomSheet(
                      scrollController: scrollController,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: theme.AppColors.primaryGradient,
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSaleItem(
              category: 'GPU',
              title: 'MSI NVIDIA GeForce RTX 5060 Ti Dual Fan',
              description: '16GB - \$370 (Micro Center in Store Only)',
              price: '\$370.00',
              store: 'microcenter.com',
              date: '28/9/2025',
            ),

            const SizedBox(height: 16),

            _buildSaleItem(
              category: 'Power Supply',
              title: 'ASUS ROG Strix 750W Gold Aura Edition',
              description:
                  'Fully Modular Power Supply, 80+ Gold Certified, ATX 3.0 PSU - \$77.34 (110.49 with 30% coupon)',
              price: '\$77.34',
              store: 'Amazon',
              date: '28/9/2025',
            ),

            const SizedBox(height: 16),

            _buildSaleItem(
              category: 'Power Supply',
              title:
                  'SF Series SF750 Fully Modular 80 PLUS Platinum SFX Power Supply (Revival Series)',
              description: '',
              price: '\$99.00',
              store: 'corsair.com',
              date: '28/9/2025',
            ),

            const SizedBox(height: 16),

            _buildSaleItem(
              category: 'Monitor',
              title: 'MSI MAG 271QPX QD-OLED 27" QHD 360Hz Flat Gaming Monitor',
              description: 'MSI Website-\$549.99 after code (MAG271AG)',
              price: '',
              store: '',
              date: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaleItem({
    required String category,
    required String title,
    required String description,
    required String price,
    required String store,
    required String date,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6, // độ nổi
      color: theme.AppColors.cardBackground,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.AppColors.textSecondary,
              ),
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: 8),
            if (price.isNotEmpty) ...[
              Text(
                price,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.AppColors.secondary,
                  shadows: [
                    Shadow(
                      // thêm bóng nhẹ để nổi bật trên nền gradient
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 4),
            if (store.isNotEmpty || date.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (store.isNotEmpty)
                    Text(
                      store,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.AppColors.textThird,
                      ),
                    ),
                  if (date.isNotEmpty)
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.AppColors.textThird,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
