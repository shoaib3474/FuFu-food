import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'arabic.dart';
import 'bangla.dart';
import 'english.dart';
import 'french.dart';
import 'italian.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': english,
    'bn': bangla,
    'fr': french,
    'ar': arabic,
    'it': its,
  };
}
