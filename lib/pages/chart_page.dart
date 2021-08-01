import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vk/domain/expert.dart';
import 'package:vk/generated/l10n.dart';
import 'package:vk/pages/loading_page.dart';
import 'package:vk/providers/expert_provider.dart';
import 'package:vk/services/users_service.dart';
import 'package:vk/widgets/my_scroll_behavior.dart';
import 'package:vk_login/provider/vk_provider.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  late VkProvider _vkProvider;
  late ExpertProvider _expertProvider;
  late List<Expert> _chart;
  late List _usersData;

  int startIndex = 0;
  int endIndex = 50;

  Future<void> load(BuildContext context) async {
    final List<int> userIds = _chart.map<int>((Expert value) => value.id).toList();
    _usersData = await UsersService.get(userIds, token: _vkProvider.token!);
    for (final user in _usersData) {
      precacheImage(NetworkImage('${user['photo_50']}'), context);
    }
  }

  @override
  void didChangeDependencies() {
    _vkProvider = Provider.of<VkProvider>(context);
    _expertProvider = Provider.of<ExpertProvider>(context);
    _chart = _expertProvider.chart;
    startIndex = _chart.first.position - 1;
    endIndex = _chart.last.position;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: load(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return LoadingPage();
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).rating),
            ),
            body: SizedBox.expand(
              child: Column(
                children: [
                  Expanded(
                      child: ScrollConfiguration(
                    behavior: MyScrollBehavior(),
                    child: ListView(
                      children: [
                        if (startIndex != 0)
                          TextButton(
                              onPressed: () async {
                                endIndex = startIndex;
                                startIndex = endIndex - 50;
                                await _expertProvider.updateChart(offset: startIndex, count: 50);
                                _chart = _expertProvider.chart;
                                setState(() {});
                              },
                              child: Text(S.of(context).show_more)),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).experts,
                                style: Theme.of(context).textTheme.caption,
                              ),
                              Text(S.of(context).posts, style: Theme.of(context).textTheme.caption)
                            ],
                          ),
                        ),
                        ..._chart.map((expert) {
                          var user = UsersService.findUserById(expert.id, _usersData);
                          return _getTile(context,
                              position: expert.position,
                              photoUrl: user['photo_50'],
                              fullname: '${user['first_name']} ${user['last_name']}',
                              topicName: expert.topicName,
                              actionsCount: expert.actionsCount);
                        }).toList(),
                        TextButton(
                            onPressed: () async {
                              startIndex = endIndex;
                              endIndex = startIndex + 50;
                              await _expertProvider.updateChart(offset: startIndex, count: 50);
                              _chart = _expertProvider.chart;
                              setState(() {});
                            },
                            child: Text(S.of(context).show_more)),
                      ],
                    ),
                  )),
                  Container(
                    decoration: BoxDecoration(color: Theme.of(context).backgroundColor, boxShadow: [
                      BoxShadow(offset: Offset(0, -1), spreadRadius: 0, color: Colors.black.withOpacity(0.3)),
                    ]),
                    child: _getTile(context,
                        position: _expertProvider.expertTotal!.position,
                        photoUrl: _vkProvider.profile!.photo50,
                        fullname: '${_vkProvider.profile!.firstName} ${_vkProvider.profile!.lastName}',
                        topicName: _expertProvider.expertTotal!.topicName,
                        actionsCount: _expertProvider.expertTotal!.actionsCount),
                  )
                ],
              ),
            ),
          );
        });
  }
}

Widget _getTile(BuildContext context,
        {required int position,
        required String photoUrl,
        required String fullname,
        required String topicName,
        required int actionsCount}) =>
    Container(
      width: double.infinity,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$position'),
          SizedBox(
            width: 15,
          ),
          SizedBox(width: 50, height: 50, child: ClipOval(child: Image.network(photoUrl))),
          SizedBox(
            width: 15,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(fullname),
              Text(
                topicName,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          )),
          Text('$actionsCount'),
        ],
      ),
    );
