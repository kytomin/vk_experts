import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard(this.post);

  final post;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.fromBorderSide(BorderSide(width: 0.5, color: Theme.of(context).accentColor)),
          boxShadow: [BoxShadow(offset: Offset(0, 17), spreadRadius: -13.0, color: Theme.of(context).shadowColor)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipOval(
                    child: post.profileImage,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text(
                  post.name,
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2,
                ))
              ],
            ),
            SizedBox(height: 10),
            if (post.attachments.length != 0) ...[
              Flexible(
                child: post.attachments[0],
                fit: FlexFit.loose,
              ),
              SizedBox(
                height: 10,
              )
            ],
            SizedBox(
              width: double.infinity,
              child: Text(
                post.text,
                textAlign: TextAlign.start,
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ));
  }
}
