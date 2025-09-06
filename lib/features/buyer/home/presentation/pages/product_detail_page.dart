import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yegna_gebeya/shared/domain/models/product.dart';
import 'package:yegna_gebeya/shared/domain/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  User? seller;

  @override
  void initState() {
    super.initState();
    _loadSeller();
  }

  Future<void> _loadSeller() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.product.sellerId)
        .get();

    if (doc.exists) {
      setState(() {
        seller = User.fromMap(doc.data()!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const purpleColor = Color(0xFF8D00DE);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seller Info
            if (seller != null) ...[
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: (seller!.imgUrl != null && seller!.imgUrl!.isNotEmpty)
                        ? NetworkImage(seller!.imgUrl!)
                        : null,
                    child: (seller!.imgUrl == null || seller!.imgUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    seller!.fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ] else
              const Center(child: CircularProgressIndicator()),

            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (widget.product.imgUrl ?? '').startsWith('http')
                  ? Image.network(
                      widget.product.imgUrl!,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      widget.product.imgUrl ?? '',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 16),

            // Product Name
            Text(
              widget.product.name,
              style: GoogleFonts.sarpanch(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: purpleColor,
              ),
            ),
            const SizedBox(height: 8),

            // Product Description
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Product Price
            Text(
              "ETB ${widget.product.price.toStringAsFixed(2)}",
              style: GoogleFonts.sarpanch(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: purpleColor,
              ),
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Add checkout logic
                    },
                    label: const Text("Checkout"),
                    icon: const Icon(Icons.payment),
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.purple,
                      foregroundColor: Colors.white, // Text & icon color
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Add to cart logic
                    },
                    label: const Text("Add to Cart"),
                    icon: const Icon(Icons.add_shopping_cart),
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple, // Text & icon color
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
