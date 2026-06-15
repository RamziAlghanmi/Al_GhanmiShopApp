import 'package:flutter/material.dart';
import 'package:shop_app/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final AuthService _auth = AuthService();
  String? _error;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.registerWithEmail(
          _emailController.text.trim(),
          _passController.text.trim(),
        );
        // نجاح، يتم الانتقال تلقائياً
      } catch (e) {
        setState(() => _error = e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إنشاء حساب')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
              ),
              TextFormField(
                controller: _passController,
                decoration: InputDecoration(labelText: 'كلمة المرور'),
                obscureText: true,
              ),
              if (_error != null)
                Text(_error!, style: TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _register,
                child: Text('تسجيل'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}