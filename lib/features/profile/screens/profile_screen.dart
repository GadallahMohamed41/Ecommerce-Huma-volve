import 'package:flutter/material.dart';

import '../../../core/services/firebase_auth_service.dart';
import '../../../core/theme.dart';
import '../../auth/login/screens/login_screen.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _resolveDisplayName(String? displayName, String? email) {
    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName.trim();
    }

    if (email != null && email.contains('@')) {
      final prefix = email.split('@').first;
      final parts = prefix.split(RegExp(r'[._\-]'));
      final formatted = parts
          .where((part) => part.isNotEmpty)
          .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
          .join(' ');
      if (formatted.isNotEmpty) {
        return formatted;
      }
    }

    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuthService().currentUser;
    final userName = _resolveDisplayName(
      firebaseUser?.displayName,
      firebaseUser?.email,
    );
    final userEmail = firebaseUser?.email ?? '';
    final userAvatar = firebaseUser?.photoURL;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: userAvatar != null && userAvatar.isNotEmpty
                        ? Image.network(
                            userAvatar,
                            width: 112,
                            height: 112,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 112,
                              height: 112,
                              color: AppTheme.primary,
                              child: const Icon(Icons.person, size: 56, color: Colors.white),
                            ),
                          )
                        : Container(
                            width: 112,
                            height: 112,
                            color: AppTheme.primary,
                            child: const Icon(Icons.person, size: 56, color: Colors.white),
                          ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  ProfileMenuItem(
                    icon: Icons.shopping_bag_outlined,
                    title: 'My Orders',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.favorite_border,
                    title: 'Wishlist',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Shipping Addresses',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.payment_outlined,
                    title: 'Payment Methods',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    isDestructive: true,
                    onTap: () async {
                      await FirebaseAuthService().signOut();
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
