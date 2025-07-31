import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/auth_cubit.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _passwordController;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _passwordController = TextEditingController();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    _nameController.text = prefs.getString('userName') ?? user?.displayName ?? '';
    _phoneController.text = prefs.getString('userPhone') ?? '';
    _addressController.text = prefs.getString('userAddress') ?? '';
    final imagePath = prefs.getString('userImagePath');
    if (imagePath != null && mounted) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text);
    await prefs.setString('userPhone', _phoneController.text);
    await prefs.setString('userAddress', _addressController.text);
    if (_image != null) {
      await prefs.setString('userImagePath', _image!.path);
    }

    if (_passwordController.text.isNotEmpty) {
      if (_passwordController.text.length < 6) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password must be at least 6 characters'), backgroundColor: Colors.red),
        );
        return;
      }
      if (!mounted) return;
      await context.read<AuthCubit>().updatePassword(_passwordController.text);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile Saved!'), backgroundColor: Colors.green),
    );
    context.read<AuthCubit>().checkAuthentication();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image. Please ensure you have granted gallery permissions.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  ImageProvider<Object>? _getImageProvider() {
    final user = FirebaseAuth.instance.currentUser;
    if (_image != null) return FileImage(_image!);
    if (user?.photoURL != null && user!.photoURL!.isNotEmpty) return NetworkImage(user.photoURL!);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _getImageProvider();
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppbar(
          rightIcon: IconButton(
            icon: Icon(Icons.check, color: theme.iconTheme.color),
            onPressed: _saveProfileData,
          ),
          leftIcon: Icons.arrow_back_ios_new,
          titleText: 'Edit Profile',
          onLeftIconPressed: () => Navigator.of(context).pop(),
        ),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: 110,
                  height: 110,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        backgroundImage: imageProvider,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        child: (imageProvider == null)
                            ? Icon(Icons.person, size: 60, color: Colors.grey.shade400)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: -12,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: theme.scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: theme.colorScheme.surface,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, color: theme.iconTheme.color, size: 20),
                              onPressed: _pickImage,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Align(alignment: Alignment.centerLeft, child: CustomText(text: 'Full Name', fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                CustomTextField(controller: _nameController, hintText: 'Enter your full name'),
                const SizedBox(height: 20),
                const Align(alignment: Alignment.centerLeft, child: CustomText(text: 'Phone Number', fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                CustomTextField(controller: _phoneController, hintText: 'Enter your phone number'),
                const SizedBox(height: 20),
                const Align(alignment: Alignment.centerLeft, child: CustomText(text: 'Address', fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                CustomTextField(controller: _addressController, hintText: 'Enter your address'),
                const SizedBox(height: 20),
                const Align(alignment: Alignment.centerLeft, child: CustomText(text: 'New Password', fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Enter new password (optional)',
                  isPassword: true,
                  obscureText: !_isPasswordVisible,
                  onTogglePasswordVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
