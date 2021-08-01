import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vk/pages/expert_card_page.dart';
import 'package:vk/presentation/vk_icons.dart';
import 'package:vk/providers/expert_provider.dart';
import 'package:vk_login/provider/vk_provider.dart';

class CustomDrawer extends StatelessWidget {
  late VkProvider _vkProvider;
  late ExpertProvider _expertProvider;

  @override
  Widget build(BuildContext context) {
    _vkProvider = Provider.of<VkProvider>(context);
    _expertProvider = Provider.of<ExpertProvider>(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          _createDrawerHeader(
              context: context,
              image: NetworkImage(_vkProvider.profile!.photo100),
              fullname: '${_vkProvider.profile!.firstName} ${_vkProvider.profile!.lastName}',
              thematic: '${_expertProvider.expertToday!.topicName}'),
          _createDrawerItem(
              icon: VKIcons.cards_2_outline_28,
              text: 'Карточка эксперта',
              context: context,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ExpertCardPage()))),
          _createDrawerItem(icon: VKIcons.stars_3_outline_56, text: 'Рейтинг', context: context),
          _createDrawerItem(icon: VKIcons.settings_28, text: 'Настройки', context: context),
          _createDrawerItem(icon: VKIcons.question_outline_20, text: 'Сообщить о ошибке', context: context),
          _createDrawerItem(icon: VKIcons.rouble_circle_fill_blue_20, text: 'Задонатить', context: context),
          _createDrawerItem(
              onTap: () {
                _vkProvider.logout();
              },
              icon: Icons.exit_to_app_outlined,
              text: 'Выйти',
              context: context),
        ],
      ),
    );
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
              onPressed: () {},
              icon: Icon(
                Icons.wb_sunny_outlined,
                color: Colors.white,
              )),
        ],
      ));
}
