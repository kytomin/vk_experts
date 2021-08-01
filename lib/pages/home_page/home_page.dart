import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vk/pages/home_page/is_expert.dart';
import 'package:vk/pages/home_page/is_not_expert.dart';
import 'package:vk/pages/loading_page.dart';
import 'package:vk/providers/expert_provider.dart';
import 'package:vk/providers/newsfeed_provider.dart';
import 'package:vk_login/provider/vk_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NewsFeedProvider _newsFeedProvider;
  late ExpertProvider _expertProvider;
  late VkProvider _vkProvider;

  bool _isLoad = false;

  @override
  void didChangeDependencies() {
    _vkProvider = Provider.of<VkProvider>(context, listen: false);
    _expertProvider = Provider.of<ExpertProvider>(context, listen: false);
    _newsFeedProvider = Provider.of<NewsFeedProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  Future load(BuildContext context) async {
    final String appLang = Localizations.localeOf(context).languageCode;
    await _expertProvider.init(userId: _vkProvider.profile!.id, token: _vkProvider.token!, lang: appLang);
    if (_expertProvider.expertToday != null) {
      await _newsFeedProvider.init(token: _vkProvider.token!, topicName: _expertProvider.expertToday!.topicName);
    }
    precacheImage(NetworkImage(_vkProvider.profile!.photo100), context);
    setState(() {
      _isLoad = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: load(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done || _isLoad == false) {
            return LoadingPage();
          }
          if (_expertProvider.expertToday != null) {
            return IsExpertPage();
          }
          return IsNotExpertPage();
        });
  }
}
