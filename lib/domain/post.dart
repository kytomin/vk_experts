import 'package:flutter/material.dart';

class Post {
  late final int sourceId;

  /// [date] in Unix format
  late final int date;

  late final int postId;

  /// [rate] contains 3 values:
  /// 1 - up vote, -1 - down vote, 0 - no vote yet
  late int rate;
  late final String name;
  late final Image profileImage;
  late final String profileImageUrl;
  late final List<Widget> attachments;
  late final String text;
  late bool isLike;
  late final int likes;
  late final int reposts;
  late final int views;
  late bool canDoubtCategory;

  Post.fromJSON(item, data) {
    sourceId = item['source_id'];
    date = item['date'];
    rate = item['rating']['rated'];
    text = item['text'];
    isLike = item['likes']['user_likes'] == 0 ? false : true;
    postId = item['post_id'];
    likes = item['likes']['count'];
    reposts = item['reposts']['count'];
    views = item['views']['count'];
    name = data['name'] ?? '${data['first_name']} ${data['last_name']}';
    profileImageUrl = data['photo_50'];
    profileImage = Image.network(
      '$profileImageUrl',
      fit: BoxFit.fitWidth,
    );
    canDoubtCategory = item['can_doubt_category'];

    attachments = [];
    for (var value in item['attachments']) {
      if (value['type'] == 'photo') attachments.add(Image.network('${value['photo']['sizes'].last['url']}', fit: BoxFit.contain));
    }
  }

  @override
  String toString() {
    return 'Post(sourceId: $sourceId, postId: $postId, name: $name)';
  }
}
