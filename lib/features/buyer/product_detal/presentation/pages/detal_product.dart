import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yegna_gebeya/features/buyer/product_detal/presentation/cubit/detal_cubit.dart';
import 'package:yegna_gebeya/features/buyer/product_detal/presentation/cubit/detal_state.dart';
import 'package:yegna_gebeya/shared/domain/models/product.dart';


class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => ProductDetailCubit()..fetchSeller(product.sellerId),
      child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          final cubit = context.read<ProductDetailCubit>();

          Widget sellerInfo() {
            final seller = state.seller;
            if (seller == null) return const SizedBox.shrink();
            return Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: (seller.imgUrl != null &&
                          seller.imgUrl!.isNotEmpty &&
                          seller.imgUrl!.startsWith('http'))
                      ? NetworkImage(seller.imgUrl!)
                      : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    seller.fullName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          }

          if (state.status == ProductDetailStatus.loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.status == ProductDetailStatus.failure) {
            return const Scaffold(
              body: Center(child: Text("Failed to load seller info")),
            );
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => cubit.goBack(context),
              ),
              title: const SizedBox.shrink(),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sellerInfo(),
                  if (state.seller != null) const SizedBox(height: 16),

                  // Product Image
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

                  // Product Name
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Product Description
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 16),

                  // Product Price
                  Text(
                    "ETB ${product.price}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),

            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => cubit.checkout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => cubit.addToCart(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: theme.primaryColor,
                        side: BorderSide(color: theme.primaryColor, width: 2),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
