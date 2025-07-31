import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/services/firebase_auth_service.dart';
import 'package:final_project/core/widgets/custom_button.dart';
import 'package:final_project/core/widgets/custom_text.dart';
import 'package:final_project/core/widgets/custom_text_form_field.dart';

class RecoveryPage extends StatefulWidget {
  const RecoveryPage({super.key});

  @override
  State<RecoveryPage> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  final FirebaseAuthService _authService = FirebaseAuthService();

  bool _isLoading = false;

  void _showSnackBar(String message, {bool isError = true}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    }
  }

  Future<void> _sendRecoveryEmail() async {
    if (!_keyForm.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.sendPasswordResetEmail(emailController.text.trim());
      _showSnackBar("Password reset email sent! Please check your inbox.",
          isError: false);
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message = "Failed to send reset email. Please try again.";
      if (e.code == 'user-not-found') {
        message = "No user found for that email. Please check the address.";
      }
      _showSnackBar(message);
    } catch (e) {
      _showSnackBar("An unexpected error occurred.");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Form(
                  key: _keyForm,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        textAlign: TextAlign.center,
                        text: 'Recovery Password',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      const CustomText(
                        text: 'Please Enter Your Email Address To',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      const CustomText(
                        text: 'Receive a Verification Code',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(height: 70),
                      CustomTextFormField(
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        controller: emailController,
                        text: 'Email Address',
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 50),
                      CustomButton(
                        onPressed: _isLoading ? null : _sendRecoveryEmail,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : const CustomText(
                          text: 'Continue',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
