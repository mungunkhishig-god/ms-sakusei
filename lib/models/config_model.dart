class AppConfig {
  final String openaiApiKey;

  AppConfig({required this.openaiApiKey});

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      openaiApiKey: json['openaiApiKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openaiApiKey': openaiApiKey,
    };
  }
}
