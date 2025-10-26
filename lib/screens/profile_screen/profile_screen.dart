import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsnu_app/screens/profile_screen/action_button.dart';
import 'package:itsnu_app/screens/profile_screen/info_card.dart';
import 'package:itsnu_app/screens/profile_screen/info_card_item.dart';
import 'package:itsnu_app/services/supabase_user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseUserService _supabaseUserService = SupabaseUserService();
  bool _isLoading = false;

  String get userEmail => _supabaseUserService.currentUser?.email ?? '';
  String get userId => _supabaseUserService.currentUser?.id ?? '';
  DateTime? get createdAt {
    final String? createdAtString = _supabaseUserService.currentUser?.createdAt;

    if (createdAtString == null) return null;

    return DateTime.parse(createdAtString);
  }

  // Get user metadata
  Map<String, dynamic> _getUserData() {
    final Map<String, dynamic>? metaData =
        _supabaseUserService.currentUser?.userMetadata;
    return metaData!;
  }

  Map<String, dynamic> get _userData => _getUserData();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Object? extra = GoRouterState.of(context).extra;
    if (extra is Map && extra['refresh'] == true) {
      _getUserData();
    }
  }

  // Logout function
  Future<void> _logOut() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.grey),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),

          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(
              context,
            ).pop(true), // .pop(true) is used to confirm logout
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    // Check if logout is confirmed
    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _supabaseUserService.logOut();

      if (!mounted) return;

      // Navigate to login screen and clear all routes
      GoRouter.of(context).go('/auth');
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal keluar: $e',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      }
    }
  }

  // Future<void> _deleteAccount() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(40.0),
                      // Set background image either from user metadata or default
                      image: _userData['image_url'] != null
                          ? DecorationImage(
                              image: NetworkImage(_userData['image_url']),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _userData['image_url'] == null
                        ? Icon(
                            Icons.person,
                            size: 40.0,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        : null,
                  ),

                  const SizedBox(height: 16),

                  // Username or Email
                  Text(
                    _userData['name'] ?? userEmail,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),

                  // Show email if username is displayed
                  if (_userData['name'] != null) ...[
                    // ... is used to expand the list
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],

                  // Show joined date
                  if (createdAt != null) ...[
                    const SizedBox(height: 4.0),
                    Text(
                      'Bergabung : ${_formatDate(createdAt!)}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24.0),

            // Personal information
            InfoCard(
              title: 'Informasi Personal',
              children: [
                InfoCardItem(
                  label: 'Nama',
                  value: _userData['name'] ?? 'Belum diatur',
                ),
                InfoCardItem(
                  label: 'Nomor Telepon',
                  value: _userData['phone'] ?? 'Belum diatur',
                ),
                InfoCardItem(
                  label: 'Alamat',
                  value: _userData['address'] ?? 'Belum diatur',
                ),
              ],
            ),

            SizedBox(height: 24.0),

            // Edit profile button
            ActionButton(
              icon: Icons.edit,
              label: 'Edit Profil',
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                GoRouter.of(context).go('/profile/edit');
              },
            ),

            SizedBox(height: 16.0),

            // Log out button
            ActionButton(
              icon: Icons.logout,
              label: 'Keluar',
              color: Theme.of(context).colorScheme.error,
              onPressed: _isLoading ? null : _logOut,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
