import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PurePowerAdminApp());
}

class PurePowerAdminApp extends StatelessWidget {
  const PurePowerAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pure & Power Admin',
      theme: AppTheme.light(),
      home: const LoginScreen(),
    );
  }
}
