import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:combate_espiritual/generated/l10n/app_localizations.dart';
import '../services/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    final settings = appState.settings;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.brightness == Brightness.dark
            ? Colors.deepPurple.shade900
            : Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: theme.brightness == Brightness.dark
                ? [
                    Colors.deepPurple.shade900,
                    Colors.black,
                  ]
                : [
                    Colors.blue.shade50,
                    Colors.purple.shade50,
                  ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSettingCard(
                context,
                icon: Icons.brightness_6,
                title: l10n.darkMode,
                trailing: Switch(
                  value: settings.isDarkMode,
                  onChanged: (value) {
                    appState.setDarkMode(value);
                  },
                  activeTrackColor: Colors.deepPurple.shade300,
                  activeThumbColor: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingCard(
                context,
                icon: Icons.language,
                title: l10n.language,
                subtitle: settings.language == 'es' ? l10n.spanish : l10n.english,
                onTap: () => _showLanguageDialog(context, appState),
              ),
              const SizedBox(height: 16),
              _buildSettingCard(
                context,
                icon: Icons.notifications,
                title: l10n.notifications,
                trailing: Switch(
                  value: settings.notificationsEnabled,
                  onChanged: (value) {
                    appState.setNotificationsEnabled(value);
                  },
                  activeTrackColor: Colors.deepPurple.shade300,
                  activeThumbColor: Colors.deepPurple,
                ),
              ),
              if (settings.notificationsEnabled) ...[
                const SizedBox(height: 16),
                _buildSettingCard(
                  context,
                  icon: Icons.access_time,
                  title: l10n.notificationTime,
                  subtitle:
                      '${settings.notificationHour.toString().padLeft(2, '0')}:${settings.notificationMinute.toString().padLeft(2, '0')}',
                  onTap: () => _showTimePicker(context, appState),
                ),
                const SizedBox(height: 16),
                _buildSettingCard(
                  context,
                  icon: Icons.volume_up,
                  title: l10n.notificationSound,
                  trailing: Switch(
                    value: settings.notificationSound,
                    onChanged: (value) {
                      appState.setNotificationSound(value);
                    },
                    activeTrackColor: Colors.deepPurple.shade300,
                  activeThumbColor: Colors.deepPurple,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              _buildAboutCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        color: theme.brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.deepPurple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.grey.shade800,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null)
                  trailing
                else if (onTap != null)
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      color: theme.brightness == Brightness.dark
          ? Colors.grey.shade900
          : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.deepPurple,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.about,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.aboutText,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${l10n.version} 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLanguageDialog(BuildContext context, AppState appState) async {
    final l10n = AppLocalizations.of(context)!;
    String selectedLanguage = appState.settings.language;
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text(l10n.spanish),
                  value: 'es',
                  groupValue: selectedLanguage,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedLanguage = value;
                      });
                      appState.setLanguage(value);
                      Navigator.pop(context);
                    }
                  },
                ),
                RadioListTile<String>(
                  title: Text(l10n.english),
                  value: 'en',
                  groupValue: selectedLanguage,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedLanguage = value;
                      });
                      appState.setLanguage(value);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context, AppState appState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: appState.settings.notificationHour,
        minute: appState.settings.notificationMinute,
      ),
    );

    if (picked != null) {
      appState.setNotificationTime(picked.hour, picked.minute);
    }
  }
}
