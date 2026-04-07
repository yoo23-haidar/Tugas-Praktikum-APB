import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barber_staff_app/core/theme/app_colors.dart';
import 'package:barber_staff_app/core/theme/app_text_styles.dart';
import 'package:barber_staff_app/core/models/customer_session.dart';
import 'package:barber_staff_app/core/services/service_locator.dart';
import 'package:barber_staff_app/core/services/app_error_handler.dart';
import 'package:barber_staff_app/features/documentation/presentation/screens/photo_preview_screen.dart';

/// Documentation screen — capture & upload haircut result photos.
///
/// Integrates [ImagePicker] for camera/gallery access and navigates
/// to [PhotoPreviewScreen] after capture.
class DocumentationScreen extends StatefulWidget {
  const DocumentationScreen({super.key});

  @override
  State<DocumentationScreen> createState() => _DocumentationScreenState();
}

class _DocumentationScreenState extends State<DocumentationScreen> {
  List<CustomerSession> _sessions = [];
  bool _isLoading = true;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() => _isLoading = true);
    try {
      final sessions = await ServiceLocator.barberService.getRecentSessions();
      setState(() =>
          _sessions = sessions.where((s) => s.status == 'completed').toList());
    } catch (e) {
      if (mounted) {
        AppErrorHandler.instance.handleError(
          context: context,
          error: e,
          source: 'documentation.load',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Launch camera or gallery picker, then navigate to preview.
  Future<void> _capturePhoto({
    required CustomerSession session,
    ImageSource source = ImageSource.camera,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) return; // User cancelled

      final bytes = await image.readAsBytes();
      final fileName =
          'haircut_${session.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (!mounted) return;

      // Navigate to preview screen
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => PhotoPreviewScreen(
            imageBytes: Uint8List.fromList(bytes),
            fileName: fileName,
            preSelectedSession: session,
          ),
        ),
      );

      // Refresh if upload was successful
      if (result == true) {
        _loadSessions();
      }
    } catch (e) {
      if (mounted) {
        AppErrorHandler.instance.handleError(
          context: context,
          error: e,
          source: 'camera.capture',
        );
      }
    }
  }

  /// Show a bottom sheet to pick camera or gallery.
  void _showImageSourcePicker(CustomerSession session) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PHOTO SOURCE', style: AppTextStyles.sectionHeader),
                const SizedBox(height: 4),
                Text(
                  '${session.displayId} — ${session.customerName}',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildSourceOption(
                        icon: Icons.camera_alt_outlined,
                        label: 'CAMERA',
                        color: AppColors.accentOrange,
                        onTap: () {
                          Navigator.pop(ctx);
                          _capturePhoto(
                            session: session,
                            source: ImageSource.camera,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSourceOption(
                        icon: Icons.photo_library_outlined,
                        label: 'GALLERY',
                        color: AppColors.accentBlue,
                        onTap: () {
                          Navigator.pop(ctx);
                          _capturePhoto(
                            session: session,
                            source: ImageSource.gallery,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.buttonLabel.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        title: Text('DOCUMENTATION',
            style: AppTextStyles.sectionHeader.copyWith(fontSize: 14)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(color: AppColors.accentOrange))
          : _sessions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.camera_alt_outlined,
                          size: 48, color: AppColors.textLow),
                      const SizedBox(height: 12),
                      Text('No completed sessions to document.',
                          style: AppTextStyles.alertBody),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadSessions,
                  color: AppColors.accentOrange,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _sessions.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
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
                              Text('HAIRCUT RESULTS',
                                  style: AppTextStyles.sectionHeader),
                              const Spacer(),
                              Text('${_sessions.length} sessions',
                                  style: AppTextStyles.caption),
                            ],
                          ),
                        );
                      }
                      return _buildSessionCard(_sessions[index - 1]);
                    },
                  ),
                ),
    );
  }

  Widget _buildSessionCard(CustomerSession session) {
    final hasPhoto = session.hasDocumentation;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasPhoto
              ? AppColors.accentGreen.withValues(alpha: 0.3)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header with session ID and status badge ──────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Text(
                  session.displayId,
                  style: AppTextStyles.tableCell.copyWith(
                    color: AppColors.accentOrange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (hasPhoto
                            ? AppColors.accentGreen
                            : AppColors.accentYellow)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    hasPhoto ? 'DOCUMENTED' : 'PENDING',
                    style: AppTextStyles.caption.copyWith(
                      color: hasPhoto
                          ? AppColors.accentGreen
                          : AppColors.accentYellow,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(session.customerName, style: AppTextStyles.alertTitle),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Text(session.service, style: AppTextStyles.alertBody),
          ),

          // ── Gallery thumbnails ──────────────────────────────
          if (session.galleryPhotoUrls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: session.galleryPhotoUrls.map((url) {
                  return Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.cardBgElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.accentGreen.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.check_circle_outline,
                          size: 24, color: AppColors.accentGreen),
                    ),
                  );
                }).toList(),
              ),
            ),

          // ── Actions (camera + gallery) ──────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton.icon(
                onPressed: () => _showImageSourcePicker(session),
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasPhoto
                      ? AppColors.cardBgElevated
                      : AppColors.accentOrange,
                  foregroundColor: hasPhoto
                      ? AppColors.textMedium
                      : AppColors.scaffoldBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(
                  hasPhoto
                      ? Icons.add_photo_alternate_outlined
                      : Icons.camera_alt_outlined,
                  size: 18,
                ),
                label: Text(
                  hasPhoto ? 'ADD MORE PHOTOS' : 'TAKE PHOTO',
                  style: AppTextStyles.buttonLabel.copyWith(
                    color: hasPhoto
                        ? AppColors.textMedium
                        : AppColors.scaffoldBg,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
