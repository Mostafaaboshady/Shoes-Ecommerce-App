import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_project/core/routes/route_names.dart';
import 'package:final_project/core/widgets/custom_button.dart';
import 'package:final_project/core/widgets/custom_text.dart';
import 'package:final_project/core/widgets/custom_text_form_field.dart';
import 'package:final_project/core/widgets/google_signin_button.dart';
import 'package:final_project/features/auth/presentation/cubit/auth_cubit.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

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
            _showSnackBar("Login Successful!", isError: false);
            Navigator.pushReplacementNamed(context, RouteNames.home);
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
                            text: 'Hello Again!',
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                        const CustomText(
                          text: 'Welcome Back You’ve Been Missed!',
                          fontSize: 20,
                        ),
                        const SizedBox(height: 70),
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
                          validator: (v) =>
                          v!.isEmpty ? 'Please enter your password' : null,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, RouteNames.recovery),
                            child: const CustomText(
                              text: 'Recovery Password',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            return CustomButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                if (_keyForm.currentState!.validate()) {
                                  context.read<AuthCubit>().signIn(
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
                                  text: 'Log In',
                                  fontSize: 20,
                                  color: Colors.white),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        GoogleSigninButton(
                          onPressed: () =>
                              context.read<AuthCubit>().signInWithGoogle(),
                          text: "Login in with Google",
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CustomText(
                              text: 'Don’t have an account?',
                              fontSize: 16,
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, RouteNames.signup),
                              child: const CustomText(
                                  text: 'Sign Up for free',
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
