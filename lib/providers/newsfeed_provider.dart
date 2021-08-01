import 'package:flutter/cupertino.dart';
import 'package:vk/domain/post.dart';
import 'package:vk/services/newsfeed_service.dart';

class NewsFeedProvider with ChangeNotifier {
  final NewsFeedService _newsFeedService = NewsFeedService();

  late final String token;
  late final String topicName;
  bool _isInit = false;

  List<Post> feed = [];

  Future<void> init({required String token, required String topicName}) async {
    this.token = token;
    this.topicName = topicName;
    _isInit = true;
    await update();
  }

  Future<void> update({int count = 50}) async {
    if (_isInit == false) throw "You must call 'init' method before";
    await _newsFeedService.updateNewsFeed(token: token, topicName: topicName, count: count);
    feed = _newsFeedService.newsFeed;
    notifyListeners();
  }

  void doubtCategory({required int sourceId, required int postId}) {
    if (_isInit == false) return;
    _newsFeedService.doubtCategory(sourceId: sourceId, postId: postId, token: token);
  }

  void setPostVote({required int sourceId, required int postId, required int vote}) {
    if (_isInit == false) return;
    _newsFeedService.setPostVote(sourceId: sourceId, postId: postId, token: token, vote: vote);
  }

  void setLike({required int sourceId, required int postId}) {
    if (_isInit == false) return;
    _newsFeedService.setLike(sourceId: sourceId, postId: postId, token: token);
  }

  void deleteLike({required int sourceId, required int postId}) {
    if (_isInit == false) return;
    _newsFeedService.deleteLike(sourceId: sourceId, postId: postId, token: token);
  }
}
