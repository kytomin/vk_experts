import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:http/http.dart';
import 'package:vk/domain/expert.dart';
import 'package:vk/services/newsfeed_service.dart';

abstract class ExpertService {
  static Future<Expert?> getUser({required id, ChartType chartType = ChartType.total, required String lang}) async {
    Response res =
        await get(Uri.parse('http://expert.kuthon.ru/api/$id?type=${EnumToString.convertToString(chartType)}'));
    var jsonRes = await jsonDecode(res.body);
    if (jsonRes['error'] != null) {
      return null;
    } else {
      return Expert.fromJSON(jsonRes, lang: lang);
    }
  }

  static Future<List<Expert>> getChart(
      {required int offset, required int count, required ChartType chartType, required String lang}) async {
    Response res = await get(Uri.parse(
        'http://expert.kuthon.ru/api/all?type=${EnumToString.convertToString(chartType)}&offset=$offset&count=$count'));
    var jsonRes = await jsonDecode(res.body);
    List<Expert> chart = (jsonRes.map<Expert>((value) => Expert.fromJSON(value, lang: lang))).toList();
    return chart;
  }

  static Future<String> getRating({required String token, required String topicName}) async {
    final int code = NewsFeedService.convertTopicNameToCode(topicName);
    var res = await post(
      Uri.parse('https://api.vk.com/method/newsfeed.getCustom?'),
      body: {
        'lang': '0',
        'feed_id': 'discover_category/$code',
        'format': 'json',
        'v': '5.100',
        'access_token': token,
        'count': '1',
      },
    );
    var jsonRes = await jsonDecode(res.body);

    return '${jsonRes['response']['items'][0]['expert_card']['rating']['value']}';
  }
}

enum ChartType { total, current_day }
