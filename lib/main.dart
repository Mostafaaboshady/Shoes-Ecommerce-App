import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:final_project/core/services/api_service.dart';
import 'package:final_project/core/services/firebase_auth_service.dart';
import 'package:final_project/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:final_project/features/home/presentation/cubit/home_cubit.dart';
import 'package:final_project/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'core/routes/app_router.dart';
import 'core/routes/route_names.dart';
import 'core/services/no_internet_page.dart';
import 'core/themes/app_themes.dart';
import 'core/themes/theme_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/cart/data/presentation/cubit/cart_cubit.dart';
import 'features/favorites/presentation/cubit/favourites_cubit.dart';
import 'features/home/presentation/pages/home_page.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkInitialConnectivity();
    _setupConnectivityListener();
  }

  Future<void> _checkInitialConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    _updateConnectivityStatus(connectivityResult);
  }

  void _setupConnectivityListener() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
          _updateConnectivityStatus(results);
        });
  }

  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    final bool connected = results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet);

    if (mounted && _hasInternet != connected) {
      setState(() {
        _hasInternet = connected;
      });

      final currentRoute = ModalRoute.of(context);
      if (!_hasInternet) {
        if (currentRoute?.settings.name != '/no-internet') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NoInternetPage(),
              settings: const RouteSettings(name: '/no-internet'),
            ),
          );
        }
      } else {
        if (currentRoute?.settings.name == '/no-internet') {
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(FirebaseAuthService()),
        ),
        BlocProvider<OnboardingCubit>(
          create: (context) => OnboardingCubit(),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(ApiService())..fetchProducts(),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (context) => FavoritesCubit(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Kutuku',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeMode,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: RouteNames.splash,
            routes: {
              RouteNames.noInternetPage: (context) => const NoInternetPage(),
              RouteNames.login: (context) => LoginPage(),
              RouteNames.home: (context) => const HomePage(),
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkInitialConnectivity();
    }
  }
}
