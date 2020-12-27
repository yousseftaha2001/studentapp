import 'package:flutter/material.dart';

import '../colos,fonts.dart';

class TaskCardProvider with ChangeNotifier {
  bool _selectedMode=false;
  bool get mode=>_selectedMode;
   changeMode(bool val){
   _selectedMode=val;
   notifyListeners();

  }
}
