// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get homePage => 'Ana Sayfa';

  @override
  String get search => 'Ara';

  @override
  String get favorites => 'Favoriler';

  @override
  String get profile => 'Profil';

  @override
  String get adoptionCategories => 'Sahiplendirme Kategorileri';

  @override
  String get dog => 'Köpek';

  @override
  String get cat => 'Kedi';

  @override
  String get bird => 'Kuş';

  @override
  String get all => 'Hepsi';

  @override
  String get popularAds => 'Popüler İlanlar';

  @override
  String adsShowing(Object type) {
    return '$type ilanları gösteriliyor!';
  }

  @override
  String get noAdsInCategory => 'Seçili kategoride ilan bulunmamaktadır.';

  @override
  String get ads => 'İlanları';

  @override
  String get searchHint => 'Tür, ırk veya ada göre ara (ör: kedi)...';

  @override
  String get noResultsFound => 'Aradığınız kriterlere uygun ilan bulunamadı.';
}
