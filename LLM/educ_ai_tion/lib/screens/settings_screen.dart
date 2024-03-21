import 'package:educ_ai_tion/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

// Settings Screen
//
// This screen provides options for customizing the application settings. Users can adjust preferences related to question generation,
//notification settings, and other customizable aspects of the app to tailor the experience to their needs.

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false; // Example setting

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        onMenuPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      //drawer: const DrawerMenu(),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // Add logic to persist this setting, e.g., using SharedPreferences or Firebase
            },
          ),
          ListTile(
            title: const Text('Account Settings'),
            onTap: () {
              // Navigate to account settings screen or show account settings options
            },
          ),
          // Add more settings options as needed
        ],
      ),
    );
  }
}
