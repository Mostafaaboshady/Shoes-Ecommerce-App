import 'package:final_project/core/routes/route_names.dart';
import 'package:final_project/core/widgets/custom_appbar.dart';
import 'package:final_project/core/widgets/custom_button.dart';
import 'package:final_project/core/widgets/custom_text.dart';
import 'package:final_project/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../../../cart/data/presentation/cubit/cart_cubit.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  void initState() {
    super.initState();
    context.read<CheckoutCubit>().loadUserData();
  }

  void _onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  // --- NEW: Shows the success dialog ---
  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SizedBox(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/congratulations.png',
                  height: 100,
                  errorBuilder: (c, e, s) => const Icon(Icons.check_circle, color: Colors.green, size: 80),
                ),
                const SizedBox(height: 20),
                const CustomText(
                  text: 'Your Payment Is Successful',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    context.read<CartCubit>().clearCart();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteNames.home, (route) => false);
                  },
                  child: const CustomText(
                    text: 'Back To Shopping',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- NEW: Shows the confirmation dialog ---
  Future<void> _showConfirmationDialog(
      CartState cartState, CheckoutState checkoutState) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const CustomText(text: 'Confirm Order', fontWeight: FontWeight.bold),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomText(text: 'Please confirm your order details:', fontSize: 16),
                const SizedBox(height: 15),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: CustomText(text: checkoutState.phone),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: CustomText(text: checkoutState.address),
                ),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(text: 'Total Cost:', fontWeight: FontWeight.bold),
                    CustomText(
                      text: '\$${cartState.totalCost.toStringAsFixed(2)}',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const CustomText(text: 'Cancel', color: Colors.grey),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: CustomText(text: 'Confirm', color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showSuccessDialog();
              },
            ),
          ],
        );
      },
    );
  }

  // --- UPDATED: Main validation function ---
  void _validateAndPay(CartState cartState, CheckoutState checkoutState) {
    if (!checkoutState.isContactInfoComplete || !checkoutState.isAddressComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete your contact info and address.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (formKey.currentState!.validate()) {
      // If card is valid, show the confirmation dialog
      _showConfirmationDialog(cartState, checkoutState);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid card details. Please check and try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartState = context.watch<CartCubit>().state;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppbar(
          titleText: 'Checkout',
          leftIcon: Icons.arrow_back_ios_new,
          onLeftIconPressed: () => Navigator.of(context).pop(),
        ),
        body: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, checkoutState) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoSection(
                          context: context,
                          theme: theme,
                          title: 'Contact Information',
                          isComplete: checkoutState.isContactInfoComplete,
                          children: [
                            _buildInfoTile(
                              icon: Icons.email_outlined,
                              title: checkoutState.email,
                              subtitle: 'Email',
                            ),
                            _buildInfoTile(
                              icon: Icons.phone_outlined,
                              title: checkoutState.phone.isNotEmpty ? checkoutState.phone : 'Add Phone Number',
                              subtitle: 'Phone',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInfoSection(
                          context: context,
                          theme: theme,
                          title: 'Address',
                          isComplete: checkoutState.isAddressComplete,
                          children: [
                            _buildInfoTile(
                              icon: Icons.location_on_outlined,
                              title: checkoutState.address.isNotEmpty ? checkoutState.address : 'Add Address',
                              subtitle: 'Address',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CreditCardWidget(
                          cardNumber: cardNumber,
                          expiryDate: expiryDate,
                          cardHolderName: cardHolderName,
                          cvvCode: cvvCode,
                          showBackView: isCvvFocused,
                          onCreditCardWidgetChange: (brand) {},
                          cardBgColor: theme.colorScheme.primary,
                          labelCardHolder: 'CARD HOLDER',
                          isHolderNameVisible: true,
                        ),
                        CreditCardForm(
                          formKey: formKey,
                          onCreditCardModelChange: _onCreditCardModelChange,
                          cardNumber: cardNumber,
                          expiryDate: expiryDate,
                          cardHolderName: cardHolderName,
                          cvvCode: cvvCode,
                          isCardHolderNameUpperCase: true,
                          isHolderNameVisible: true,
                          inputConfiguration: const InputConfiguration(
                            cardNumberDecoration: InputDecoration(labelText: 'Card Number', hintText: 'XXXX XXXX XXXX XXXX'),
                            expiryDateDecoration: InputDecoration(labelText: 'Expired Date', hintText: 'MM/YY'),
                            cvvCodeDecoration: InputDecoration(labelText: 'CVV', hintText: 'XXX'),
                            cardHolderDecoration: InputDecoration(labelText: 'Card Holder'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildCheckoutSummary(context, cartState, checkoutState, theme),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required BuildContext context,
    required ThemeData theme,
    required String title,
    required bool isComplete,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: title, fontSize: 18, fontWeight: FontWeight.bold),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              ...children,
              if (!isComplete)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.editProfilePage)
                          .then((_) => context.read<CheckoutCubit>().loadUserData());
                    },
                    child: const CustomText(text: 'Add Info', color: Colors.orange),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: CustomText(text: title, fontWeight: FontWeight.w500),
      subtitle: CustomText(text: subtitle),
      trailing: IconButton(
        icon: const Icon(Icons.edit, size: 20),
        onPressed: () {
          Navigator.pushNamed(context, RouteNames.editProfilePage)
              .then((_) => context.read<CheckoutCubit>().loadUserData());
        },
      ),
    );
  }

  Widget _buildCheckoutSummary(
      BuildContext context, CartState cartState, CheckoutState checkoutState, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(text: 'Total Cost', fontSize: 20, fontWeight: FontWeight.bold),
              CustomText(
                text: '\$${cartState.totalCost.toStringAsFixed(2)}',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            onPressed: () => _validateAndPay(cartState, checkoutState),
            child: const CustomText(
              text: 'Payment',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
