import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vk/domain/post.dart';

class NewsFeedService {
  /// [_startFrom] is the ID required to get the next page of results.
  /// The value required to be passed in this parameter is returned
  /// in the next_from response field.
  String? _startFrom;

  /// [_groups] contain the information about groups who are in the feed list;
  List? _groups;

  /// [_profiles] contain the information about users who are in the feed list;
  List? _profiles;

  /// [_items] is a list of news for the current user
  List? _items;

  /// [_newsFeed] is a [_items] reduced to List of [Post]
  List<Post> _newsFeed = [];

  List<Post> get newsFeed => _newsFeed;

  Future<void> updateNewsFeed({required int count, required String token, required topicName}) async {
    int code = convertTopicNameToCode(topicName);
    var res = await http.post(
      Uri.parse('https://api.vk.com/method/newsfeed.getCustom?'),
      body: {
        'lang': '0',
        'feed_id': 'discover_category/$code',
        'format': 'json',
        'v': '5.100',
        'access_token': token,
        'count': '$count',
        if (_startFrom != null) 'start_from': '$_startFrom',
      },
    );
    var jsonRes = await jsonDecode(res.body);

    if (jsonRes['error'] != null) return;

    _groups = jsonRes['response']['groups'];
    _profiles = jsonRes['response']['profiles'];
    _items = jsonRes['response']['items'];

    /// [_items.first] may contain service information about the user
    final int _startIndex = _items![0]['type'] == 'expert_card' ? 1 : 0;

    _newsFeed = [];
    for (int i = _startIndex; i < _items!.length; i++) {
      _newsFeed.add(Post.fromJSON(_items![i], _findBySourceId(_items![i]['source_id'])));
    }

    _startFrom = jsonRes['response']['next_from'];
  }

  void doubtCategory({required int sourceId, required int postId, required String token}) async {
    await http.post(Uri.parse(
        'https://api.vk.com/method/newsfeed.doubtCategory?owner_id=$sourceId&post_id=$postId&new_vote=0&format=json&v=5.100&access_token=$token'));
  }

  void setPostVote({required int sourceId, required int postId, required String token, required int vote}) async {
    await http.get(Uri.parse(
        'https://api.vk.com/method/newsfeed.setPostVote?owner_id=$sourceId&post_id=$postId&new_vote=$vote&format=json&v=5.100&access_token=$token'));
  }

  void setLike({required int sourceId, required int postId, required String token}) {
    http.get(Uri.parse(
        'https://api.vk.com/method/likes.add?type=post&owner_id=$sourceId&item_id=$postId&format=json&v=5.100&access_token=$token'));
  }

  void deleteLike({required int sourceId, required int postId, required String token}) {
    http.get(Uri.parse(
        'https://api.vk.com/method/likes.delete?type=post&owner_id=$sourceId&item_id=$postId&format=json&v=5.100&access_token=$token'));
  }

  static int convertTopicNameToCode(String topicName) {
    if (topicName == 'Арт' || topicName == 'Art') return 1;

    if (topicName == 'IT') return 7;

    if (topicName == 'Игры' || topicName == 'Games') return 12;

    if (topicName == 'Музыка' || topicName == 'Music') return 16;

    if (topicName == 'Новости' || topicName == 'News') return 18;

    if (topicName == 'Фото' || topicName == 'Photos') return 19;

    if (topicName == 'Наука' || topicName == 'Science') return 21;

    if (topicName == 'Спорт' || topicName == 'Sports') return 23;

    if (topicName == 'Туризм' || topicName == 'Travel') return 25;

    if (topicName == 'Кино' || topicName == 'Movies') return 26;

    if (topicName == 'Юмор' || topicName == 'Humor') return 32;

    if (topicName == 'Стиль' || topicName == 'Style') return 43;

    return 18;
  }

  _findBySourceId(int id) {
    if (id < 0) {
      id = id.abs();
      for (var group in _groups!) {
        if (group['id'] == id) {
          return group;
        }
      }
    } else {
      for (var profile in _profiles!) {
        if (profile['id'] == id) {
          return profile;
        }
      }
    }
  }
}
