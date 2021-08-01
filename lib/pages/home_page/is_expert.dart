import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcard/tcard.dart';
import 'package:vk/generated/l10n.dart';
import 'package:vk/pages/chart_page.dart';
import 'package:vk/pages/expert_card_page.dart';
import 'package:vk/presentation/vk_icons.dart';
import 'package:vk/providers/expert_provider.dart';
import 'package:vk/providers/newsfeed_provider.dart';
import 'package:vk/widgets/post_card.dart';
import 'package:vk/widgets/show_loading.dart';
import 'package:vk_login/provider/vk_provider.dart';

class IsExpertPage extends StatefulWidget {
  @override
  _IsExpertPageState createState() => _IsExpertPageState();
}

class _IsExpertPageState extends State<IsExpertPage> {
  final TCardController _tCardController = TCardController();

  late VkProvider _vkProvider;
  late NewsFeedProvider _newsFeedProvider;
  late ExpertProvider _expertProvider;
  late List<Widget> posts;

  late bool _isLiked;
  late bool _isReported;
  late bool _isDown;
  late bool _isUp;

  int _index = 0;

  void setUpVote() async {
    _newsFeedProvider.feed[_index].rate = 1;
    _newsFeedProvider.setPostVote(
        sourceId: _newsFeedProvider.feed[_index].sourceId, postId: _newsFeedProvider.feed[_index].postId, vote: 1);

    print('up');
  }

  void setDownVote() async {
    _newsFeedProvider.feed[_index].rate = -1;
    _newsFeedProvider.setPostVote(
        sourceId: _newsFeedProvider.feed[_index].sourceId, postId: _newsFeedProvider.feed[_index].postId, vote: -1);

    print('down');
  }

  void like() async {
    if (_isLiked == false)
      _newsFeedProvider.setLike(
          sourceId: _newsFeedProvider.feed[_index].sourceId, postId: _newsFeedProvider.feed[_index].postId);
    else
      _newsFeedProvider.deleteLike(
          sourceId: _newsFeedProvider.feed[_index].sourceId, postId: _newsFeedProvider.feed[_index].postId);

    _isLiked = !_isLiked;
    _newsFeedProvider.feed[_index].isLike = true;

    print('like');
  }

  void setReport() async {
    if (_isReported == false) {
      _isReported = !_isReported;
      _newsFeedProvider.feed[_index].canDoubtCategory = false;
      _newsFeedProvider.doubtCategory(
          sourceId: _newsFeedProvider.feed[_index].sourceId, postId: _newsFeedProvider.feed[_index].postId);
      print('report');
    }
  }

  @override
  void didChangeDependencies() {
    _vkProvider = Provider.of<VkProvider>(context);
    _newsFeedProvider = Provider.of<NewsFeedProvider>(context);
    _expertProvider = Provider.of<ExpertProvider>(context);
    posts = List.generate(_newsFeedProvider.feed.length, (index) {
      return PostCard(_newsFeedProvider.feed[index]);
    });
    updateBottomBar(0);
    super.didChangeDependencies();
  }

  Future<void> updateNewsFeed(BuildContext context) async {
    await showLoading(context: context, function: _newsFeedProvider.update);
    setState(() {
      posts = List.generate(_newsFeedProvider.feed.length, (index) {
        return PostCard(_newsFeedProvider.feed[index]);
      });
      _tCardController.reset(cards: posts);
      updateBottomBar(0);
    });
  }

