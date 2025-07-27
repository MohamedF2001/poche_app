import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: 'Menu',
        onPressed: () {
          DrawerScaffold.currentController(context).toggle();
        },
        icon: const Icon(
          Icons.menu,
          color: Colors.black,
        ));
  }
}
