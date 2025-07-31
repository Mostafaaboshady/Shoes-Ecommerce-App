import 'package:final_project/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    this.rightIcon,
    required this.leftIcon,
    required this.titleText,
    this.showLocation = false,
    this.onLeftIconPressed,
    this.onRightIconPressed,
  });

  final Widget? rightIcon;
  final IconData leftIcon;
  final String titleText;
  final bool showLocation;
  final VoidCallback? onLeftIconPressed;
  final VoidCallback? onRightIconPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Container(
          decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: [
                if (!isDarkMode)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
              ]),
          child: IconButton(
            icon: Icon(leftIcon, color: theme.colorScheme.onSurface),
            onPressed: onLeftIconPressed,
          ),
        ),
      ),
      title: showLocation
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomText(
            text: 'Store location',
            fontSize: 14,
            color: Colors.grey,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_pin,
                color: theme.colorScheme.secondary,
                size: 20,
              ),
              const SizedBox(width: 4),
              CustomText(
                text: titleText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      )
          : Center(
        child: CustomText(
          text: titleText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        if (rightIcon != null)
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (!isDarkMode)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                  ]),
              child: IconButton(
                onPressed: onRightIconPressed,
                icon: rightIcon!,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}
