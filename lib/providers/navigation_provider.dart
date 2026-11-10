import 'package:flutter/foundation.dart';

import 'package:gameshelf/config/app_tabs.dart';

class NavigationProvider extends ChangeNotifier {
  int _index = AppTab.home;

  int get index => _index;

  void select(int index) {
    if (index == _index) return;
    _index = index;
    notifyListeners();
  }
}
