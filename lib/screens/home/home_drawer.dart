import 'package:flutter/material.dart';
import 'package:drawerbehavior/drawerbehavior.dart' as drawer;
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poche/constants/app_theme.dart';
import 'package:poche/database/boxes.dart';
import 'package:poche/screens/category/screen_categories.dart';
import 'package:poche/screens/home/screen_home.dart';
import 'package:poche/screens/settings/screen_settings.dart';
import 'package:poche/screens/statistics/screen_statistics.dart';
import 'package:poche/util.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);
  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  late String selectedMenuItemId;

  final menu = drawer.Menu(
    items: [
      drawer.MenuItem(
        id: 'accueil',
        icon: Icons.home,
        title: 'Accueil',
        prefix: null,
        suffix: null,
        textStyle: const TextStyle(fontSize: 17),
      ),
      drawer.MenuItem(
        id: 'catégories',
        icon: Icons.category,
        title: 'Catégories',
        prefix: null,
        //Icon(Icons.bar_chart),
        // Ensure that either prefix or icon is set and the other is null
        suffix: null,
        textStyle: const TextStyle(fontSize: 17),
      ),
      drawer.MenuItem(
        id: 'statuesque',
        icon: Icons.bar_chart,
        title: 'Statistiques',
        prefix: null,
        //Icon(Icons.bar_chart),
        // Ensure that either prefix or icon is set and the other is null
        suffix: null,
        textStyle: const TextStyle(fontSize: 17),
      ),
      drawer.MenuItem(
        id: 'paramètres',
        icon: Icons.settings,
        title: 'Paramètres',
        prefix: null,
        //Icon(Icons.bar_chart),
        // Ensure that either prefix or icon is set and the other is null
        suffix: null,
        textStyle: const TextStyle(fontSize: 17),
      ),
    ],
  );

  @override
  void initState() {
    selectedMenuItemId = menu.items[0].id!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return drawer.DrawerScaffold(
      drawers: [
        drawer.SideDrawer(
            percentage: 1,
            menu: menu,
            headerView: const HeaderView(),
            cornerRadius: 0,
            elevation: 15,
            selectorColor: Colors.transparent,
            animation: false,
            alignment: Alignment.topLeft,
            color: const Color(0xffE9E9E9),
            selectedItemId: selectedMenuItemId,
            onMenuItemSelected: (itemId) {
              setState(() {
                selectedMenuItemId = itemId;
              });
            },
            itemBuilder: (BuildContext context, menuItem, bool isSelected) {
              return Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 70, 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.orange.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(50))),
                child: Row(children: [
                  Icon(
                    menuItem.icon,
                    color: isSelected ? Colors.orange : Colors.black,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    menuItem.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isSelected ? Colors.orange : Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              );
            })
      ],
      builder: (context, id) =>
          DrawerScreen(screen: getScreen(selectedMenuItemId)),
    );
  }

  Widget getScreen(String currentItemId) {
    switch (currentItemId) {
      case 'accueil':
        return const ScreenHome();
      /* case 'journal':
        return DiaryPage(date: DateTime.now()); */
      case 'catégories':
        return const ScreenCategories();
      case 'statistiques':
        return const ScreenStatistics();
      case 'paramètres':
        return const SettingsScreen();
      default:
        return const ScreenStatistics();
    }
  }
}

class HeaderView extends StatefulWidget {
  const HeaderView({Key? key}) : super(key: key);

  @override
  State<HeaderView> createState() => _HeaderViewState();
}

class _HeaderViewState extends State<HeaderView> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Boxes.getStorageBox().listenable(),
      builder: (context, Box box, _) {
        final String imageString = box.get('profilePhoto', defaultValue: '');
        final String userName = box.get('userName', defaultValue: '');
        return Column(
          children: [
            Row(
              children: [
                const Spacer(flex: 1),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.black,
                                spreadRadius: 0)
                          ],
                        ),
                        child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                Util.getAvatharImage(imageString))),
                    const SizedBox(height: 20),
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppTheme.darkGray,
                          fontWeight: FontWeight.bold,
                          fontSize: 19),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                const Spacer(flex: 3)
              ],
            ),
            const Divider(thickness: 1)
          ],
        );
      },
    );
  }
}

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key, required this.screen}) : super(key: key);
  final Widget screen;
  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool isDrawerOpen = false;
  @override
  void initState() {
    drawer.DrawerScaffold.currentController(context);
    drawer.DrawerScaffold.currentController(context).addListener(() {
      setState(() {
        isDrawerOpen =
            drawer.DrawerScaffold.currentController(context).isOpen();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Quitte l'application quand on appuie sur le bouton retour
          SystemNavigator.pop();
          return false; // Empêche le comportement par défaut
        },
        child: AbsorbPointer(absorbing: isDrawerOpen, child: widget.screen));
  }
}
