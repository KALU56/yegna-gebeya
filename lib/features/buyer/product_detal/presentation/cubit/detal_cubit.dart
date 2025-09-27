import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yegna_gebeya/features/buyer/product_detal/presentation/cubit/detal_state.dart';
import 'package:yegna_gebeya/shared/domain/models/user.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProductDetailCubit() : super(ProductDetailState(status: ProductDetailStatus.initial));

  Future<void> fetchSeller(String sellerId) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));
    try {
      final doc = await _firestore.collection('users').doc(sellerId).get();
      if (!doc.exists) throw Exception("Seller not found");
      final seller = User.fromMap(doc.data()!);
      emit(state.copyWith(status: ProductDetailStatus.success, seller: seller));
    } catch (_) {
      emit(state.copyWith(status: ProductDetailStatus.failure));
    }
  }

  void checkout(BuildContext context) {
    Future.microtask(() => Navigator.pushNamed(context, '/checkout'));
  }

  void addToCart(BuildContext context) {
    Future.microtask(() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to cart")),
      );
    });
  }

  void goBack(BuildContext context) {
    Future.microtask(() {
      if (Navigator.canPop(context)) Navigator.pop(context);
    });
  }
}
