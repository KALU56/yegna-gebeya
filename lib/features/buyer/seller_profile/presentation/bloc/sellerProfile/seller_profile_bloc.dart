import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yegna_gebeya/features/buyer/seller_profile/domain/repositories/buyer_repository.dart';
import 'seller_profile_event.dart';
import 'seller_profile_state.dart';

class SellerProfileBloc extends Bloc<SellerProfileEvent, SellerProfileState> {
  final BuyerRepository buyerRepository;

  SellerProfileBloc({required this.buyerRepository})
      : super(SellerProfileInitial()) {
    on<FetchSellerProfileEvent>(_onFetchSellerProfile);
  }

  Future<void> _onFetchSellerProfile(
    FetchSellerProfileEvent event,
    Emitter<SellerProfileState> emit,
  ) async {
    emit(SellerProfileLoading());
    try {
      final seller = await buyerRepository.getSellerById(event.sellerId);
      final products =
          await buyerRepository.getProductsBySellerId(event.sellerId);
      emit(SellerProfileLoaded(seller, products));
    } catch (e) {
      emit(SellerProfileError(e.toString()));
    }
  }
}
