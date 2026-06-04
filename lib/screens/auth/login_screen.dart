import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../database/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final db = await DatabaseHelper.instance.database;
      final users = await db.query('users',
          where: 'username = ? AND password = ? AND is_active = 1',
          whereArgs: [
            _usernameController.text.trim(),
            _passwordController.text
          ]);
      if (users.isNotEmpty) {
        await db.update('users',
            {'last_login': DateTime.now().toIso8601String()},
            where: 'id = ?', whereArgs: [users.first['id']]);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('ورود موفقیت آمیز'),
                backgroundColor: AppTheme.successColor),
          );
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('نام کاربری یا رمز عبور اشتباه است'),
                backgroundColor: AppTheme.errorColor),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('خطا: $e'),
              backgroundColor: AppTheme.errorColor),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [AppTheme.primaryColor, AppTheme.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Card(
                  elevation: 12,
                  shadowColor: Colors.black38,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppTheme.primaryColor,
                                  AppTheme.primaryLight
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppTheme.primaryColor.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.account_balance_wallet,
                                    size: 40, color: AppTheme.secondaryColor),
                                SizedBox(height: 4),
                                Text('ح س',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text('حسابداری سازمان',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor)),
                          const SizedBox(height: 8),
                          const Text('سیستم مدیریت حقوق و بدهی مبارزین',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary)),
                          const SizedBox(height: 40),
                          TextFormField(
                            controller: _usernameController,
                            textDirection: TextDirection.rtl,
                            decoration: const InputDecoration(
                              labelText: 'نام کاربری',
                              prefixIcon: Icon(Icons.person_outline,
                                  color: AppTheme.primaryColor),
                            ),
                            validator: (v) =>
                                v?.isEmpty == true ? 'نام کاربری الزامی است' : null,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textDirection: TextDirection.rtl,
                            decoration: InputDecoration(
                              labelText: 'رمز عبور',
                              prefixIcon: const Icon(Icons.lock_outline,
                                  color: AppTheme.primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppTheme.textSecondary,
                                ),
                                onPressed: () => setState(() =>
                                    _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (v) =>
                                v?.isEmpty == true ? 'رمز عبور الزامی است' : null,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2),
                                    )
                                  : const Text('ورود به سیستم',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('نسخه 1.0.0',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
