import 'dart:io';
import 'package:final_project/core/routes/route_names.dart';
import 'package:final_project/core/widgets/custom_text.dart';
import 'package:final_project/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSideMenu extends StatefulWidget {
  const CustomSideMenu({super.key});

  @override
  State<CustomSideMenu> createState() => _CustomSideMenuState();
}

class _CustomSideMenuState extends State<CustomSideMenu> {
  String _displayName = "User Name";
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _displayName = prefs.getString('userName') ?? user?.displayName ?? 'User Name';
      final imagePath = prefs.getString('userImagePath');
      _image = imagePath != null ? File(imagePath) : null;
    });
  }

  ImageProvider<Object>? _getImageProvider() {
    if (_image != null) {
      return FileImage(_image!);
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user?.photoURL != null && user!.photoURL!.isNotEmpty) {
      return NetworkImage(user.photoURL!);
    }
    return null;
  }

  Future<void> _showSignOutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const CustomText(text: 'Sign Out', fontWeight: FontWeight.bold),
          content: const SingleChildScrollView(
            child: CustomText(text: 'Are you sure you want to sign out?'),
          ),
          actions: <Widget>[
            TextButton(
              child: const CustomText(text: 'No', color: Colors.grey),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const CustomText(text: 'Yes', color: Colors.red),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
                await context.read<AuthCubit>().signOut();
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteNames.login, (Route<dynamic> route) => false);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _loadProfileData();
    final imageProvider = _getImageProvider();

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Container(
        color: const Color(0xff1f222a),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white24,
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? const Icon(Icons.person, size: 30, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 15),
                    const CustomText(text: "Hey, 👋", fontSize: 16, color: Colors.white70),
                    const SizedBox(height: 5),
                    CustomText(
                      text: _displayName,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: "Profile",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, RouteNames.accountPage);
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.favorite_border,
                      title: "Favorite",
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Navigate to Favorites')),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: "Settings",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, RouteNames.settingsPage);
                      },
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Divider(color: Colors.white24),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                child: _buildMenuItem(
                  icon: Icons.logout,
                  title: "Sign Out",
                  onTap: () => _showSignOutDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: CustomText(text: title, color: Colors.white, fontSize: 16),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: Colors.white10,
    );
  }
}
