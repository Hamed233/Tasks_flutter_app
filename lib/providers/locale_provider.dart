import 'package:flutter/material.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';

import '../l10n/l10n.dart';

class LocaleProvider extends ChangeNotifier {
   Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    CacheHelper.saveData(key: "current_lang", value: locale.languageCode);

    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}
