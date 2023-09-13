import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Helper/constant.dart';

dialogAnimate(BuildContext context, Widget dialge) {
  return showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(opacity: a1.value, child: dialge),
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
    barrierDismissible: false,
    barrierLabel: 'test',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
  );
}

showAppUpdateDialog(BuildContext context) async {
  await dialogAnimate(
    context,
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setStater) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          title: const Text("Update App"),
          content: Text(
            'Update is available, please update app to the latest version!',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.amber,
                  fontFamily: 'ubuntu',
                ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'No',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ubuntu',
                    ),
              ),
              onPressed: () => exit(0),
            ),
            TextButton(
              child: Text(
                'Update Now',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ubuntu',
                    ),
              ),
              onPressed: () async {
                String url = '';
                if (Platform.isAndroid) {
                  url = androidLink;
                } else if (Platform.isIOS) {
                  url = iosLink;
                }

                if (await canLaunchUrl(
                  Uri.parse(url),
                )) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            )
          ],
        );
      },
    ),
  );
}
