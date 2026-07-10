import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../session/session_summary_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 900;

    return Scaffold(
      // Floating Action Button on Bottom Left as in screenshot (above sidebar edge or overlay)
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue.shade700,
        shape: const CircleBorder(),
        child: const Icon(Icons.bolt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Row
              _buildHeader(context),
              const SizedBox(height: 24),

              // 2. Hero Action Card
              _buildHeroCard(context, isDesktop),
              const SizedBox(height: 24),

              // 3. Grid of Resource Statuses
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildHardwareStatusCard(context)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildServerClusterCard(context)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildAIEngineCard(context)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildHardwareStatusCard(context),
                        const SizedBox(height: 16),
                        _buildServerClusterCard(context),
                        const SizedBox(height: 16),
                        _buildAIEngineCard(context),
                      ],
                    ),
              const SizedBox(height: 32),

              // 4. Sesi Terakhir (Recent Sessions) Table Card
              _buildRecentSessionsCard(context, isDesktop),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard Utama',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Selamat datang kembali di Pusat Komando SIBI.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: AppTheme.textPrimary),
                  onPressed: () {},
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Pesan Cepat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.intenseShadow,
        gradient: const LinearGradient(
          colors: [Color(0xFF0A1E3F), AppTheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mulai Sesi Baru',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: isDesktop ? 600 : double.infinity,
            child: Text(
              'Aktifkan sistem pembelajaran cerdas sekarang. Seluruh periferal dan AI asisten siap mendukung pengajaran Anda.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow, size: 20),
                label: const Text('Aktivasi Sistem SIBI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.access_time, size: 20, color: Colors.white),
                label: const Text('Jadwalkan Sesi', style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHardwareStatusCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.tv, color: Colors.blue.shade700, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppTheme.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Online',
                        style: TextStyle(
                            color: Colors.green.shade700, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Hardware Status',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Semua proyektor & audio aktif.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Suhu Proyektor Utama',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const Text(
                  '42°C',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: 0.42,
              backgroundColor: Colors.grey.shade100,
              color: AppTheme.accent,
              borderRadius: BorderRadius.circular(4),
              minHeight: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServerClusterCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.dns, color: Colors.indigo.shade700, size: 20),
                ),
                Text(
                  'Latency: 12ms',
                  style: TextStyle(
                    color: Colors.indigo.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Server Cluster',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Simpul Jakarta-01 Terkoneksi.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.cloud_done_outlined, color: Colors.blue.shade700, size: 18),
                const SizedBox(width: 8),
                Text(
                  '99.9% Uptime',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8), // align spacing with other cards
          ],
        ),
      ),
    );
  }

  Widget _buildAIEngineCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.psychology, color: Colors.teal.shade700, size: 20),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Kelola Resource',
                    style: TextStyle(
                      color: Colors.teal.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'AI Engine Load',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Beban pemrosesan bahasa isyarat.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            // Mini bar charts
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildMiniBar(12),
                const SizedBox(width: 4),
                _buildMiniBar(24),
                const SizedBox(width: 4),
                _buildMiniBar(18),
                const SizedBox(width: 4),
                _buildMiniBar(36),
                const SizedBox(width: 4),
                _buildMiniBar(28),
                const SizedBox(width: 4),
                _buildMiniBar(10),
                const SizedBox(width: 4),
                _buildMiniBar(14),
                const SizedBox(width: 4),
                _buildMiniBar(22),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBar(double height) {
    return Container(
      width: 8,
      height: height,
      decoration: BoxDecoration(
        color: height > 30 ? AppTheme.accent : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildRecentSessionsCard(BuildContext context, bool isDesktop) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Table Header with search
            isDesktop
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sesi Terakhir',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Log pengajaran dan performa AI.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        ],
                      ),
                      _buildSearchFilters(),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sesi Terakhir',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Log pengajaran dan performa AI.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _buildSearchFilters(),
                    ],
                  ),
            const SizedBox(height: 24),

            // Responsive table / List view
            isDesktop ? _buildSessionsTable(context) : _buildSessionsListMobile(context),

            const SizedBox(height: 24),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Tampilkan Semua Sesi'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.textSecondary,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFilters() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 220,
          child: TextFormField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val.toLowerCase();
              });
            },
            decoration: InputDecoration(
              hintText: 'Cari sesi...',
              filled: true,
              fillColor: AppTheme.background,
              prefixIcon: const Icon(Icons.search, size: 18),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.accent),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.background,
            border: Border.all(color: AppTheme.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.filter_alt_outlined, size: 18),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSessionsTable(BuildContext context) {
    final rawSessions = _getSampleSessions();
    final sessions = rawSessions
        .where((s) => s.title.toLowerCase().contains(_searchQuery) || s.id.toLowerCase().contains(_searchQuery))
        .toList();

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(1.5),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // Table Header
        TableRow(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.border, width: 1)),
          ),
          children: [
            _buildTableHeaderCell('MATA PELAJARAN'),
            _buildTableHeaderCell('DURASI'),
            _buildTableHeaderCell('AKURASI AI'),
            _buildTableHeaderCell('STATUS'),
            _buildTableHeaderCell('AKSI'),
          ],
        ),
        // Data Rows
        ...sessions.map((session) {
          return TableRow(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.border, width: 1)),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: _getSubjectColor(session.title).withOpacity(0.1),
                      child: Icon(
                        _getSubjectIcon(session.title),
                        color: _getSubjectColor(session.title),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        ),
                        Text(
                          session.date,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                session.duration,
                style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  Text(
                    '${session.accuracy}%',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _getAccuracyIcon(session.accuracy),
                    color: _getAccuracyColor(session.accuracy),
                    size: 14,
                  ),
                ],
              ),
              _buildStatusBadge(session),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SessionSummaryScreen(session: session),
                    ),
                  );
                },
                child: const Text('Lihat Laporan', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSessionsListMobile(BuildContext context) {
    final rawSessions = _getSampleSessions();
    final sessions = rawSessions
        .where((s) => s.title.toLowerCase().contains(_searchQuery) || s.id.toLowerCase().contains(_searchQuery))
        .toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sessions.length,
      separatorBuilder: (context, index) => const Divider(color: AppTheme.border),
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: _getSubjectColor(session.title).withOpacity(0.1),
                    child: Icon(
                      _getSubjectIcon(session.title),
                      color: _getSubjectColor(session.title),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      session.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                  ),
                  _buildStatusBadge(session),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Waktu: ${session.date}', style: const TextStyle(fontSize: 11)),
                  Text('Durasi: ${session.duration}', style: const TextStyle(fontSize: 11)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Akurasi AI: ${session.accuracy}%', style: const TextStyle(fontSize: 11)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SessionSummaryScreen(session: session),
                        ),
                      );
                    },
                    child: const Text('Lihat Laporan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(dynamic session) {
    Color bg = Colors.blue.shade50;
    Color fg = Colors.blue.shade700;
    String label = 'Selesai';

    if (session.statusText == 'TINJAUAN') {
      bg = Colors.red.shade50;
      fg = Colors.red.shade700;
      label = 'Tinjauan';
    }

    return UnconstrainedBox(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Sample data helpers
  List<dynamic> _getSampleSessions() {
    // Return objects matching our lib/models/session.dart model
    // but generic typed here to avoid strict circular imports if any
    return [
      _FakeSession(
        id: '#SIB-23-001',
        title: 'Matematika Dasar',
        duration: '45 Menit',
        load: 14.5,
        statusText: 'SUCCESS',
        date: '12 Okt 2023 • 08:30',
        accuracy: 98.2,
      ),
      _FakeSession(
        id: '#SIB-23-002',
        title: 'Bahasa Indonesia',
        duration: '60 Menit',
        load: 22.1,
        statusText: 'SUCCESS',
        date: '11 Okt 2023 • 10:15',
        accuracy: 97.5,
      ),
      _FakeSession(
        id: '#SIB-23-003',
        title: 'Ilmu Pengetahuan Alam',
        duration: '50 Menit',
        load: 8.2,
        statusText: 'TINJAUAN',
        date: '11 Okt 2023 • 13:00',
        accuracy: 94.1,
      ),
    ];
  }

  IconData _getSubjectIcon(String title) {
    if (title.contains('Matematika')) return Icons.functions;
    if (title.contains('Bahasa')) return Icons.menu_book;
    return Icons.science_outlined;
  }

  Color _getSubjectColor(String title) {
    if (title.contains('Matematika')) return Colors.blue.shade700;
    if (title.contains('Bahasa')) return Colors.orange.shade700;
    return Colors.teal.shade700;
  }

  IconData _getAccuracyIcon(double acc) {
    if (acc >= 98.0) return Icons.arrow_outward;
    if (acc >= 95.0) return Icons.arrow_forward;
    return Icons.south_east;
  }

  Color _getAccuracyColor(double acc) {
    if (acc >= 98.0) return AppTheme.success;
    if (acc >= 95.0) return AppTheme.textSecondary;
    return AppTheme.danger;
  }
}

class _FakeSession {
  final String id;
  final String title;
  final String duration;
  final double load;
  final String statusText;
  final String date;
  final double accuracy;

  _FakeSession({
    required this.id,
    required this.title,
    required this.duration,
    required this.load,
    required this.statusText,
    required this.date,
    required this.accuracy,
  });
}
