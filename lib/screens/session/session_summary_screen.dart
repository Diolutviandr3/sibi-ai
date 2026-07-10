import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mind_map_painter.dart';
import '../../widgets/sidebar_navigation.dart';

class SessionSummaryScreen extends StatefulWidget {
  final dynamic session;

  const SessionSummaryScreen({Key? key, this.session}) : super(key: key);

  @override
  State<SessionSummaryScreen> createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends State<SessionSummaryScreen> {
  String _selectedConceptDetails = "Pilih salah satu konsep utama di bawah untuk melihat rincian pemetaan AI.";
  
  final String _jsonPetaPengetahuan = '''{
  "session_id": "SIBI-2023-X9",
  "topic": "CompArchitecture",
  "nodes": [
    {
      "id": "root_01",
      "label": "Arsitektur Komputer",
      "weight": 1.0,
      "children": ["cpu_01", "mem_01"]
    },
    {
      "id": "cpu_01",
      "label": "CPU",
      "properties": {
        "unit": ["ALU", "CU", "Reg"],
        "cycle": "Fetch-Decode"
      }
    },
    {
      "id": "mem_01",
      "label": "Memory",
      "levels": ["L1", "L2", "L3"]
    }
  ],
  "export_ready": true
}''';

  final Map<String, String> _conceptDescriptions = {
    'ALU': 'Arithmetic Logic Unit: Komponen CPU yang melakukan operasi aritmatika (penjumlahan, pengurangan) dan logika (AND, OR, NOT).',
    'Mainboard': 'Motherboard / Papan Induk: Hub sirkuit utama yang menghubungkan CPU, RAM, penyimpanan, dan kartu ekspansi eksternal.',
    'Clock Cycle': 'Siklus Jam: Detak osilator internal CPU yang menyinkronkan seluruh operasi eksekusi instruksi.',
    'Registers': 'Register: Sel memori ultra-cepat di dalam CPU untuk penyimpanan data sementara selama pemrosesan instruksi.',
    'Control Unit': 'Unit Kontrol: Komponen CPU yang mengarahkan operasi prosesor, mengambil instruksi, dan mengontrol aliran data.',
    'System Bus': 'Bus Sistem: Jalur komunikasi fisik yang mentransfer data, alamat memori, dan sinyal kontrol antar komponen komputer.',
  };

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 1100;
    final bool isTablet = size.width > 700 && size.width <= 1100;

    final String title = widget.session?.title ?? "Arsitektur Komputer Modern";
    final String duration = widget.session?.duration ?? "1j 45m";
    final int conceptCount = widget.session?.conceptCount ?? 42;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Row(
          children: [
            // Left main content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Header Area
                    _buildHeader(context),
                    const SizedBox(height: 24),

                    // 2. Hero Section (Info Sesi Berakhir)
                    _buildHeroStatsCard(context, title, duration, conceptCount),
                    const SizedBox(height: 24),

                    // 3. Middle Section: Mind Map & JSON Tree
                    isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: _buildMindMapCard(context)),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildJsonTreeCard(context)),
                            ],
                          )
                        : Column(
                            children: [
                              _buildMindMapCard(context),
                              const SizedBox(height: 16),
                              _buildJsonTreeCard(context),
                            ],
                          ),
                    const SizedBox(height: 24),

                    // 4. Bottom Section: Analisis Konteks & Hierarki Konsep
                    _buildAnalyticsCard(context),
                    const SizedBox(height: 24),

                    // 5. Footer Section: Katalog Konsep Utama
                    _buildConceptCatalog(context),
                  ],
                ),
              ),
            ),

            // 6. Right Navigation Bar (Sidebar Kanan)
            if (isDesktop)
              SidebarNavigation(
                currentIndex: 1,
                onTabSelected: (index) {
                  Navigator.pop(context);
                },
                isCollapsed: false,
              )
            else if (isTablet)
              SidebarNavigation(
                currentIndex: 1,
                onTabSelected: (index) {
                  Navigator.pop(context);
                },
                isCollapsed: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final String topic = widget.session?.title ?? "Arsitektur Komputer Modern";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ringkasan Sesi',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                _showExportDialog(context, topic: topic);
              },
              icon: const Icon(Icons.share_outlined, size: 16),
              label: const Text('Bagikan'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () {
                _showExportDialog(context, topic: topic);
              },
              icon: const Icon(Icons.file_upload_outlined, size: 16),
              label: const Text('Export Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroStatsCard(BuildContext context, String title, String duration, int conceptCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF030D22), AppTheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade400, width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(color: AppTheme.success, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Sesi Selesai Berhasil',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Analisis mendalam mengenai CPU, Hierarki Memori, dan Interkoneksi Bus melalui SIBI Intelligent Mapping.',
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Right Content (Rata Kanan)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Durasi Sesi',
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold),
              ),
              Text(
                duration,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 16),
              Text(
                'Konsep Terekstraksi',
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold),
              ),
              Text(
                '$conceptCount Entitas',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMindMapCard(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Panel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.hub_outlined, color: AppTheme.textPrimary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Visualisasi Mind Map',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildZoomIcon(Icons.zoom_in),
                    const SizedBox(width: 4),
                    _buildZoomIcon(Icons.zoom_out),
                    const SizedBox(width: 4),
                    _buildZoomIcon(Icons.fullscreen),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Area Canvas Mind Map with local QR Download card
            SizedBox(
              height: 380,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(20.0),
                      minScale: 0.5,
                      maxScale: 2.0,
                      child: MindMapWidget(
                        onNodeTapped: (label) {
                          setState(() {
                            _selectedConceptDetails = "Node Terpilih: $label\nHubungan terekstraksi oleh SIBI AI mapping engine.";
                          });
                        },
                      ),
                    ),
                    // QR Code Card in the bottom right corner
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 56,
                                height: 56,
                                child: QrImageView(
                                  data: "http://10.0.2.2/download/mindmap/session_x9.png",
                                  version: QrVersions.auto,
                                  size: 56.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Scan untuk Unduh\nMind Map',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomIcon(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16, color: AppTheme.textPrimary),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        onPressed: () {},
      ),
    );
  }

  Widget _buildJsonTreeCard(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'JSON TREE PETA PENGETAHUAN',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 0.8),
                ),
                Icon(Icons.code, color: AppTheme.textSecondary, size: 18),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF020E27),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade900),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _jsonPetaPengetahuan,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Colors.greenAccent,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.cloud_download_outlined, color: AppTheme.textPrimary),
              label: const Text('Unduh Asset Mentah', style: TextStyle(color: AppTheme.textPrimary)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: AppTheme.background,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analisis Konteks & Hierarki Konsep',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Metrik keterkaitan materi yang terdeteksi oleh mesin AI selama sesi berlangsung.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildEntityExtractionCol(context)),
                const SizedBox(width: 24),
                Expanded(child: _buildRelationMappingCol(context)),
                const SizedBox(width: 24),
                Expanded(child: _buildComprehensionScoreCol(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntityExtractionCol(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildColTitle(Icons.fact_check_outlined, 'EKSTRAKSI ENTITAS'),
        const SizedBox(height: 12),
        _buildEntityRow('Komponen Fisik', 12),
        const SizedBox(height: 8),
        _buildEntityRow('Proses Logis', 24),
        const SizedBox(height: 8),
        _buildEntityRow('Abstraksi Data', 6),
      ],
    );
  }

  Widget _buildEntityRow(String label, int count) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary, fontSize: 13)),
          Badge(
            label: Text(count.toString().padLeft(2, '0')),
            backgroundColor: Colors.grey.shade400,
            textColor: AppTheme.textPrimary,
            largeSize: 20,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationMappingCol(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildColTitle(Icons.alt_route, 'PEMETAAN RELASI'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            children: [
              Text(
                '89.4% Koherensi',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hubungan antar konsep menunjukkan korelasi yang sangat kuat pada bagian Arsitektur Set Instruksi (ISA).',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComprehensionScoreCol(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildColTitle(Icons.assignment_outlined, 'SKOR PEMAHAMAN'),
        const SizedBox(height: 12),
        _buildProgressBar('Kedalaman Materi', 0.92),
        const SizedBox(height: 16),
        _buildProgressBar('Retensi Konsep', 0.78),
      ],
    );
  }

  Widget _buildProgressBar(String label, double val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            Text('${(val * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: val,
          backgroundColor: AppTheme.border,
          color: AppTheme.accent,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildColTitle(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.accent, size: 16),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildConceptCatalog(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Katalog Konsep Utama',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            
            // Description Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Text(
                _selectedConceptDetails,
                style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.w500, height: 1.4),
              ),
            ),
            const SizedBox(height: 20),

            // Horizontal Concept Cards
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildConceptCard('ALU', Icons.settings_outlined),
                  _buildConceptCard('Mainboard', Icons.dashboard_outlined),
                  _buildConceptCard('Clock Cycle', Icons.timelapse),
                  _buildConceptCard('Registers', Icons.folder_open),
                  _buildConceptCard('Control Unit', Icons.alt_route),
                  _buildConceptCard('System Bus', Icons.settings_ethernet),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptCard(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            _selectedConceptDetails = _conceptDescriptions[label] ?? "Deskripsi tidak tersedia.";
          });
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppTheme.border, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: AppTheme.accent),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context, {required String topic}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final Size size = MediaQuery.of(context).size;
        final bool isDesktop = size.width > 800;

        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: isDesktop ? 750 : 400,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.hub_outlined, color: AppTheme.primary, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Export & Bagikan Mind Map',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Materi Sesi: $topic',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const Divider(height: 24, color: AppTheme.border),
                
                // Content Split
                isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: _buildDialogMindMapPreview(),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 4,
                            child: _buildDialogQRCodeSection(topic),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildDialogMindMapPreview(),
                          const SizedBox(height: 24),
                          _buildDialogQRCodeSection(topic),
                        ],
                      ),
                const Divider(height: 24, color: AppTheme.border),
                
                // Bottom Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Tutup'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Laporan PDF berhasil diunduh ke penyimpanan lokal.'),
                            backgroundColor: AppTheme.success,
                          ),
                        );
                      },
                      icon: const Icon(Icons.file_download, size: 16),
                      label: const Text('Unduh Laporan PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogMindMapPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PREVIEW MIND MAP',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textSecondary, fontSize: 10, letterSpacing: 0.8),
        ),
        const SizedBox(height: 12),
        Container(
          height: 230,
          decoration: BoxDecoration(
            color: const Color(0xFF031633),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: InteractiveViewer(
              child: MindMapWidget(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogQRCodeSection(String topic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SCAN & UNDUH LANGSUNG',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textSecondary, fontSize: 10, letterSpacing: 0.8),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border, width: 1.5),
              ),
              child: SizedBox(
                width: 110,
                height: 110,
                child: QrImageView(
                  data: "http://10.0.2.2/download/mindmap/session_current.png",
                  version: QrVersions.auto,
                  size: 110.0,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Unduh Offline (Lokal)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Siswa dapat memindai QR Code ini menggunakan HP mereka untuk mengunduh gambar mind map secara offline dari node edge computing lokal kelas.',
                    style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
