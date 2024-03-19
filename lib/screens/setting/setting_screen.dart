import 'package:flutter/material.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/imports.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Setting'),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          ListTile(
            title: const Text("Delete User"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: const Text('Delete User'),
                  content:
                      const Text('Are you sure you want to delete this user?'),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      child: const Text('Cancel',
                          style: TextStyle(color: MyColors.primaryColor)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        // Put your delete logic here
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: const Text("About"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (BuildContext context) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CupertinoPopupSurface(
                    child: CupertinoAlertDialog(
                      title: const Text('About'),
                      content: const Text(
                          'This App helps in learning Dutch language to students.'),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          child: const Text('Close',
                              style: TextStyle(color: MyColors.primaryColor)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      )),
    ));
  }
}
