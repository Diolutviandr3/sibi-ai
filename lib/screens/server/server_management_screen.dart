import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/circular_gauge.dart';

class ServerManagementScreen extends StatefulWidget {
  const ServerManagementScreen({Key? key}) : super(key: key);

  @override
  State<ServerManagementScreen> createState() => _ServerManagementScreenState();
}

class _ServerManagementScreenState extends State<ServerManagementScreen> {
  bool _isRebooting = false;

  void _handleRestartCore() {
    setState(() {
      _isRebooting = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mengirim perintah restart ke Core Engine...'),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isRebooting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Core Engine berhasil direstart! System Online.'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 950;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Area
              _buildHeader(context),
              const SizedBox(height: 24),

              // 2. Top Row (Hardware Metrics)
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: CircularGauge(
                            value: 0.68,
                            percentageText: '68%',
                            amountText: '1.2 TB of 2.0 TB',
                            label: 'Disk Storage',
                            leftMetricLabel: 'R',
                            leftMetricValue: '450 MB/s',
                            rightMetricLabel: 'W',
                            rightMetricValue: '320 MB/s',
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: CircularGauge(
                            value: 0.42,
                            percentageText: '42%',
                            amountText: '27 GB of 64 GB',
                            label: 'Memory Usage',
                            leftMetricLabel: 'Swap',
                            leftMetricValue: '2.1 GB',
                            rightMetricLabel: 'Cache',
                            rightMetricValue: '12 GB',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: _buildCPULoadCard(context)),
                      ],
                    )
                  : Column(
                      children: [
                        const CircularGauge(
                          value: 0.68,
                          percentageText: '68%',
                          amountText: '1.2 TB of 2.0 TB',
                          label: 'Disk Storage',
                          leftMetricLabel: 'R',
                          leftMetricValue: '450 MB/s',
                          rightMetricLabel: 'W',
                          rightMetricValue: '320 MB/s',
                        ),
                        const SizedBox(height: 16),
                        const CircularGauge(
                          value: 0.42,
                          percentageText: '42%',
                          amountText: '27 GB of 64 GB',
                          label: 'Memory Usage',
                          leftMetricLabel: 'Swap',
                          leftMetricValue: '2.1 GB',
                          rightMetricLabel: 'Cache',
                          rightMetricValue: '12 GB',
                        ),
                        const SizedBox(height: 16),
                        _buildCPULoadCard(context),
                      ],
                    ),
              const SizedBox(height: 24),

              // 3. Middle Row (AI Engine Performance)
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildDSPEngineCard(context)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildASREngineCard(context)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildDSPEngineCard(context),
                        const SizedBox(height: 16),
                        _buildASREngineCard(context),
                      ],
                    ),
              const SizedBox(height: 24),

