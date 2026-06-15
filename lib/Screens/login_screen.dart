import 'package:flutter/material.dart';
import 'package:shop_app/screens/forgot_password_screen.dart';
import 'package:shop_app/screens/register_screen.dart';
import 'package:shop_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final AuthService _auth = AuthService();
  String? _error;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.loginWithEmail(
          _emailController.text.trim(),
          _passController.text.trim(),
        );
        // سيتم الانتقال تلقائياً بفضل StreamBuilder في main.dart
      } catch (e) {
        setState(() => _error = e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                controller: _passController,
                decoration: const InputDecoration(labelText: 'كلمة المرور'),
                obscureText: true,
                validator: (v) => v!.length < 6 ? 'كلمة المرور قصيرة' : null,
              ),
              const SizedBox(height: 20),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _login,
                child: const Text('دخول'),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterScreen()),
                ),
                child: const Text('ليس لديك حساب؟ أنشئ حساباً'),
              ),
              // زر نسيت كلمة المرور
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                ),
                child: const Text('نسيت كلمة المرور؟'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}