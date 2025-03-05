import 'package:flutter/material.dart';
import 'package:wordpress_app/models/ads_model.dart';
import 'package:wordpress_app/models/news_programs.dart';
import 'package:wordpress_app/models/sidemenu.dart';
import 'package:wordpress_app/services/wordpress_service.dart';

class AdsManagerBloc extends ChangeNotifier {
  AdsManagerModel _adsManager =
      AdsManagerModel(); // Initialize with an empty Sidemenu object
  AdsManagerModel get adManagerData => _adsManager;
  Future fetchData() async {
    _adsManager = AdsManagerModel(); // clear the current list.
    notifyListeners();
    _adsManager = await WordPressService().getAdsManager();
    notifyListeners();
  }
}
