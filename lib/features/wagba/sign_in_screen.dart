import 'package:dual_role_delivery_app/application/auth/auth_controller.dart';
import 'package:dual_role_delivery_app/core/theme/wagba_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(text: 'don');
  final _phoneController = TextEditingController(text: '+91 90000 00000');
  bool _isSignUp = false;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Email and password are required.';
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final auth = ref.read(authControllerProvider.notifier);
    if (_isSignUp) {
      await auth.signUp(
        name: _nameController.text.trim().isEmpty ? 'don' : _nameController.text.trim(),
        email: email,
        password: password,
        phone: _phoneController.text.trim(),
      );
      if (!mounted) return;
      context.go('/home');
    } else {
      final ok = await auth.signIn(email: email, password: password);
      if (!mounted) return;
      if (ok) {
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid credentials. Try Sign Up.')),
        );
        setState(() {
          _error = 'No account found. Use Sign Up to create one.';
        });
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Enter your email to reset password.');
      return;
    }
    final ok = await ref
        .read(authControllerProvider.notifier)
        .resetPassword(email: email, newPassword: 'don1234');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? 'Password reset to don1234 (local)'
            : 'No account found for $email'),
      ),
    );
  }

  Future<void> _quickSocial(String provider) async {
    setState(() => _isLoading = true);
    await ref.read(authControllerProvider.notifier).signUp(
          name: 'don',
          email: 'don@$provider.com',
          password: 'don1234',
          phone: '+91 90000 00000',
        );
    if (!mounted) return;
    context.go('/home');
  }

  Future<void> _continueAsDon() async {
    setState(() => _isLoading = true);
    await ref.read(authControllerProvider.notifier).signUp(
          name: 'don',
          email: 'don@example.com',
          password: 'don1234',
          phone: '+91 90000 00000',
        );
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WagbaColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isSignUp ? 'Create Account' : 'Sign In',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Location: Mumbai, India',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: WagbaColors.textSecondary),
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[
                Text(
                  _error!,
                  style: const TextStyle(color: WagbaColors.accentRed),
                ),
                const SizedBox(height: 12),
              ],
              if (_isSignUp) ...[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'name@email.com',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: '********',
                ),
              ),
              if (_isSignUp) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _resetPassword,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: WagbaColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: Text(_isSignUp ? 'Create Account' : 'Sign In'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _isLoading ? null : _continueAsDon,
                child: const Text('Continue as don'),
              ),
              const SizedBox(height: 24),
              Text(
                'Or continue with',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: WagbaColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _quickSocial('facebook'),
                      icon: const Icon(Icons.facebook, color: Colors.white),
                      label: const Text('Facebook'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _quickSocial('google'),
                      icon: const Icon(Icons.g_mobiledata, color: Colors.white),
                      label: const Text('Google'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _quickSocial('apple'),
                      icon: const Icon(Icons.apple, color: Colors.white),
                      label: const Text('Apple'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isSignUp ? 'Already have an account? ' : 'Don\'t have an account? ',
                    style: const TextStyle(color: WagbaColors.textSecondary),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _isSignUp = !_isSignUp),
                    child: Text(_isSignUp ? 'Sign In' : 'Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
