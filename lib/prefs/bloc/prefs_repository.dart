import 'dart:async';

import 'package:hive/hive.dart';

import '../../constants.dart';

class PrefsRepository {
  static final String _boxId = 'prefsHiveBox';
  final Box _box;

  const PrefsRepository(this._box);

  static FutureOr<PrefsRepository> openRepository() async {
    var box = await Hive.openBox(_boxId);
    return PrefsRepository(box);
  }

  FutureOr<void> saveAll(Map<String, dynamic> values) async {
    await _box.putAll(values);
  }

  FutureOr<Map<String, dynamic>> loadAll() async {
    var prefs = <String, dynamic>{};

    prefs[prefKeyUrl] = _box.get(prefKeyUrl, defaultValue: '');
    prefs[prefKeyJWTToken] = _box.get(prefKeyJWTToken, defaultValue: '');

    return prefs;
  }

  FutureOr<Map<String, dynamic>> load(List<String> keys) async {
    var prefs = <String, dynamic>{};

    keys.forEach((key) {
      prefs[key] = _box.get(key);
    });

    return prefs;
  }

  void dispose() {
    if (_box != null) _box.close();
  }
}
