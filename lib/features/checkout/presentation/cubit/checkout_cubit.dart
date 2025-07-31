import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(const CheckoutState());

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;

    emit(state.copyWith(
      email: user?.email ?? '',
      phone: prefs.getString('userPhone') ?? '',
      address: prefs.getString('userAddress') ?? '',
    ));
  }

  void updateContactInfo(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userPhone', phone);
    emit(state.copyWith(phone: phone));
  }

  void updateAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userAddress', address);
    emit(state.copyWith(address: address));
  }
}