import 'package:flutter/material.dart';
import '../constants.dart';
import '../main.dart';

class ProfilePage extends StatelessWidget {
  final Function(bool) toggleTheme;
  final ThemeMode currentThemeMode;
  // EKSİK OLAN PARAMETRELER EKLENDİ
  final Locale currentLocale;
  final Function(Locale) changeLanguage;

  const ProfilePage({
    super.key,
    required this.toggleTheme,
    required this.currentThemeMode,
    required this.currentLocale,
    required this.changeLanguage, 
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        currentThemeMode == ThemeMode.dark ||
        (currentThemeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final isTurkish = currentLocale == turkishLocale;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: secondaryColor,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Profilim',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            ListTile(
              leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              title: const Text('Karanlık Mod'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (bool newValue) {
                  toggleTheme(newValue);
                },
                activeThumbColor: primaryColor,
              ),
              onTap: () {
                toggleTheme(!isDarkMode);
              },
            ),

            ListTile(
              leading: const Icon(Icons.translate),
              title: Text(isTurkish ? 'Dil: Türkçe' : 'Language: English'),
              onTap: () {
                final newLocale = isTurkish ? englishLocale : turkishLocale;
                changeLanguage(newLocale);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      newLocale == englishLocale
                          ? 'Language changed to English!'
                          : 'Dil Türkçe olarak değiştirildi!',
                    ),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('coming soon')));
              },
            ),

            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Bildirimler'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Çıkış Yap',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
