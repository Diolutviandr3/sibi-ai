import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/wave_painter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../widgets/mind_map_painter.dart';

class LiveSessionScreen extends StatefulWidget {
  const LiveSessionScreen({Key? key}) : super(key: key);

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  bool _isLive = true;
  int _secondsElapsed = 2538; // 42 minutes 18 seconds
  int _wordCount = 1248;
  Timer? _timer;
  String _selectedDialect = 'Bahasa Indonesia (Standard)';

  // Stream of transcription sentences
  final List<String> _fullTranscriptText = [
    "Selamat pagi semua, hari ini kita akan membahas tentang Hukum Termodinamika Kedua dan bagaimana ia mempengaruhi sistem tertutup.",
    "Perhatikan bahwa Entropi selalu meningkat dalam sistem yang terisolasi. Hal ini sangat penting untuk dipahami dalam konteks desain mesin kalor modern yang kita gunakan sekarang.",
    "Sekarang, mari kita lihat grafik di layar proyektor. Kalian bisa melihat bagaimana fluktuasi energi terjadi secara konstan...",
    "Hubungan ini mendefinisikan batas efisiensi ideal dari setiap siklus termodinamika.",
    "Siswa mengajukan pertanyaan tentang penerapan teorema Carnot dalam pendingin ruangan.",
    "Pembahasan dilanjutkan dengan menganalisis perpindahan panas konveksi di ruang pembakaran."
  ];

  final List<String> _currentLines = [];
  int _transcriptIndex = 0;

