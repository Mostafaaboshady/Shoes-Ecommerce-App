import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:final_project/core/widgets/custom_text.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.signal_wifi_off,
                size: 120,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
              const SizedBox(height: 30),
              const CustomText(
                text: 'No Internet Connection',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 15),
              const CustomText(
                text:
                'It looks like you\'re offline. Please check your Wi-Fi or mobile data settings and try again.',
                textAlign: TextAlign.center,
                fontSize: 16,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  bool hasInternet = await _checkInternetConnection();
                  if (hasInternet && context.mounted) {
                    Navigator.of(context).pop();
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Still no internet connection. Please check your settings.'),
                        backgroundColor: theme.colorScheme.error,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const CustomText(
                  text: 'Try Again',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
