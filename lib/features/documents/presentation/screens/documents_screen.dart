import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';
import 'package:file_picker/file_picker.dart';

/// Belgelerim ekranı — STK belgeleri, CV, kimlik fotokopisi vb.
class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profil = ref.watch(profilProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Belgelerim'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'Tümü'),
            Tab(text: 'CV'),
            Tab(text: 'STK Belgeleri'),
            Tab(text: 'Kimlik'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDocumentList(profil.documents, null),
          _buildDocumentList(profil.documents, DocumentCategory.cv),
          _buildDocumentList(profil.documents, DocumentCategory.stk),
          _buildDocumentList(profil.documents, DocumentCategory.kimlik),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showUploadOptions,
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.upload_file_rounded, color: Colors.white),
        label: const Text(
          'Belge Yükle',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDocumentList(
    List<DocumentInfo> allDocs,
    DocumentCategory? filter,
  ) {
    final filtered =
        filter == null
            ? allDocs
            : allDocs.where((d) => d.category == filter.name).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder_open_rounded, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Henüz belge yüklenmedi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aşağıdaki butona tıklayarak belge yükleyin.',
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _DocumentCard(
          document: filtered[index],
          onTap: () => _showDocumentDetail(filtered[index]),
          onDelete: () => _deleteDocument(filtered[index]),
        );
      },
    );
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Belge Yükle',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                _UploadOption(
                  icon: Icons.description_rounded,
                  title: 'CV Yükle',
                  subtitle: 'PDF, DOCX formatında',
                  color: const Color(0xFF1565C0),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickAndUpload(DocumentCategory.cv, 'CV Belgesi');
                  },
                ),
                const SizedBox(height: 10),
                _UploadOption(
                  icon: Icons.groups_rounded,
                  title: 'STK Belgesi',
                  subtitle: 'Üyelik belgesi, yetki belgesi vb.',
                  color: const Color(0xFF7B1FA2),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickAndUpload(DocumentCategory.stk, 'STK Üyelik Belgesi');
                  },
                ),
                const SizedBox(height: 10),
                _UploadOption(
                  icon: Icons.badge_rounded,
                  title: 'Kimlik Belgesi',
                  subtitle: 'Nüfus cüzdanı, ehliyet, pasaport',
                  color: const Color(0xFFE65100),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickAndUpload(DocumentCategory.kimlik, 'Kimlik Belgesi');
                  },
                ),
                const SizedBox(height: 10),
                _UploadOption(
                  icon: Icons.folder_rounded,
                  title: 'Diğer Belge',
                  subtitle: 'Diploma, sertifika, referans mektubu',
                  color: const Color(0xFF2E7D32),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickAndUpload(DocumentCategory.diger, 'Diğer Belge');
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Future<void> _pickAndUpload(DocumentCategory category, String title) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
      );

      if (result != null) {
        final platformFile = result.files.first;
        final doc = DocumentInfo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: platformFile.name,
          category: category.name,
          fileType: platformFile.extension?.toUpperCase() ?? 'PDF',
          uploadDate: DateTime.now(),
        );

        ref.read(profilProvider.notifier).addDocument(doc);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${platformFile.name} başarıyla yüklendi ✓'),
              backgroundColor: const Color(0xFF2E7D32),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dosya seçilirken bir hata oluştu.'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _deleteDocument(DocumentInfo doc) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Belgeyi Sil'),
            content: Text(
              '"${doc.name}" belgesini silmek istediğinize emin misiniz?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ref.read(profilProvider.notifier).removeDocument(doc.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Belge silindi')),
                  );
                },
                child: const Text(
                  'Sil',
                  style: TextStyle(
                    color: AppTheme.errorColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showDocumentDetail(DocumentInfo doc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _getCategoryColorFromStr(
                      doc.category,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getCategoryIconFromStr(doc.category),
                    size: 32,
                    color: _getCategoryColorFromStr(doc.category),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  doc.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'belge_${doc.id}.pdf',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _DetailChip(
                      icon: Icons.insert_drive_file,
                      label: doc.fileType.toUpperCase(),
                    ),
                    _DetailChip(icon: Icons.data_usage, label: '1.5 MB'),
                    _DetailChip(
                      icon: Icons.calendar_today,
                      label:
                          '${doc.uploadDate.day}.${doc.uploadDate.month}.${doc.uploadDate.year}',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Belge paylaşım özelliği yakında eklenecek',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.share_rounded, size: 18),
                        label: const Text('Paylaş'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _openPdfViewer(doc);
                        },
                        icon: const Icon(
                          Icons.visibility_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Görüntüle',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
    );
  }

  void _openPdfViewer(DocumentInfo doc) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black,
      pageBuilder: (context, _, __) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              doc.name,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            centerTitle: true,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.picture_as_pdf_rounded,
                  size: 100,
                  color: AppTheme.errorColor.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 24),
                Text(
                  doc.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'PDF İçeriği Görüntüleniyor',
                  style: TextStyle(color: Colors.grey),
                ),
                const Padding(padding: EdgeInsets.all(32), child: Divider()),
                const Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Bu bir simülasyon PDF içeriğidir. Gerçek uygulamada burada belgenin PDF görntüsü yer alacaktır.\n\n'
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n'
                      'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                      style: TextStyle(height: 1.6, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getCategoryColorFromStr(String catName) {
    final cat = DocumentCategory.values.firstWhere(
      (e) => e.name == catName,
      orElse: () => DocumentCategory.diger,
    );
    switch (cat) {
      case DocumentCategory.cv:
        return const Color(0xFF1565C0);
      case DocumentCategory.stk:
        return const Color(0xFF7B1FA2);
      case DocumentCategory.kimlik:
        return const Color(0xFFE65100);
      case DocumentCategory.diger:
        return const Color(0xFF2E7D32);
    }
  }

  IconData _getCategoryIconFromStr(String catName) {
    final cat = DocumentCategory.values.firstWhere(
      (e) => e.name == catName,
      orElse: () => DocumentCategory.diger,
    );
    switch (cat) {
      case DocumentCategory.cv:
        return Icons.description_rounded;
      case DocumentCategory.stk:
        return Icons.groups_rounded;
      case DocumentCategory.kimlik:
        return Icons.badge_rounded;
      case DocumentCategory.diger:
        return Icons.folder_rounded;
    }
  }
}

// ── Document Card
class _DocumentCard extends StatelessWidget {
  final DocumentInfo document;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _DocumentCard({
    required this.document,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final DocumentCategory category = DocumentCategory.values.firstWhere(
      (e) => e.name == document.category,
      orElse: () => DocumentCategory.diger,
    );
    final color = _colorFor(category);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_iconFor(category), color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _FileTag(
                        label: document.fileType.toUpperCase(),
                        color: color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '1.5 MB',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${document.uploadDate.day}.${document.uploadDate.month}.${document.uploadDate.year}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'delete') onDelete();
              },
              itemBuilder:
                  (_) => [
                    const PopupMenuItem(value: 'delete', child: Text('Sil')),
                  ],
              child: Icon(
                Icons.more_vert_rounded,
                size: 20,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFor(DocumentCategory c) {
    switch (c) {
      case DocumentCategory.cv:
        return const Color(0xFF1565C0);
      case DocumentCategory.stk:
        return const Color(0xFF7B1FA2);
      case DocumentCategory.kimlik:
        return const Color(0xFFE65100);
      case DocumentCategory.diger:
        return const Color(0xFF2E7D32);
    }
  }

  IconData _iconFor(DocumentCategory c) {
    switch (c) {
      case DocumentCategory.cv:
        return Icons.description_rounded;
      case DocumentCategory.stk:
        return Icons.groups_rounded;
      case DocumentCategory.kimlik:
        return Icons.badge_rounded;
      case DocumentCategory.diger:
        return Icons.folder_rounded;
    }
  }
}

class _UploadOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _UploadOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _FileTag extends StatelessWidget {
  final String label;
  final Color color;
  const _FileTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.grey[400]),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
