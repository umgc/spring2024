import 'package:educ_ai_tion/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:educ_ai_tion/theme_provider.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // for proper handling of API keys in .env file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load environment variables
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
        create: (context) => ThemeProvider(), child: const MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        hintColor: Colors.cyan,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* Dark theme settings */
        primaryColor: Colors.lightBlue[800],
        hintColor: Colors.cyan[600],
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: WelcomeScreen(),
    );
  }
}
