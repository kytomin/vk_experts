import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vk/generated/l10n.dart';
import 'package:vk/presentation/vk_icons.dart';
import 'package:vk/providers/expert_provider.dart';
import 'package:vk_login/provider/vk_provider.dart';

class ExpertCardPage extends StatelessWidget {
  late ExpertProvider _expertProvider;
  late VkProvider _vkProvider;

  @override
  Widget build(BuildContext context) {
    _expertProvider = Provider.of<ExpertProvider>(context);
    _vkProvider = Provider.of<VkProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).expert_card),
        ),
        body: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 120,
                width: 100,
                child: Stack(
                  children: [
                    ClipOval(child: Image.network(_vkProvider.profile!.photo100)),
                    Positioned(
                      top: 80,
                      child: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                                color: Colors.white,
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                  child: Row(
                                    children: [
                                      Icon(
                                        VKIcons.star_circle_12,
                                        size: 14,
                                        color: Colors.amber,
                                      ),
                                      Text(
                                        ' ${_expertProvider.rating}',
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${_vkProvider.profile!.firstName} ${_vkProvider.profile!.lastName}',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                _expertProvider.expertToday!.topicName,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                '${S.of(context).posts_rated_all_time}: ${_expertProvider.expertTotal!.actionsCount}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${S.of(context).posts_rated_today}: ${_expertProvider.expertToday!.actionsCount}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ));
  }
}
