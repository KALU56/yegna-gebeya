import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yegna_gebeya/core/locator.dart';
import 'package:yegna_gebeya/features/auth/presentation/cubits/sign_in/sign_in_cubit.dart';
import 'package:yegna_gebeya/shared/models/product.dart';
import 'package:yegna_gebeya/features/buyer/presentation/bloc/cart_bloc/cart_bloc.dart';

import '../bloc/order_bloc/order_bloc.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    super.initState();

    final cartBloc = context.read<CartBloc>();

    if (cartBloc.state is CartInitial) {
      cartBloc.add(
        GetCartEvent(id: context.read<SignInCubit>().state.cred!.user!.uid),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is CartLoaded) {
            final deviceWidth = MediaQuery.of(context).size.width;
            final deviceHeight = MediaQuery.of(context).size.height;

            final productQuantities = <String, int>{};
            final productIdToProduct = <String, Product>{};

            for (final product in state.products) {
              productQuantities[product.productId!] =
                  (productQuantities[product.productId!] ?? 0) + 1;
              productIdToProduct[product.productId!] = product;
            }

            final entries = productQuantities.keys.toList();
            entries.sort((a, b) => a.compareTo(b));

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                SizedBox(
                  width: deviceWidth / 2,
                  height: deviceHeight / 3,
                  child: Image.asset('assets/images/buyer.png'),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth / 10),
                  child: Column(
                    children: [
                      Divider(),

                      SizedBox(
                        width: deviceWidth,
                        height: deviceHeight / 4,
                        child: ListView.builder(
                          itemCount: entries.length,
                          itemBuilder: (context, index) {
                            final entry = entries[index];
                            final product = productIdToProduct[entry];
                            final quantity = productQuantities[entry];

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: deviceWidth * 0.15,
                                  height: deviceHeight * 0.25 * 0.25,
                                  child: Image.network(
                                    product!.productImageUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    product.productName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(width: deviceWidth * 0.1),
                                Text(
                                  'ETB ${product.price}',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Text(quantity.toString()),

                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: deviceHeight * 0.04,
                                          child: IconButton(
                                            iconSize: deviceWidth * 0.045,
                                            onPressed: () =>
                                                context.read<CartBloc>().add(
                                                  AddToCartEvent(
                                                    id: context
                                                        .read<SignInCubit>()
                                                        .state
                                                        .cred!
                                                        .user!
                                                        .uid,
                                                    product: product,
                                                  ),
                                                ),
                                            icon: const Icon(
                                              Icons.arrow_upward,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: deviceHeight * 0.04,
                                          child: IconButton(
                                            iconSize: deviceWidth * 0.045,
                                            onPressed: () =>
                                                context.read<CartBloc>().add(
                                                  RemoveFromCartEvent(
                                                    id: context
                                                        .read<SignInCubit>()
                                                        .state
                                                        .cred!
                                                        .user!
                                                        .uid,
                                                    product: product,
                                                  ),
                                                ),
                                            icon: const Icon(
                                              Icons.arrow_downward,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      Divider(),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: deviceWidth / 10,
                    vertical: deviceHeight * 0.03,
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        state.totalPrice.toStringAsFixed(2),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                      (states) => Color(0xFF8D00DE),
                    ),
                  ),
                  onPressed: () {
                    context.read<OrderBloc>().add(
                      PurchaseProducts(
                        id: context.read<SignInCubit>().state.cred!.user!.uid,
                      ),
                    );
                    showDialog(
                      context: context,
                      builder: (context) {
                        final totalPrice = state.totalPrice;
                        return AlertDialog.adaptive(
                          backgroundColor: Colors.white,
                          content: SizedBox(
                            height: deviceHeight * 0.45,
                            child: BlocBuilder<OrderBloc, OrderState>(
                              builder: (context, state) {
                                if (state is OrderError) {
                                  return Center(
                                    child: Text(
                                      'Error purchasing products, try again ${state.message}',
                                    ),
                                  );
                                }

                                if (state is OrderSuccess) {
                                  return Column(
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional.topEnd,
                                        child: IconButton(
                                          onPressed: () => context.pop(),
                                          icon: Icon(Icons.close_sharp),
                                        ),
                                      ),

                                      Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/pyment done.png',
                                          ),
                                          Image.asset(
                                            'assets/images/Layer 2.png',
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'ETB ${totalPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Color(0xFF8D00DE),
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                                      SizedBox(height: 30),
                                      Text(
                                        'We’re on our way with your items',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  );
                                }

                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'checkout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          }

          return Center(child: Text('Cart is empty'));
        },
      ),
    );
  }
}
