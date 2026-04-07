import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:barber_staff_app/core/theme/app_colors.dart';
import 'package:barber_staff_app/core/theme/app_text_styles.dart';
import 'package:barber_staff_app/core/models/customer_session.dart';
import 'package:barber_staff_app/core/services/service_locator.dart';
import 'package:barber_staff_app/core/services/app_error_handler.dart';

/// Full-screen photo preview after capture.
///
/// Shows the captured image, a session picker, and a prominent
/// "Upload to Customer Gallery" button.
class PhotoPreviewScreen extends StatefulWidget {
  /// Raw image bytes from the camera/picker.
  final Uint8List imageBytes;

  /// File name for the upload.
  final String fileName;

  /// Pre-selected session (if launched from a specific session).
  final CustomerSession? preSelectedSession;

  const PhotoPreviewScreen({
    super.key,
    required this.imageBytes,
    required this.fileName,
    this.preSelectedSession,
  });

  @override
  State<PhotoPreviewScreen> createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  CustomerSession? _selectedSession;
  List<CustomerSession> _sessions = [];
  bool _isUploading = false;
  bool _isLoadingSessions = true;

  @override
  void initState() {
    super.initState();
    _selectedSession = widget.preSelectedSession;
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    try {
      final sessions = await ServiceLocator.barberService.getRecentSessions();
      setState(() {
        _sessions = sessions.where((s) => s.status == 'completed').toList();
      });
    } catch (e) {
      // Silently fail — user can still pick from empty list
    } finally {
      if (mounted) setState(() => _isLoadingSessions = false);
    }
  }

  Future<void> _uploadPhoto() async {
    if (_selectedSession == null) {
      AppErrorHandler.instance.showWarning(
        context: context,
        message: 'Select a customer session first.',
        source: 'gallery.upload',
      );
      return;
    }

    setState(() => _isUploading = true);
    try {
      await ServiceLocator.barberService.uploadGalleryPhoto(
        sessionId: _selectedSession!.id,
        fileName: widget.fileName,
        fileBytes: widget.imageBytes,
      );
      if (mounted) {
        AppErrorHandler.instance.showSuccess(
          context: context,
          message:
              'Photo uploaded for ${_selectedSession!.customerName}',
        );
        Navigator.of(context).pop(true); // Return success
      }
    } catch (e) {
      if (mounted) {
        AppErrorHandler.instance.handleError(
          context: context,
          error: e,
          source: 'gallery.upload',
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 22),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        title: Text('PREVIEW',
            style: AppTextStyles.sectionHeader.copyWith(fontSize: 14)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Image preview ─────────────────────────────────────
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.memory(
                  widget.imageBytes,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.image_outlined,
                              size: 48, color: AppColors.textLow),
                          const SizedBox(height: 8),
                          Text('Preview not available',
                              style: AppTextStyles.alertBody),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // ── Session picker + Upload ───────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            decoration: const BoxDecoration(
              color: AppColors.cardBg,
              border: Border(
                top: BorderSide(color: AppColors.divider),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Link to session label ────────────────────────
                Text('LINK TO CUSTOMER SESSION',
                    style: AppTextStyles.metricLabel),
                const SizedBox(height: 8),

                // ── Session dropdown ─────────────────────────────
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _isLoadingSessions
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text('Loading sessions...',
                              style: AppTextStyles.caption),
                        )
                      : DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSession?.id,
                            isExpanded: true,
                            dropdownColor: AppColors.cardBg,
                            hint: Text('Select session',
                                style: AppTextStyles.caption),
                            icon: const Icon(Icons.unfold_more,
                                size: 16, color: AppColors.textLow),
                            items: _sessions.map((s) {
                              return DropdownMenuItem(
                                value: s.id,
                                child: Text(
                                  '${s.displayId} — ${s.customerName} · ${s.service}',
                                  style: AppTextStyles.tableCell
                                      .copyWith(fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedSession = _sessions.firstWhere(
                                    (s) => s.id == val);
                              });
                            },
                          ),
                        ),
                ),
                const SizedBox(height: 16),

                // ── Upload button ────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _isUploading ? null : _uploadPhoto,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentOrange,
                      foregroundColor: AppColors.scaffoldBg,
                      disabledBackgroundColor:
                          AppColors.accentOrange.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: _isUploading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.scaffoldBg,
                            ),
                          )
                        : const Icon(Icons.cloud_upload_outlined, size: 22),
                    label: Text(
                      _isUploading
                          ? 'UPLOADING...'
                          : 'UPLOAD TO CUSTOMER GALLERY',
                      style: AppTextStyles.buttonLabel.copyWith(
                        fontSize: 12,
                        color: AppColors.scaffoldBg,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
