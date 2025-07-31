part of 'checkout_cubit.dart';

class CheckoutState extends Equatable {
  final String email;
  final String phone;
  final String address;

  const CheckoutState({
    this.email = '',
    this.phone = '',
    this.address = '',
  });

  CheckoutState copyWith({
    String? email,
    String? phone,
    String? address,
  }) {
    return CheckoutState(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  bool get isContactInfoComplete => email.isNotEmpty && phone.isNotEmpty;
  bool get isAddressComplete => address.isNotEmpty;

  @override
  List<Object> get props => [email, phone, address];
}
