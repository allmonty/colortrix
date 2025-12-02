// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get language => 'Português (Brasil)';

  @override
  String get appname => 'ColorTrix';

  @override
  String get image_upload__title => 'Selecionar Imagem';

  @override
  String get image_upload__library => 'Biblioteca de Fotos';

  @override
  String get image_upload__camera => 'Câmera';

  @override
  String get tabs__matrix => 'Matriz';

  @override
  String get tabs__presets => 'Estilos';

  @override
  String get presets__disabled_message =>
      'Selecione uma imagem para mostrar os estilos salvos';
}
