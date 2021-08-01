import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:vk/domain/expert.dart';
import 'package:vk/services/expert_service.dart';

class ExpertProvider with ChangeNotifier {
  bool _isInit = false;

  late final int userId;
  late final String token;
  late final lang;
  late String rating;
  late List<Expert> chart;
  Expert? expertTotal;
  Expert? expertToday;

  /// [userId] - id from VK
  /// [token] - access key from VK
  /// [lang] - language code ('ru', 'en')
  Future<void> init({required int userId, required String token, required String lang}) async {
    this.userId = userId;
    this.token = token;
    this.lang = lang;
    _isInit = true;

    await Future.wait([
      updateExpert(),
      updateChart(),
    ]);

    Timer.periodic(Duration(minutes: 20), (timer) {
      updateExpert();
    });
  }

  Future<void> updateExpert() async {
    if (!_isInit) throw "You must call 'init' method before";
    expertToday = await ExpertService.getUser(id: userId, chartType: ChartType.current_day, lang: lang);
    expertTotal = await ExpertService.getUser(id: userId, chartType: ChartType.total, lang: lang);
    if (expertToday != null) {
      rating = await ExpertService.getRating(token: token, topicName: expertToday!.topicName);
      if (expertTotal == null) expertTotal = expertToday;
    }
    notifyListeners();
  }

  Future<void> updateChart({int offset = 0, int count = 50, ChartType chartType = ChartType.total}) async {
    if (!_isInit) throw "You must call 'init' method before";
    chart = await ExpertService.getChart(count: count, chartType: chartType, offset: offset, lang: lang);
  }
}
