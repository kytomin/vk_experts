import 'package:flutter/material.dart';
import 'package:loading_alert_dialog/loading_alert_dialog.dart';

showLoading({required BuildContext context, required Function function }) async {
  await LoadingAlertDialog.showLoadingAlertDialog(
      context: context,
      builder: (context,) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 10,),
                Text("Loading..."),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
          ),
          color: Theme.of(context).backgroundColor,
        ),
      ),
      computation:Future( () => function())
  ).catchError((e) => throw e);
}