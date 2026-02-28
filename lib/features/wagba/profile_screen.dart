import 'package:dual_role_delivery_app/application/auth/auth_controller.dart';
import 'package:dual_role_delivery_app/core/theme/wagba_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProfileProvider);
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
    _addressController = TextEditingController(text: user.address);
    _cityController = TextEditingController(text: user.city);
    _countryController = TextEditingController(text: user.country);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: WagbaColors.background,
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: WagbaColors.primary,
                  child: Text('D', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.city,
                      style: const TextStyle(color: WagbaColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            _ProfileField(label: 'Full Name', controller: _nameController),
            const SizedBox(height: 12),
            _ProfileField(label: 'Email', controller: _emailController),
            const SizedBox(height: 12),
            _ProfileField(label: 'Phone', controller: _phoneController),
            const SizedBox(height: 12),
            _ProfileField(label: 'Address', controller: _addressController),
            const SizedBox(height: 12),
            _ProfileField(label: 'City', controller: _cityController),
            const SizedBox(height: 12),
            _ProfileField(label: 'Country', controller: _countryController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updated = user.copyWith(
                  name: _nameController.text.trim().isEmpty
                      ? 'don'
                      : _nameController.text.trim(),
                  email: _emailController.text.trim().isEmpty
                      ? user.email
                      : _emailController.text.trim(),
                  phone: _phoneController.text.trim(),
                  address: _addressController.text.trim(),
                  city: _cityController.text.trim(),
                  country: _countryController.text.trim(),
                );
                await ref.read(userProfileProvider.notifier).saveProfile(updated);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated')),
                );
              },
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.go('/orders'),
              child: const Text('My Orders'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).signOut();
                if (!context.mounted) return;
                context.go('/sign-in');
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _ProfileField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}
