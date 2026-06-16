import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Screens/forgot_password_screen.dart';
import 'package:shop_app/Screens/register_screen.dart';
import 'package:shop_app/Services/auth_service.dart';

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
      } on FirebaseAuthException catch (e) {
        String message;

        switch (e.code) {
          case 'user-not-found':
            message = 'لا يوجد حساب مرتبط بهذا البريد الإلكتروني';
            break;

          case 'wrong-password':
          case 'invalid-credential':
            message = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
            break;

          case 'invalid-email':
            message = 'البريد الإلكتروني غير صالح';
            break;

          case 'too-many-requests':
            message = 'تمت عدة محاولات فاشلة، حاول مرة أخرى لاحقاً';
            break;

          default:
            message = 'حدث خطأ أثناء تسجيل الدخول';
        }

        setState(() => _error = message);
      } catch (_) {
        setState(() => _error = 'حدث خطأ غير متوقع');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),

                Icon(Icons.shopping_bag_rounded, size: 90, color: Colors.blue),

                const SizedBox(height: 16),

                const Text(
                  'مرحباً بك',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  'قم بتسجيل الدخول للمتابعة',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),

                const SizedBox(height: 40),

                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'البريد الإلكتروني',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) =>
                              v!.isEmpty ? 'البريد الإلكتروني مطلوب' : null,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (v) =>
                              v!.length < 6 ? 'كلمة المرور قصيرة' : null,
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen(),
                              ),
                            ),
                            child: const Text('نسيت كلمة المرور؟'),
                          ),
                        ),
                        if (_error != null)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              border: Border.all(color: Colors.red.shade200),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _error!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  ),
                  child: const Text('ليس لديك حساب؟ إنشاء حساب جديد'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