              // 4. Bottom Row (Logs & Backup)
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildRecentSessionsTable(context)),
                        const SizedBox(width: 16),
                        Expanded(flex: 2, child: _buildBackupControlCard(context)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildRecentSessionsTable(context),
                        const SizedBox(height: 16),
                        _buildBackupControlCard(context),
                      ],
                    ),
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
                'Server Management',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Real-time infrastructure health and engine performance',
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade50.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
                    'System Online',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _isRebooting ? null : _handleRestartCore,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isRebooting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Restart Core'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCPULoadCard(BuildContext context) {
    return Container(
      height: 236,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF031633), // Deep Navy background
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CPU LOAD',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '18.4%',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Core Efficiency',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '94% Optimal',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: 0.94,
              backgroundColor: Colors.white10,
              color: AppTheme.accent,
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Peak expected: 09:00 AM',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDSPEngineCard(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.waves, color: AppTheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'DSP Engine',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
                _buildActiveBadge(),
              ],
            ),
            const SizedBox(height: 16),
            // Simulated latency bar chart
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildChartBar(30),
                  _buildChartBar(45),
                  _buildChartBar(35),
                  _buildChartBar(20),
                  _buildChartBar(55),
                  _buildChartBar(70),
                  _buildChartBar(40),
                  _buildChartBar(30),
                  _buildChartBar(38),
                  _buildChartBar(25),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildEngineMetricBox('AVG LATENCY', '12ms')),
                const SizedBox(width: 12),
                Expanded(child: _buildEngineMetricBox('JITTER', '0.4ms')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildASREngineCard(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.mic_none_outlined, color: AppTheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'ASR Engine',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
                _buildActiveBadge(),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: const [
                Text(
                  '98.4%',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary, fontSize: 32),
                ),
                Text(
                  'Accuracy',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.984,
                backgroundColor: AppTheme.background,
                color: AppTheme.primary,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(child: _buildEngineMetricBox('REQUESTS/MIN', '1,240')),
                const SizedBox(width: 12),
                Expanded(child: _buildEngineMetricBox('WER RATE', '2.1%')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartBar(double heightFactor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          height: heightFactor,
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'ACTIVE',
        style: TextStyle(
          color: Colors.green.shade700,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEngineMetricBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 9, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSessionsTable(BuildContext context) {
    final List<Map<String, String>> sessions = [
      {'id': '#SIB-23-001', 'duration': '42m 12s', 'load': '14.5%', 'status': 'SUCCESS'},
      {'id': '#SIB-23-002', 'duration': '1h 05m', 'load': '22.1%', 'status': 'SUCCESS'},
      {'id': '#SIB-23-003', 'duration': '05m 10s', 'load': '08.2%', 'status': 'ABORTED'},
    ];

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Sessions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined, size: 16),
                  label: const Text('Export'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(1),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppTheme.border)),
                  ),
                  children: [
                    _buildTableCell('SESSION ID', isHeader: true),
                    _buildTableCell('DURATION', isHeader: true),
                    _buildTableCell('LOAD', isHeader: true),
                    _buildTableCell('STATUS', isHeader: true),
                    _buildTableCell('', isHeader: true),
                  ],
                ),
                ...sessions.map((sess) {
                  final bool isSuccess = sess['status'] == 'SUCCESS';
                  return TableRow(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppTheme.border)),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(sess['id']!, style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                      ),
                      Text(sess['duration']!, style: const TextStyle(color: AppTheme.textSecondary)),
                      Text(sess['load']!, style: const TextStyle(color: AppTheme.textSecondary)),
                      Text(
                        sess['status']!,
                        style: TextStyle(
                          color: isSuccess ? AppTheme.success : AppTheme.danger,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        onPressed: () {},
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          color: isHeader ? AppTheme.textSecondary : AppTheme.textPrimary,
          fontSize: isHeader ? 10 : 13,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildBackupControlCard(BuildContext context) {
    return Card(
      color: AppTheme.background,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Backup Control',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            
            // Cloud Sync status
            _buildBackupStatusRow('CLOUD SYNC', 'Last: 2h ago', Icons.check_circle_outline, Colors.green),
            const SizedBox(height: 12),

            // DB Snapshot status
            _buildBackupStatusRow('DB SNAPSHOT', 'Next: 00:00 UTC', Icons.schedule, Colors.orange),
            const SizedBox(height: 20),

            // AWS S3 Capacity progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'AWS S3 CAPACITY',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Text(
                  '82%',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: 0.82,
                backgroundColor: Colors.white,
                color: const Color(0xFF031633),
                minHeight: 5,
              ),
            ),
            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sinkronisasi backup manual berhasil dipicu...'),
                    backgroundColor: AppTheme.success,
                  ),
                );
              },
              icon: const Icon(Icons.cloud_upload_outlined),
              label: const Text('Manual Backup'),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: AppTheme.border, width: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupStatusRow(String label, String detail, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
              ),
            ],
          ),
          Icon(icon, color: iconColor, size: 20),
        ],
      ),
    );
  }
}
