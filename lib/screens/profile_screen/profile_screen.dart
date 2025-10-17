import 'package:flutter/material.dart';
import 'package:itsnu_app/screens/auth_screen/auth_screen.dart';
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
    if (createdAtString == null) {
      return null;
    }
    return DateTime.parse(createdAtString);
  }

  // Get user metadata
  String? _getUserData(String key) {
    final Map<String, dynamic>? metaData =
        _supabaseUserService.currentUser?.userMetadata;
    return metaData?[key]?.toString();
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
            style: TextButton.styleFrom(backgroundColor: Colors.red),
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
      if (mounted) {
        // Navigate to login screen and clear all routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
          (route) => false, // Clear all routes
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal keluar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Future<void> _deleteAccount() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(40.0),
                      // Set background image either from user metadata or default
                      image: _getUserData('image_url') != null
                          ? DecorationImage(
                              image: NetworkImage(_getUserData('image_url')!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _getUserData('image_url') == null
                        ? const Icon(
                            Icons.person,
                            size: 40.0,
                            color: Colors.white,
                          )
                        : null,
                  ),

                  const SizedBox(height: 16),

                  // Username or Email
                  Text(
                    _getUserData('name') ?? userEmail,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Show email if username is displayed
                  if (_getUserData('name') != null) ...[
                    // ... is used to expand the list
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ],

                  // Show joined date
                  if (createdAt != null) ...[
                    const SizedBox(height: 4.0),
                    Text(
                      'Bergabung : ${_formatDate(createdAt!)}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white),
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
                  value: _getUserData('name') ?? 'Belum diatur',
                ),
                InfoCardItem(
                  label: 'Nomor Telepon',
                  value: _getUserData('phone') ?? 'Belum diatur',
                ),
                InfoCardItem(
                  label: 'Alamat',
                  value: _getUserData('address') ?? 'Belum diatur',
                ),
              ],
            ),

            SizedBox(height: 24.0),

            // Log out button
            ActionButton(
              icon: Icons.logout,
              label: 'Keluar',
              color: Colors.red,
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
