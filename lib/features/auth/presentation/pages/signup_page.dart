import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_project/core/routes/route_names.dart';
import 'package:final_project/core/widgets/custom_button.dart';
import 'package:final_project/core/widgets/custom_text.dart';
import 'package:final_project/core/widgets/custom_text_form_field.dart';
import 'package:final_project/core/widgets/google_signin_button.dart';
import 'package:final_project/features/auth/presentation/cubit/auth_cubit.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void _showSnackBar(String message, {bool isError = true}) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ));
    }

    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            _showSnackBar("Account created successfully!", isError: false);
            Navigator.pushNamedAndRemoveUntil(
                context, RouteNames.home, (route) => false);
          } else if (state is AuthError) {
            _showSnackBar(state.message);
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
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
                            text: 'Create Account',
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                        const CustomText(
                          text: 'Let’s Create Account Together',
                          fontSize: 20,
                        ),
                        const SizedBox(height: 50),
                        CustomTextFormField(
                          controller: nameController,
                          text: 'Your Name',
                          textInputAction: TextInputAction.next,
                          validator: (v) =>
                          v!.isEmpty ? 'Please enter your name' : null,
                        ),
                        const SizedBox(height: 15),
                        CustomTextFormField(
                          controller: emailController,
                          text: 'Email Address',
                          textInputAction: TextInputAction.next,
                          validator: (v) {
                            if (v!.isEmpty) return 'Please enter your email';
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v))
                              return 'Please enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomTextFormField(
                          controller: passwordController,
                          text: 'Password',
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          validator: (v) {
                            if (v!.isEmpty) return 'Please enter your password';
                            if (v.length < 6)
                              return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            return CustomButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                if (_keyForm.currentState!.validate()) {
                                  context.read<AuthCubit>().signUp(
                                    email:
                                    emailController.text.trim(),
                                    password:
                                    passwordController.text.trim(),
                                  );
                                }
                              },
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                  color: Colors.white)
                                  : const CustomText(
                                  text: 'Sign Up',
                                  fontSize: 20,
                                  color: Colors.white),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        GoogleSigninButton(
                          onPressed: () =>
                              context.read<AuthCubit>().signInWithGoogle(),
                          text: "Sign up with Google",
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CustomText(
                                text: 'Already have an account?', fontSize: 16),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, RouteNames.login),
                              child: const CustomText(
                                  text: 'Log In',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )
                      ],
                    ),
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
