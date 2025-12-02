// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get appname => 'ColorTrix';

  @override
  String get image_upload__title => 'Image Picker';

  @override
  String get image_upload__library => 'Photo Library';

  @override
  String get image_upload__camera => 'Camera';

  @override
  String get tabs__matrix => 'Matrix';

  @override
  String get tabs__presets => 'Presets';

  @override
  String get presets__disabled_message => 'Pick image to show presets';
}
