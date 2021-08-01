import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vk/generated/l10n.dart';
import 'package:vk/presentation/vk_icons.dart';
import 'package:vk_login/model/vk_scope.dart';
import 'package:vk_login/provider/vk_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VkProvider _vkProvider = Provider.of<VkProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).authorization),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          TextButton(
              onPressed: () {
                _vkProvider.login(context, permissions: [
                  VKScope.messages,
                  VKScope.groups,
                  VKScope.stats,
                  VKScope.wall,
                  VKScope.pages,
                  VKScope.offline
                ]);
              },
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(S.of(context).login_with),
                SizedBox(
                  width: 5,
                ),
                Icon(VKIcons.logo_vk_outline_28)
              ]))
        ],
      ),
    );
  }
}
