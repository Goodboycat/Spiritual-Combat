class AppSettings {
  final bool isDarkMode;
  final String language;
  final bool notificationsEnabled;
  final int notificationHour;
  final int notificationMinute;
  final bool notificationSound;

  AppSettings({
    this.isDarkMode = false,
    this.language = 'es',
    this.notificationsEnabled = true,
    this.notificationHour = 9,
    this.notificationMinute = 0,
    this.notificationSound = true,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    String? language,
    bool? notificationsEnabled,
    int? notificationHour,
    int? notificationMinute,
    bool? notificationSound,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
      notificationSound: notificationSound ?? this.notificationSound,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'notificationHour': notificationHour,
      'notificationMinute': notificationMinute,
      'notificationSound': notificationSound,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      language: json['language'] as String? ?? 'es',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      notificationHour: json['notificationHour'] as int? ?? 9,
      notificationMinute: json['notificationMinute'] as int? ?? 0,
      notificationSound: json['notificationSound'] as bool? ?? true,
    );
  }
}