  void updateBottomBar(int index) {
    if (index < posts.length)
      setState(() {
        _isLiked = _newsFeedProvider.feed[index].isLike;
        _isReported = !_newsFeedProvider.feed[index].canDoubtCategory;
        _isDown = _newsFeedProvider.feed[index].rate == -1;
        _isUp = _newsFeedProvider.feed[index].rate == 1;
        _index = index;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('VK Experts'),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              _createDrawerHeader(
                  context: context,
                  image: NetworkImage(_vkProvider.profile!.photo100),
                  fullname: '${_vkProvider.profile!.firstName} ${_vkProvider.profile!.lastName}',
                  thematic: '${_expertProvider.expertToday!.topicName}'),
              _createDrawerItem(
                  icon: VKIcons.cards_2_outline_28,
                  text: S.of(context).expert_card,
                  context: context,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ExpertCardPage()))),
              _createDrawerItem(
                  icon: VKIcons.stars_3_outline_56,
                  text: S.of(context).rating,
                  context: context,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChartPage()))),
              //_createDrawerItem(icon: VKIcons.settings_28, text: 'Настройки', context: context),
              //_createDrawerItem(icon: VKIcons.question_outline_20, text: 'Помощь', context: context),
              //_createDrawerItem(icon: VKIcons.rouble_circle_fill_blue_20, text: 'Поддержать автора', context: context),
              _createDrawerItem(
                  onTap: () {
                    _vkProvider.logout();
                  },
                  icon: Icons.exit_to_app_outlined,
                  text: S.of(context).logout,
                  context: context),
            ],
          ),
        ),
        body: SizedBox.expand(
          child: Column(
            children: [
              Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 30,
                child: posts.length == 0
                    ? SizedBox()
                    : TCard(
                        delaySlideFor: 300,
                        slideSpeed: 15,
                        controller: _tCardController,
                        cards: posts,
                        onForward: (index, info) {
                          if (info.direction == SwipDirection.Left) {
                            setDownVote();
                          }
                          if (info.direction == SwipDirection.Right) {
                            setUpVote();
                          }
                          updateBottomBar(index);
                        },
                        onBack: (index, info) {
                          updateBottomBar(index);
                        },
                        onEnd: () async {
                          print('END.');
                          updateNewsFeed(context);
                        },
                        lockYAxis: true,
                      ),
              ),
              Spacer(
                flex: 1,
              ),
              Expanded(
                  flex: 3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () {
                          like();
                          setState(() {});
                        },
                        icon: Icon(
                          VKIcons.like_28,
                          color: _isLiked ? Colors.red : null,
                        ),
                        tooltip: S.of(context).like,
                      ),
                      IconButton(
                        onPressed: () {
                          updateNewsFeed(context);
                        },
                        icon: Icon(
                          VKIcons.arrow_up_circle_outline_28,
                        ),
                        tooltip: S.of(context).update,
                      ),
                      IconButton(
                        onPressed: () {
                          setReport();
                          setState(() {});
                        },
                        icon: Icon(
                          VKIcons.report_outline_28,
                          color: _isReported ? Colors.amber : null,
                        ),
                        tooltip: S.of(context).doubt_category,
                      ),
                      IconButton(
                        onPressed: () {
                          if (_tCardController.index > 0) _tCardController.back();
                        },
                        icon: Icon(VKIcons.skip_previous_28),
                        tooltip: S.of(context).back,
                      ),
                      IconButton(
                        onPressed: () {
                          _tCardController.forward(direction: SwipDirection.Left);
                        },
                        icon: Icon(VKIcons.arrow_down_outline_28, color: _isDown ? Colors.blue : null),
                        tooltip: S.of(context).down_vote,
                      ),
                      IconButton(
                        onPressed: () {
                          _tCardController.forward(direction: SwipDirection.Right);
                        },
                        icon: Icon(
                          VKIcons.arrow_up_outline_28,
                          color: _isUp ? Colors.blue : null,
                        ),
                        tooltip: S.of(context).up_vote,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  )),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ));
  }
}

Widget _createDrawerItem(
    {required IconData icon, required String text, GestureTapCallback? onTap, required BuildContext context}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon, color: Theme.of(context).accentColor),
        SizedBox(
          width: 20,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    ),
    onTap: onTap,
  );
}

Widget _createDrawerHeader(
    {required BuildContext context, required ImageProvider image, required String fullname, required String thematic}) {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(
                flex: 3,
              ),
              Container(
                width: 75,
                height: 75,
                decoration: new BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: image)),
              ),
              Spacer(
                flex: 4,
              ),
              Text(
                fullname,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.white),
              ),
              Text(
                thematic,
                style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
              ),
              Spacer(
                flex: 1,
              ),
            ],
          )),
          IconButton(
              onPressed: () {
                if (AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark)
                  AdaptiveTheme.of(context).setLight();
                else
                  AdaptiveTheme.of(context).setDark();
              },
              icon: Icon(
                Icons.wb_sunny_outlined,
                color: Colors.white,
              )),
        ],
      ));
}
