import 'package:flutter/material.dart';
import 'package:barber_staff_app/core/theme/app_colors.dart';
import 'package:barber_staff_app/core/theme/app_text_styles.dart';
import 'package:barber_staff_app/core/models/staff_profile.dart';
import 'package:barber_staff_app/core/services/service_locator.dart';

/// Staff Profile screen — view and edit personal information.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  StaffProfile? _profile;
  bool _isLoading = true;
  bool _isEditing = false;

  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _bioCtrl = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await ServiceLocator.barberService.getProfile();
      setState(() {
        _profile = profile;
        _nameCtrl.text = profile.name;
        _phoneCtrl.text = profile.phone;
        _emailCtrl.text = profile.email;
        _bioCtrl.text = profile.bio ?? '';
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (_profile == null) return;
    setState(() => _isLoading = true);
    try {
      final updated = _profile!.copyWith(
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        bio: _bioCtrl.text.trim(),
      );
      final result = await ServiceLocator.barberService.updateProfile(updated);
      setState(() {
        _profile = result;
        _isEditing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated', style: AppTextStyles.caption.copyWith(color: AppColors.scaffoldBg)),
            backgroundColor: AppColors.accentGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        title: Text('STAFF PROFILE', style: AppTextStyles.sectionHeader.copyWith(fontSize: 14)),
        centerTitle: true,
        actions: [
          if (_profile != null && !_isEditing)
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () => setState(() {
                _isEditing = false;
                // Reset controllers
                _nameCtrl.text = _profile!.name;
                _phoneCtrl.text = _profile!.phone;
                _emailCtrl.text = _profile!.email;
                _bioCtrl.text = _profile!.bio ?? '';
              }),
            ),
        ],
      ),
      body: _isLoading && _profile == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accentOrange))
          : _profile == null
              ? Center(
                  child: Text('Failed to load profile',
                      style: AppTextStyles.alertBody))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // ── Avatar ──────────────────────────────────
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.cardBg,
                          border: Border.all(
                            color: AppColors.accentOrange,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _profile!.name.isNotEmpty
                                ? _profile!.name[0].toUpperCase()
                                : '?',
                            style: AppTextStyles.metricValue.copyWith(
                              fontSize: 36,
                              color: AppColors.accentOrange,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (!_isEditing) ...[
                        Text(_profile!.name,
                            style: AppTextStyles.alertTitle
                                .copyWith(fontSize: 18)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentOrange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _profile!.role.toUpperCase(),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.accentOrange,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // ── Info card / Edit form ───────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEditing ? 'EDIT PROFILE' : 'PROFILE INFO',
                              style: AppTextStyles.sectionHeader,
                            ),
                            const SizedBox(height: 16),
                            _buildField('NAME', _nameCtrl, _isEditing),
                            _buildField('EMAIL', _emailCtrl, _isEditing),
                            _buildField('PHONE', _phoneCtrl, _isEditing),
                            _buildField('BIO', _bioCtrl, _isEditing,
                                maxLines: 3),
                            if (!_isEditing) ...[
                              const Divider(color: AppColors.divider, height: 24),
                              _buildReadOnlyRow(
                                  'BARBERSHOP', _profile!.barbershopName),
                              _buildReadOnlyRow(
                                  'STATUS', _profile!.status.toUpperCase()),
                              _buildReadOnlyRow('MEMBER SINCE',
                                  '${_profile!.createdAt.day}/${_profile!.createdAt.month}/${_profile!.createdAt.year}'),
                            ],
                          ],
                        ),
                      ),

                      // ── Save button ─────────────────────────────
                      if (_isEditing) ...[
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveProfile,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.scaffoldBg,
                                    ),
                                  )
                                : const Text('SAVE CHANGES'),
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl,
    bool editable, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.metricLabel),
          const SizedBox(height: 6),
          editable
              ? TextField(
                  controller: ctrl,
                  style: AppTextStyles.tableCell,
                  maxLines: maxLines,
                )
              : Text(
                  ctrl.text.isNotEmpty ? ctrl.text : '—',
                  style: AppTextStyles.tableCell,
                ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.metricLabel),
          Text(value,
              style: AppTextStyles.tableCell
                  .copyWith(color: AppColors.accentGreen)),
        ],
      ),
    );
  }
}
