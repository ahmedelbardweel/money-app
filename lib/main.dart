import 'package:flutter/material.dart';
import 'core/supabase_config.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase client
  try {
    await SupabaseConfig.initialize();
  } catch (e) {
    debugPrint('Supabase initialization error: $e');
  }

  runApp(const AmwalApp());
}

class AmwalApp extends StatelessWidget {
  const AmwalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أموال',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
