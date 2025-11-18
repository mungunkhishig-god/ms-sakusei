import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ms_sakusei/screens/home_screen.dart';
import 'package:ms_sakusei/services/config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final configService = ConfigService();
  await configService.init();
  runApp(MyApp(configService: configService));
}

class MyApp extends StatelessWidget {
  final ConfigService configService;

  const MyApp({super.key, required this.configService});

  @override
  Widget build(BuildContext context) {
    return Provider<ConfigService>.value(
      value: configService,
      child: MaterialApp(
        title: 'MS Sakusei',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
