// lib/screens/profile/language_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  
  void _showChangeLanguageDialog(BuildContext context, Locale locale) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final languageName = localeProvider.getNativeName(locale.languageCode);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.changeLanguageConfirm),
        content: Text(l10n.changeLanguageMessage(languageName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              localeProvider.setLocale(locale);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.languageChanged(languageName)),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFd63384),
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSettings),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFd63384), Color(0xFFe85aa1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.language, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.selectLanguage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.changeLanguageDesc,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Current Language
          Text(
            l10n.currentLanguage,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFd63384),
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFd63384).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFd63384).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Text(
                  localeProvider.getFlag(localeProvider.locale.languageCode),
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localeProvider.getNativeName(localeProvider.locale.languageCode),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      localeProvider.getLanguageName(localeProvider.locale.languageCode),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.check_circle, color: Color(0xFFd63384)),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Available Languages
          Text(
            l10n.availableLanguages,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFd63384),
            ),
          ),
          const SizedBox(height: 12),

          ...LocaleProvider.supportedLocales.map((locale) => 
            _buildLanguageItem(context, locale, localeProvider)
          ),

          const SizedBox(height: 32),

          // Info Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade600),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.infoNote,
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.languageChangeNote,
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(
    BuildContext context, 
    Locale locale, 
    LocaleProvider localeProvider
  ) {
    final isSelected = locale == localeProvider.locale;
    final languageCode = locale.languageCode;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 0,
        color: isSelected
            ? const Color(0xFFd63384).withValues(alpha: 0.1)
            : Colors.grey.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? const Color(0xFFd63384) : Colors.transparent,
          ),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFd63384)
                    : Colors.grey.shade300,
              ),
            ),
            child: Center(
              child: Text(
                localeProvider.getFlag(languageCode),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          title: Text(
            localeProvider.getNativeName(languageCode),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFFd63384) : null,
            ),
          ),
          subtitle: Text(
            localeProvider.getLanguageName(languageCode),
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFFd63384).withValues(alpha: 0.8)
                  : Colors.grey.shade600,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Color(0xFFd63384))
              : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
          onTap: isSelected
              ? null
              : () => _showChangeLanguageDialog(context, locale),
        ),
      ),
    );
  }
}
