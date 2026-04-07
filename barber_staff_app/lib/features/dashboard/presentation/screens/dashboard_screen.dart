import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barber_staff_app/core/theme/app_colors.dart';
import 'package:barber_staff_app/core/theme/app_text_styles.dart';
import 'package:barber_staff_app/core/services/service_locator.dart';
import 'package:barber_staff_app/core/services/app_error_handler.dart';
import 'package:barber_staff_app/core/models/customer_session.dart';
import 'package:barber_staff_app/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:barber_staff_app/features/dashboard/presentation/widgets/metric_card.dart';
import 'package:barber_staff_app/features/dashboard/presentation/widgets/recent_visits_table.dart';
import 'package:barber_staff_app/features/dashboard/presentation/widgets/alerts_panel.dart';
import 'package:barber_staff_app/features/documentation/presentation/screens/photo_preview_screen.dart';

/// Primary Staff Dashboard Screen.
///
/// Now connected to the mock service for live data, with
/// camera integration and global error handler alerts.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<VisitData> _visits = [];
  List<CustomerSession> _rawSessions = [];
  List<AlertData> _alerts = [];
  bool _isLoading = true;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadDashboardData();

    // Listen for errors to inject into alerts panel
    AppErrorHandler.instance.errorNotifier.addListener(_onErrorsChanged);
  }

  @override
  void dispose() {
    AppErrorHandler.instance.errorNotifier.removeListener(_onErrorsChanged);
    super.dispose();
  }

  void _onErrorsChanged() {
    if (mounted) setState(() => _buildAlerts());
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final sessions = await ServiceLocator.barberService.getRecentSessions();
      setState(() {
        _rawSessions = sessions;
        _visits = sessions.take(5).map((s) {
          String status;
          switch (s.status) {
            case 'completed':
              status = 'Completed';
              break;
            case 'in_progress':
              status = 'In Progress';
              break;
            case 'cancelled':
              status = 'Cancelled';
              break;
            default:
              status = s.status;
          }
          return VisitData(
            sessionId: '#${s.id}',
            customerName: s.customerName,
            service: s.service,
            status: status,
          );
        }).toList();
      });
      _buildAlerts();
    } catch (e) {
      if (mounted) {
        AppErrorHandler.instance.handleError(
          context: context,
          error: e,
          source: 'dashboard.load',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _buildAlerts() {
    final List<AlertData> alerts = [];

    // Static alerts
    alerts.add(const AlertData(
      title: 'Owner Deposit Low',
      body:
          'The operational deposit balance is below the minimum threshold. Request a top-up from the owner immediately.',
      urgency: AlertUrgency.critical,
      actions: ['Request Top-up', 'Acknowledge'],
    ));

    // Photo reminder for undocumented sessions
    final undocumented = _rawSessions
        .where((s) => s.status == 'completed' && !s.hasDocumentation)
        .take(1);
    for (final s in undocumented) {
      alerts.add(AlertData(
        title: 'Photo Reminder',
        body:
            'Upload documentation photo for session ${s.displayId} (${s.customerName} — ${s.service}).',
        urgency: AlertUrgency.warning,
        actions: ['Upload Now'],
      ));
    }

    // Inject error-based alerts from the global handler
    final errors = AppErrorHandler.instance.errors.take(3);
    for (final err in errors) {
      alerts.add(AlertData(
        title: 'API Error: ${err.source}',
        body: err.message,
        urgency: err.severity == 'error'
            ? AlertUrgency.critical
            : AlertUrgency.warning,
        actions: [],
      ));
    }

    // Shift reminder (always at bottom)
    alerts.add(const AlertData(
      title: 'Shift Reminder',
      body:
          'Your shift ends in 45 minutes. Remember to check-out before leaving.',
      urgency: AlertUrgency.info,
      actions: [],
    ));

    setState(() => _alerts = alerts);
  }

  /// Handle camera tap from the visits table.
  Future<void> _onDocumentSession(String sessionId) async {
    // Strip the '#' prefix if present
    final cleanId = sessionId.replaceAll('#', '');

    // Find the matching session
    final session = _rawSessions.where((s) => s.id == cleanId).firstOrNull;
    if (session == null) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();
      final fileName =
          'haircut_${cleanId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (!mounted) return;

      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => PhotoPreviewScreen(
            imageBytes: Uint8List.fromList(bytes),
            fileName: fileName,
            preSelectedSession: session,
          ),
        ),
      );

      if (result == true) {
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        AppErrorHandler.instance.handleError(
          context: context,
          error: e,
          source: 'dashboard.camera',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          color: AppColors.accentOrange,
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: DashboardHeader()),

              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ─── METRIC CARDS ─────────────────────────────
                    _buildSectionLabel('OVERVIEW'),
                    const SizedBox(height: 10),
                    _buildMetricRow(),

                    const SizedBox(height: 24),

                    // ─── RECENT VISITS TABLE ──────────────────────
                    _buildSectionLabel('CUSTOMER LOG'),
                    const SizedBox(height: 10),
                    _isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(
                                  color: AppColors.accentOrange),
                            ),
                          )
                        : RecentVisitsTable(
                            visits: _visits,
                            onDocumentSession: _onDocumentSession,
                          ),

                    const SizedBox(height: 24),

                    // ─── ALERTS (with error-injected items) ───────
                    AlertsPanel(alerts: _alerts),

                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.accentOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: AppTextStyles.sectionHeader),
      ],
    );
  }

  Widget _buildMetricRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 340) {
          return Column(
            children: [
              _earningsCard(),
              const SizedBox(height: 12),
              _customersCard(),
              const SizedBox(height: 12),
              _attendanceCard(),
            ],
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              children: [
                SizedBox(
                  width: (constraints.maxWidth - 24) / 2,
                  child: _earningsCard(),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: (constraints.maxWidth - 24) / 2,
                  child: _customersCard(),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: (constraints.maxWidth - 24) / 2,
                  child: _attendanceCard(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _earningsCard() {
    return const MetricCard(
      label: 'TODAY\'S EARNINGS',
      value: 'Rp 1.25M',
      icon: Icons.account_balance_wallet_outlined,
    );
  }

  Widget _customersCard() {
    return const MetricCard(
      label: 'CUSTOMERS SERVED',
      value: '12',
      icon: Icons.people_outline,
    );
  }

  Widget _attendanceCard() {
    return const MetricCard(
      label: 'HOURS WORKED',
      value: '6.5 hr',
      icon: Icons.timer_outlined,
    );
  }
}