  @override
  void initState() {
    super.initState();
    // Pre-populate initial transcript text matching mockup
    _currentLines.add(_fullTranscriptText[0]);
    _currentLines.add(_fullTranscriptText[1]);
    _currentLines.add(_fullTranscriptText[2]);
    _transcriptIndex = 3;

    // Start timer to simulate live activity
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isLive) {
        setState(() {
          _secondsElapsed++;
          // Increment word count slightly
          if (_secondsElapsed % 3 == 0) {
            _wordCount += 3 + (DateTime.now().second % 4);
          }

          // Add a new line of text every 12 seconds
          if (_secondsElapsed % 12 == 0 && _transcriptIndex < _fullTranscriptText.length) {
            _currentLines.add(_fullTranscriptText[_transcriptIndex]);
            _transcriptIndex++;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    String pad(int n) => n.toString().padLeft(2, '0');
    return '${pad(hours)}:${pad(minutes)}:${pad(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 1000;

    if (isDesktop) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Panel Kiri - Signal & ASR Diagnostics (width: 260px)
              SizedBox(
                width: 260,
                child: _buildLeftPanel(context, isDesktop: true),
              ),
              const VerticalDivider(width: 1, color: AppTheme.border),

              // 2. Panel Tengah - Area Live Transcription (flex: 5)
              Expanded(
                flex: 5,
                child: _buildCenterPanel(context),
              ),
              const VerticalDivider(width: 1, color: AppTheme.border),

              // 3. Panel Kanan Dalam - Ekstraksi Pengetahuan & Insight (flex: 3)
              Expanded(
                flex: 3,
                child: _buildRightPanel(context, isDesktop: true),
              ),
            ],
          ),
        ),
      );
    }

    // Mobile/Tablet responsive vertical stack (collapsing side panels)
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildLeftPanel(context, isDesktop: false),
              const Divider(height: 1, color: AppTheme.border),
              SizedBox(height: 520, child: _buildCenterPanel(context)),
              const Divider(height: 1, color: AppTheme.border),
              _buildRightPanel(context, isDesktop: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _maybeExpanded({required bool isExpanded, required Widget child}) {
    if (isExpanded) {
      return Expanded(child: child);
    }
    return child;
  }

  Widget _buildLeftPanel(BuildContext context, {required bool isDesktop}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: SIBI + Badge chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SIBI',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
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
                          Text(
                            'LIVE & ONLINE',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade400, width: 1),
                      ),
                      child: Text(
                        'Koneksi Stabil - STT Aktif',
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Section Signal Stream
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Signal Stream',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.textPrimary),
                    ),
                    Text(
                      '0.4ms',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Custom Waveform Visualizer Widget
                WaveformWidget(isLive: _isLive),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMiniMetric('INPUT LEVEL', '-12.4 dB'),
                    _buildMiniMetric('SAMPLING', '48kHz'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Section ASR Diagnostics
          _maybeExpanded(
            isExpanded: isDesktop,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.psychology_outlined, color: AppTheme.textSecondary, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'ASR Diagnostics',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Confidence Progress Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Confidence', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                            Text('98.2%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: 0.982,
                          color: AppTheme.primary,
                          backgroundColor: AppTheme.border,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Model Bahasa & Aksentuasi Dropdown Form Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Model Bahasa & Aksentuasi',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDialect,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.primary),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        icon: const Icon(Icons.arrow_drop_down, size: 18),
                        items: const [
                          DropdownMenuItem(
                            value: 'Bahasa Indonesia (Standard)',
                            child: Text('Bahasa Indonesia (Standard)'),
                          ),
                          DropdownMenuItem(
                            value: 'Aksen Lokal Sumatera',
                            child: Text('Aksen Lokal Sumatera'),
                          ),
                          DropdownMenuItem(
                            value: 'Aksen Lokal Jawa',
                            child: Text('Aksen Lokal Jawa'),
                          ),
                          DropdownMenuItem(
                            value: 'Aksen Lokal Indonesia Timur',
                            child: Text('Aksen Lokal Indonesia Timur'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedDialect = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Spec ListTiles
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildListTileSpec(Icons.bolt, 'DeepSpeech v2.4', 'Jakarta-01 Node'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Bottom dark card: Projector Active
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                const Icon(Icons.cast_connected, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Projector Active',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Text(
                        'Room 402',
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.signal_cellular_alt, color: Colors.white70, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterPanel(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: AppTheme.danger, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'LIVE TRANSCRIPTION',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.history, size: 16),
                      label: const Text('History', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {
                        _showExportDialog(context);
                      },
                      icon: const Icon(Icons.file_download_outlined, size: 16),
                      label: const Text('Export', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.border),

          // Live Text Stream View
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(28),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.8,
                              color: AppTheme.textPrimary,
                              fontSize: 17,
                            ),
                        children: [
                          ..._currentLines.map((line) => _buildParagraphSpan(line)).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Active transcription block in grey container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.blue.shade900,
                                fontSize: 15,
                              ),
                          children: [
                            const TextSpan(text: 'Siklus ideal Carnot ini menentukan batas efisiensi... '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: _CursorIndicator(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Session control bar
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                // Pause button (navy blue)
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isLive = !_isLive;
                    });
                  },
                  icon: Icon(_isLive ? Icons.pause : Icons.play_arrow, size: 16),
                  label: Text(_isLive ? 'PAUSE' : 'RESUME'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Stop & Save button (red brick)
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isLive = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sesi Berhasil Disimpan!'),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  },
                  icon: const Icon(Icons.stop, size: 16),
                  label: const Text('STOP & SAVE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC0392B), // Brick Red
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
                const Spacer(),
                
                // Duration & Word count
                _buildSessionMetric('DURATION', _formatDuration(_secondsElapsed)),
                const SizedBox(width: 24),
                _buildSessionMetric('WORDS', _wordCount.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel(BuildContext context, {required bool isDesktop}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Ekstraksi Pengetahuan
          Row(
            children: const [
              Icon(Icons.hub_outlined, size: 18, color: AppTheme.textPrimary),
              SizedBox(width: 8),
              Text(
                'Ekstraksi Pengetahuan',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text('Dynamic Keyword Cloud', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          const SizedBox(height: 16),
          // Wrap with ActionChips (blue and gray design variations)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildConceptChip('Entropi', isActive: true),
              _buildConceptChip('Termodinamika', isActive: false),
              _buildConceptChip('Energi Kinetik', isActive: false),
              _buildConceptChip('Mesin Kalor', isActive: true),
              _buildConceptChip('Sistem Tertutup', isActive: false),
              _buildConceptChip('Isolasi', isActive: false),
              _buildConceptChip('Hukum Fisika', isActive: false),
              _buildConceptChip('Fluida', isActive: false),
              _buildConceptChip('Konversi', isActive: false),
              _buildConceptChip('Molekul', isActive: false),
            ],
          ),
          const SizedBox(height: 28),

          // Section AI Summary Insight
          const Text(
            'AI SUMMARY INSIGHT',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: AppTheme.textSecondary, letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Text(
              '"Fokus saat ini berada pada konsep degradasi energi dalam sistem makroskopik. Siswa merespon positif pada analogi mesin uap."',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
            ),
          ),
          isDesktop ? const Spacer() : const SizedBox(height: 24),

          // Bottom Action: Ask AI Assistant large Card
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white12,
                    child: Icon(Icons.smart_toy_outlined, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Ask AI Assistant',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          '"Jelaskan hukum Carnot..."',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helpers
  Widget _buildMiniMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 9, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildListTileSpec(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.textPrimary)),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 9, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
      ],
    );
  }

  Widget _buildConceptChip(String text, {bool isActive = false}) {
    return ActionChip(
      onPressed: () {},
      backgroundColor: isActive ? AppTheme.primary : AppTheme.background,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      label: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : AppTheme.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  TextSpan _buildParagraphSpan(String line) {
    final List<TextSpan> spans = [];
    final List<String> words = line.split(" ");
    
    for (int i = 0; i < words.length; i++) {
      final String w = words[i];
      final String cleanWord = w.replaceAll(RegExp(r'[^\w]'), '');
      
      // Check keywords: Entropi and Hukum Termodinamika Kedua
      bool isEntropy = cleanWord == "Entropi";
      bool isThermo = cleanWord == "Termodinamika" || 
                       (cleanWord == "Hukum" && i < words.length - 2 && words[i+1].contains("Termodinamika")) ||
                       (cleanWord == "Kedua" && i > 0 && words[i-1].contains("Termodinamika"));

      if (isEntropy || isThermo) {
        spans.add(
          TextSpan(
            text: '$w ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey.shade400,
              decorationThickness: 1.5,
            ),
          ),
        );
      } else {
        spans.add(TextSpan(text: '$w '));
      }
    }
    spans.add(const TextSpan(text: '\n\n'));
    return TextSpan(children: spans);
  }

  void _showExportDialog(BuildContext context, {String topic = "Hukum Termodinamika Kedua"}) {
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

// Blinking cursor simulation
class _CursorIndicator extends StatefulWidget {
  const _CursorIndicator({Key? key}) : super(key: key);

  @override
  State<_CursorIndicator> createState() => _CursorIndicatorState();
}

class _CursorIndicatorState extends State<_CursorIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value,
          child: Container(
            width: 3,
            height: 18,
            color: AppTheme.accent,
          ),
        );
      },
    );
  }
}
