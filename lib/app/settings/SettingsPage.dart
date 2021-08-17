import 'package:flutter/material.dart';
import 'package:totem/components/widgets/Button.dart';
import 'package:totem/components/widgets/Header.dart';
import 'package:totem/app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black,
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              TotemHeader(text: 'Settings'),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TotemButton(
                  icon: Icons.logout,
                  buttonText: 'Sign Out',
                  onButtonPressed: (stop) async {
                    await context.read(firebaseAuthProvider).signOut();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
