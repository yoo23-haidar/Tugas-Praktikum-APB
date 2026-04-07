import 'package:flutter/material.dart';
import 'package:barber_staff_app/core/theme/app_colors.dart';
import 'package:barber_staff_app/core/theme/app_text_styles.dart';
import 'package:barber_staff_app/core/services/service_locator.dart';

/// Login screen — the app entry point.
///
/// Accepts email + password, calls [BarberServiceBase.login],
/// and navigates to the main shell on success.
class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController(text: 'rizky@barber.id');
  final _passwordController = TextEditingController(text: 'password');
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _error;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ServiceLocator.barberService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      widget.onLoginSuccess();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Terminal branding ──────────────────────────────
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _pulseAnim.value,
                      child: child,
                    );
                  },
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'BARBERSHOP STAFF',
                  style: AppTextStyles.sectionHeader.copyWith(
                    fontSize: 18,
                    letterSpacing: 6,
                    color: AppColors.textHigh,
                  ),
                ),
                const SizedBox(height: 48),

                // ── Login card ────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LOGIN', style: AppTextStyles.sectionHeader),
                      const SizedBox(height: 20),

                      // Email
                      Text('EMAIL', style: AppTextStyles.metricLabel),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _emailController,
                        style: AppTextStyles.tableCell,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'staff@barber.id',
                          prefixIcon: Icon(Icons.alternate_email,
                              size: 18, color: AppColors.textLow),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Password
                      Text('PASSWORD', style: AppTextStyles.metricLabel),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passwordController,
                        style: AppTextStyles.tableCell,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline,
                              size: 18, color: AppColors.textLow),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 18,
                              color: AppColors.textLow,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Error
                      if (_error != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.accentRed.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.accentRed.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            _error!,
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.accentRed),
                          ),
                        ),

                      // Submit
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.scaffoldBg,
                                  ),
                                )
                              : const Text('AUTHENTICATE'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'v1.0.0 · Secure Connection',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
