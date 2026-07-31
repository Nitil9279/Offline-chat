import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/nearby_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NearbyService(),
        ),
      ],
      child: const OfflineChatApp(),
    ),
  );
}

class OfflineChatApp extends StatelessWidget {
  const OfflineChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Chat',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),

      darkTheme: ThemeData.dark(useMaterial3: true),

      themeMode: ThemeMode.system,

      home: const SplashScreen(),
    );
  }
}
