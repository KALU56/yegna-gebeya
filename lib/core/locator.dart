import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:yegna_gebeya/features/auth/data/repositories/auth_repository.dart';
import 'package:yegna_gebeya/features/auth/domain/repositories/auth_repository.dart';
import 'package:yegna_gebeya/features/auth/presentation/cubits/sign_in/sign_in_cubit.dart';
import 'package:yegna_gebeya/features/auth/presentation/cubits/sign_up/sign_up_cubit.dart';
import 'package:yegna_gebeya/features/buyer/data/repositories/buyer_repository_impl.dart';
import 'package:yegna_gebeya/features/buyer/domain/repositories/buyer_repository.dart';
import 'package:yegna_gebeya/features/buyer/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:yegna_gebeya/features/buyer/presentation/bloc/order_bloc/order_bloc.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseAuth: getIt<FirebaseAuth>()),
  );

  getIt.registerFactory<SignUpCubit>(
    () => SignUpCubit(authRepo: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  getIt.registerLazySingleton<BuyerRepository>(() => BuyerRepositoryImpl(firestore: getIt<FirebaseFirestore>()));

  getIt.registerFactory<CartBloc>(() => CartBloc(repository: getIt<BuyerRepository>()));

  getIt.registerFactory<OrderBloc>(()=>OrderBloc(getIt<BuyerRepository>()));

  getIt.registerFactory<SignInCubit>(
    () => SignInCubit(authRepo: getIt<AuthRepository>()),
  );
}
