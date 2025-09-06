import 'package:flutter/material.dart';
import 'package:yegna_gebeya/features/buyer/home/presentation/pages/product_detail_page.dart';
import 'package:yegna_gebeya/shared/domain/models/product.dart';


class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      elevation: 3,
      child: InkWell(
        onTap: () {
          // Navigate to Product Detail Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(product: product),
            ),
          );
        },
        borderRadius: borderRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: (product.imgUrl ?? '').startsWith('http')
                    ? Image.network(
                        product.imgUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.error, size: 32),
                          );
                        },
                      )
                    : Image.asset(
                        product.imgUrl ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.error, size: 32),
                          );
                        },
                      ),
              ),
            ),

            // Product Name
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Product Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "ETB ${product.price.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
