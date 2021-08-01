import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vk/pages/home_page/home_page.dart';
import 'package:vk/pages/login_page.dart';
import 'package:vk_login/provider/vk_provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VkProvider _vkProvider = Provider.of<VkProvider>(context);

    if (_vkProvider.profile == null)
      return LoginPage();
    else
      return HomePage();
  }
}
