import 'package:flutter/material.dart';
import 'package:wordpress_app/models/sidemenu.dart';
import 'package:wordpress_app/services/wordpress_service.dart';

class SidemennuBloc extends ChangeNotifier {
  Sidemenu _categoryData =
      Sidemenu(); // Initialize with an empty Sidemenu object
  Sidemenu get categoryData => _categoryData;

  Future fetchData() async {
    _categoryData = Sidemenu(); // clear the current list.
    notifyListeners();
    _categoryData = await WordPressService().getSidemenu();
    notifyListeners();
  }
}
