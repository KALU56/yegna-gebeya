import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yegna_gebeya/shared/domain/models/product.dart';
import 'package:yegna_gebeya/shared/domain/models/user.dart'; // ✅ import your User model

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  Future<User?> _fetchSeller(String sellerId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(sellerId).get();
    if (!doc.exists) return null;
    return User.fromMap(doc.data()!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const SizedBox.shrink(),
      ),
      body: FutureBuilder<User?>(
        future: _fetchSeller(product.sellerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final seller = snapshot.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Seller info
                if (seller != null) ...[
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: (seller.imgUrl != null &&
                                seller.imgUrl!.isNotEmpty &&
                                seller.imgUrl!.startsWith('http'))
                            ? NetworkImage(seller.imgUrl!)
                            : const AssetImage('assets/images/default_avatar.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          seller.fullName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // ✅ Product image
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

                // ✅ Product name
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),

                const SizedBox(height: 8),

                // ✅ Description
                Text(
                  product.description,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 16),

                // ✅ Price
                Text(
                  "ETB ${product.price}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),

      // ✅ Bottom Buttons
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add to cart logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Checkout logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Checkout",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
