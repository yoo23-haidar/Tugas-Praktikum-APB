import 'package:flutter/material.dart';
import 'package:barber_staff_app/core/theme/app_colors.dart';
import 'package:barber_staff_app/core/theme/app_text_styles.dart';
import 'package:barber_staff_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:barber_staff_app/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:barber_staff_app/features/salary/presentation/screens/salary_screen.dart';
import 'package:barber_staff_app/features/documentation/presentation/screens/documentation_screen.dart';
import 'package:barber_staff_app/features/profile/presentation/screens/profile_screen.dart';

/// Main app shell with bottom navigation.
///
/// Hosts all 5 primary features as tabs:
/// Dashboard · Attendance · Documentation · Salary · Profile
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    DashboardScreen(),
    AttendanceScreen(),
    DocumentationScreen(),
    SalaryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.cardBg,
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.dashboard_outlined,
                    Icons.dashboard, 'HOME'),
                _buildNavItem(1, Icons.access_time_outlined,
                    Icons.access_time_filled, 'ATTEND'),
                _buildNavItem(2, Icons.camera_alt_outlined,
                    Icons.camera_alt, 'PHOTOS'),
                _buildNavItem(3, Icons.account_balance_wallet_outlined,
                    Icons.account_balance_wallet, 'SALARY'),
                _buildNavItem(4, Icons.person_outline,
                    Icons.person, 'PROFILE'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData iconOutlined,
    IconData iconFilled,
    String label,
  ) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active indicator bar
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isActive ? 24 : 0,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: AppColors.accentOrange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(
              isActive ? iconFilled : iconOutlined,
              size: 22,
              color: isActive ? AppColors.accentOrange : AppColors.textLow,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 9,
                color: isActive ? AppColors.accentOrange : AppColors.textLow,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
