import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:combate_espiritual/generated/l10n/app_localizations.dart';
import '../services/app_state.dart';

class NotificationPermissionScreen extends StatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  State<NotificationPermissionScreen> createState() =>
      _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState
    extends State<NotificationPermissionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
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

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.brightness == Brightness.dark
                  ? Colors.deepPurple.shade900
                  : Colors.blue.shade50,
              theme.brightness == Brightness.dark
                  ? Colors.black
                  : Colors.purple.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_active,
                      size: 120,
                      color: theme.brightness == Brightness.dark
                          ? Colors.deepPurple.shade300
                          : Colors.deepPurple,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      l10n.notificationPermission,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.notificationMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.brightness == Brightness.dark
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 60),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () => _allowNotifications(context),
                        icon: const Icon(Icons.check_circle, size: 28),
                        label: Text(
                          l10n.allow,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade400,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: Colors.deepPurple.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => _skipNotifications(context),
                      child: Text(
                        l10n.notNow,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.brightness == Brightness.dark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _allowNotifications(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final granted = await appState.requestNotificationPermission();
    
    if (granted) {
      await appState.setNotificationsEnabled(true);
    }
    
    await appState.completeFirstLaunch();
    
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _skipNotifications(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.setNotificationsEnabled(false);
    await appState.completeFirstLaunch();
    
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}
