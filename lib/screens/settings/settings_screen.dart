import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _enableNotifications = true;
  bool _autoBackup = true;
  String _selectedLanguage = 'Bahasa Indonesia';
  String _selectedModel = 'DeepSpeech v2.4';
  
  final _apiKeyController = TextEditingController(text: 'sibi_sk_••••••••••••••••••••');
  bool _obscureApiKey = true;

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pengaturan Sistem',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Konfigurasi kredensial API model, notifikasi, dan parameter pengenalan suara.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
              const SizedBox(height: 32),

              // Settings Sections
              _buildSectionTitle('KREDENSIAL API'),
              const SizedBox(height: 12),
              _buildCard([
                ListTile(
                  title: const Text('API Key SIBI-AI', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Digunakan untuk autentikasi ke engine AI pusat.'),
                  trailing: SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _apiKeyController,
                      obscureText: _obscureApiKey,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureApiKey ? Icons.visibility_off : Icons.visibility,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureApiKey = !_obscureApiKey;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 24),

              _buildSectionTitle('AI & SPEECH RECOGNITION'),
              const SizedBox(height: 12),
              _buildCard([
                ListTile(
                  title: const Text('Model Pengenalan Isyarat', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Versi model aktif yang memproses input video kamera.'),
                  trailing: DropdownButton<String>(
                    value: _selectedModel,
                    underline: const SizedBox(),
                    items: ['DeepSpeech v2.4', 'SIBI-Net v1.0', 'Mediapipe Sign-v3'].map((val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val, style: const TextStyle(fontWeight: FontWeight.w600)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedModel = val;
                        });
                      }
                    },
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: const Text('Bahasa Utama (Default)', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Target bahasa terjemahan isyarat.'),
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    underline: const SizedBox(),
                    items: ['Bahasa Indonesia', 'English', 'Basa Sunda', 'Basa Jawa'].map((val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val, style: const TextStyle(fontWeight: FontWeight.w600)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedLanguage = val;
                        });
                      }
                    },
                  ),
                ),
              ]),
              const SizedBox(height: 24),

              _buildSectionTitle('PREFERENSI APLIKASI'),
              const SizedBox(height: 12),
              _buildCard([
                SwitchListTile(
                  title: const Text('Aktifkan Notifikasi Real-time', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Dapatkan peringatan suara jika perangkat keras mengalami malfungsi.'),
                  value: _enableNotifications,
                  activeColor: AppTheme.accent,
                  onChanged: (val) {
                    setState(() {
                      _enableNotifications = val;
                    });
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: const Text('Auto-Backup Snapshot DB', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Sinkronisasi otomatis ke cloud server setiap tengah malam.'),
                  value: _autoBackup,
                  activeColor: AppTheme.accent,
                  onChanged: (val) {
                    setState(() {
                      _autoBackup = val;
                    });
                  },
                ),
              ]),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Reset Default'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pengaturan Berhasil Disimpan!'),
                          backgroundColor: AppTheme.success,
                        ),
                      );
                    },
                    child: const Text('Simpan Perubahan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppTheme.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 1.5),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
