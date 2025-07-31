import 'package:flutter/material.dart';

class NavBarItem {
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;

  NavBarItem({
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
  });
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final double iconSize = 28.0;
  final double circleSize = 60.0;

  final List<NavBarItem> items = [

    NavBarItem(
        selectedIcon: Icons.favorite,
        unselectedIcon: Icons.favorite_border,
        label: 'Favorites'),
    NavBarItem(
        selectedIcon: Icons.shopping_bag,
        unselectedIcon: Icons.shopping_bag_outlined,
        label: 'Shopping'),
    NavBarItem(
        selectedIcon: Icons.person,
        unselectedIcon: Icons.person_outline,
        label: 'Profile'),
  ];

  CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final double itemWidth = screenWidth / items.length;
    final double circleXPos =
        (itemWidth * selectedIndex) + (itemWidth / 2) - (circleSize / 2);

    return SizedBox(
      height: 85,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: CustomNavBarClipper(
                selectedIndex: selectedIndex,
                itemWidth: itemWidth,
              ),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    if (!isDarkMode)
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -2)),
                  ],
                ),
                child: Row(
                  children: List.generate(items.length, (index) {
                    return _buildNavItem(index, itemWidth, theme);
                  }),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: circleXPos,
            top: -15,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2),
                ],
              ),
              child: Icon(items[selectedIndex].selectedIcon,
                  color: theme.colorScheme.onPrimary, size: iconSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, double itemWidth, ThemeData theme) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        width: itemWidth,
        height: 70,
        color: Colors.transparent,
        child: Icon(
          items[index].unselectedIcon,
          color: isSelected
              ? Colors.transparent
              : theme.textTheme.bodyMedium?.color,
          size: iconSize,
        ),
      ),
    );
  }
}

class CustomNavBarClipper extends CustomClipper<Path> {
  final int selectedIndex;
  final double itemWidth;
  final double notchRadius = 35.0;
  final double notchDepth = 35.0;

  CustomNavBarClipper({required this.selectedIndex, required this.itemWidth});

  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    final notchCenterX = (itemWidth * selectedIndex) + (itemWidth / 2);

    path.moveTo(0, 0);
    path.lineTo(notchCenterX - notchRadius * 1.5, 0);
    path.quadraticBezierTo(
        notchCenterX - notchRadius, 0, notchCenterX - notchRadius, notchDepth / 2);
    path.quadraticBezierTo(
        notchCenterX, notchDepth, notchCenterX + notchRadius, notchDepth / 2);
    path.quadraticBezierTo(
        notchCenterX + notchRadius, 0, notchCenterX + notchRadius * 1.5, 0);
    path.lineTo(width, 0);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomNavBarClipper oldClipper) {
    return oldClipper.selectedIndex != selectedIndex;
  }
}
