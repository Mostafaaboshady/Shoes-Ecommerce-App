import 'package:final_project/core/routes/route_names.dart';
import 'package:final_project/core/widgets/custom_appbar.dart';
import 'package:final_project/core/widgets/custom_text.dart';
import 'package:final_project/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const CustomText(text: 'Delete Account', fontWeight: FontWeight.bold),
          content: const CustomText(text: 'Are you sure? This action is permanent and cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const CustomText(text: 'Cancel', color: Colors.grey),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const CustomText(text: 'Delete', color: Colors.red),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        titleText: 'Account & Settings',
        leftIcon: Icons.arrow_back_ios_new,
        onLeftIconPressed: () => Navigator.of(context).pop(),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(RouteNames.login, (route) => false);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(text: 'Account', fontSize: 18, fontWeight: FontWeight.bold),
              const SizedBox(height: 10),
              _buildSettingsCard(
                context,
                children: [
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.edit_outlined,
                    title: 'Edit Profile',
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.editProfilePage);
                    },
                  ),
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.delete_outline,
                    title: 'Delete Account',
                    color: Colors.red,
                    onTap: () => _showDeleteAccountDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const CustomText(text: 'App Settings', fontSize: 18, fontWeight: FontWeight.bold),
              const SizedBox(height: 10),
              _buildSettingsCard(
                context,
                children: [
                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, state) {
                      final isDarkMode = state == ThemeMode.dark;
                      return _buildSwitchItem(
                        context: context,
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        value: isDarkMode,
                        onChanged: (value) {
                          context.read<ThemeCubit>().toggleTheme(value);
                        },
                      );
                    },
                  ),
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.language_outlined,
                    title: 'Language',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Language settings coming soon!')));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Theme.of(context).iconTheme.color),
      title: CustomText(text: title, color: color),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Theme.of(context).iconTheme.color),
      title: CustomText(text: title, color: color),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
