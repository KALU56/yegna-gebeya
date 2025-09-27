import '../../../../../shared/domain/models/user.dart';

enum ProductDetailStatus { initial, loading, success, failure }

class ProductDetailState {
  final ProductDetailStatus status;
  final User? seller;

  ProductDetailState({required this.status, this.seller});

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    User? seller,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      seller: seller ?? this.seller,
    );
  }
}
