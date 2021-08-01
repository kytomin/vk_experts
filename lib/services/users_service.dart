import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class UsersService {
  static Future<List> get(List<int> ids, {required String token}) async {
    String strIds = '';
    for (int id in ids) {
      strIds += '$id,';
    }

    http.Response res = await http.post(Uri.parse('https://api.vk.com/method/users.get?'), body: {
      'fields': 'photo_50,nickname',
      'user_ids': strIds,
      'access_token': token,
      'v': '5.131',
    });
    var jsonRes = await jsonDecode(res.body);
    return jsonRes['response'];
  }

  static findUserById(int id, List users) {
    for (var user in users) {
      if (id == user['id']) return user;
    }
    return null;
  }
}
