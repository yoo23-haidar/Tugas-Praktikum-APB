import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barber_staff_app/core/theme/theme.dart';
import 'package:barber_staff_app/core/services/service_locator.dart';
import 'package:barber_staff_app/features/auth/presentation/screens/login_screen.dart';
import 'package:barber_staff_app/core/widgets/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Initialize service layer (mock mode for development) ────
  ServiceLocator.init(useMock: true);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0A0A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const StaffApp());
}

class StaffApp extends StatefulWidget {
  const StaffApp({super.key});

  @override
  State<StaffApp> createState() => _StaffAppState();
}

class _StaffAppState extends State<StaffApp> {
  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barbershop Staff App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: _isAuthenticated
          ? const MainShell()
          : LoginScreen(
              onLoginSuccess: () {
                setState(() => _isAuthenticated = true);
              },
            ),
    );
  }
}
