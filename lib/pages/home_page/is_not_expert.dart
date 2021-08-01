import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vk/generated/l10n.dart';
import 'package:vk_login/provider/vk_provider.dart';

class IsNotExpertPage extends StatelessWidget {
  late VkProvider _vkProvider;

  @override
  Widget build(BuildContext context) {
    _vkProvider = Provider.of<VkProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
                width: 40,
                height: 40,
                child: ClipOval(
                  child: Image.network(_vkProvider.profile!.photo50),
                )),
            SizedBox(
              width: 10,
            ),
            Text(
              '${_vkProvider.profile!.firstName} ${_vkProvider.profile!.lastName}',
              style: Theme.of(context).textTheme.headline6,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                _vkProvider.logout();
              },
              icon: Icon(Icons.exit_to_app_outlined))
        ],
      ),
      body: Center(
        child: Text(
          S.of(context).you_are_not_expert,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}
