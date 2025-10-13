// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homePage => 'Home';

  @override
  String get search => 'Search';

  @override
  String get favorites => 'Favorites';

  @override
  String get profile => 'Profile';

  @override
  String get adoptionCategories => 'Adoption Categories';

  @override
  String get dog => 'Dog';

  @override
  String get cat => 'Cat';

  @override
  String get bird => 'Bird';

  @override
  String get all => 'All';

  @override
  String get popularAds => 'Popular Ads';

  @override
  String adsShowing(Object type) {
    return 'Showing $type ads!';
  }

  @override
  String get noAdsInCategory => 'No ads in selected category.';

  @override
  String get ads => 'Ads';

  @override
  String get searchHint => 'Search by type, breed, or name (e.g.: cat)...';

  @override
  String get noResultsFound => 'No ads found matching your criteria.';
}
