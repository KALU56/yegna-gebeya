import 'package:flutter/material.dart';
import 'package:yegna_gebeya/shared/domain/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, 
        title: const SizedBox.shrink(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (product.imgUrl ?? '').startsWith('http')
                  ? Image.network(
                      product.imgUrl ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) =>
                          Container(height: 200, color: Colors.grey[200]),
                    )
                  : Image.asset(
                      product.imgUrl ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) =>
                          Container(height: 200, color: Colors.grey[200]),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
          
            Text(
              product.description ?? "No description available.",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
              Text(
              "ETB ${product.price}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
