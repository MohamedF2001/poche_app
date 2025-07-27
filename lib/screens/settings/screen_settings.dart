import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poche/constants/strings.dart';
import 'package:poche/controllers/transaction_controller.dart';
import 'package:poche/database/boxes.dart';
import 'package:poche/models/category.dart';
import 'package:poche/models/transaction.dart';
import 'package:poche/screens/settings/edit_profile.dart';
import 'package:poche/screens/splashscreen.dart';
import 'package:poche/util.dart';
import 'package:poche/widgets/menu_widget.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextStyle secTitleStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontSize: 20,
  );
  late SharedPreferences prefs;
  bool isNotifiyDaily = false;
  bool isApplockEnable = false;
  TimeOfDay? pickedTime;
  String userName = '';
  String imageString = '';
  late Box box;
  //late NotificationService notificationService;

  @override
  void initState() {
    box = Boxes.getStorageBox();
    readSettings();
    //notificationService = NotificationService();
    super.initState();
  }

  readSettings() async {
    prefs = await SharedPreferences.getInstance();
    final int hour = prefs.getInt(Strings.reminderHour) ?? 21; //dafult 9:00 PM
    final int minute = prefs.getInt(Strings.reminderMin) ?? 0;

    setState(() {
      isApplockEnable = prefs.getBool(Strings.applockEnable) ?? false;
      isNotifiyDaily = prefs.getBool(Strings.notifyDaily) ?? false;
      userName = box.get('userName', defaultValue: '');
      imageString = box.get('profilePhoto', defaultValue: '');
      pickedTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const MenuWidget(),
        title: const Text(
          'Paramètres',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SettingsList(
        contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        platform: DevicePlatform.web,
        lightTheme: const SettingsThemeData(
          leadingIconsColor: Colors.black,
          titleTextColor: Colors.black,
          trailingTextColor: Colors.black,
        ),
        sections: [
          SettingsSection(
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              tiles: [
                CustomSettingsTile(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EditProfile()))
                            .whenComplete(() {
                          setState(() {
                            userName = box.get('userName', defaultValue: '');
                            imageString =
                                box.get('profilePhoto', defaultValue: '');
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Builder(builder: (context) {
                          return Row(
                            children: [
                              CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      Util.getAvatharImage(imageString)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  userName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                )),
              ]),
          /* SettingsSection(
                title: Text(
                  'Security',
                  style: secTitleStyle,
                ),
                tiles: [
                  SettingsTile.switchTile(
                      initialValue: isApplockEnable,
                      activeSwitchColor: Colors.blue,
                      onToggle: (val) async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PasscodeScreen()));
                        setState(() {
                          isApplockEnable = val;
                        });
                        await prefs.setBool(Strings.applockEnable, val);
                      },
                      title: const Text('Applock'),
                      leading: const Icon(Icons.lock)),
                  SettingsVisibility(
                    visibe: isApplockEnable,
                    child: SettingsTile(
                      title: Text(
                        'Change Password',
                        style: TextStyle(
                            color:
                                isApplockEnable ? Colors.black : Colors.grey),
                      ),
                      leading: const Icon(Icons.key),
                      enabled: isApplockEnable,
                      onPressed: (context) {},
                    ),
                  ),
                ]),*/

          /*
            SettingsSection(
              title: Text(
                'Notification',
                style: secTitleStyle,
              ),
              tiles: [
                SettingsTile.switchTile(
                  initialValue: isNotifiyDaily,
                  activeSwitchColor: Colors.blue,
                  onToggle: (enable) async {
                    if (enable) {
                      enableNotification();
                    } else {
                      notificationService.cancelNotification(1);
                    }
                    setState(() {
                      isNotifiyDaily = enable;
                    });
                    await prefs.setBool(Strings.notifyDaily, enable);
                  },
                  title: const Text('Daily Reminder'),
                  leading: const Icon(Icons.notifications_outlined),
                ),
                SettingsTile(
                  title: Text(
                    'Notification Time',
                    style: TextStyle(
                        color: isNotifiyDaily ? Colors.black : Colors.grey),
                  ),
                  leading: Icon(Icons.alarm,
                      color: isNotifiyDaily ? Colors.blue : Colors.grey),
                  enabled: isNotifiyDaily,
                  onPressed: (context) {
                    pickTime(context);
                  },
                  value: Text(
                      pickedTime != null ? pickedTime!.format(context) : '',
                      style: TextStyle(
                          color: isNotifiyDaily ? Colors.blue : Colors.grey,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),*/

          SettingsSection(
            title: const Text('Autres',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                )),
            tiles: [
              SettingsTile(
                  title: const Text('Rénitialiser les données'),
                  leading: const Icon(Icons.restore),
                  onPressed: (context) {
                    confirmReset(context);
                  }),
              SettingsTile(
                title: const Text('Feedback'),
                leading: const Icon(Icons.feedback_outlined),
                onPressed: (context) {
                  feedback();
                },
              ),
              SettingsTile(
                title: const Text('A propos'),
                leading: const Icon(Icons.info_outline),
                onPressed: (context) {
                  showAboutDialog(
                    context: context,
                    applicationIcon: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child:
                            Image.asset('assets/images/mony.jpg', width: 50)),
                    applicationName: 'Mony',
                    applicationVersion: 'version 1.0.1',
                    children: <Widget>[
                      //const Text('Developée par Ihsan Kottupadam')
                      const Text('Developée par Mohamed Farid')
                    ],
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Future<dynamic> confirmReset(BuildContext ctx) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention'),
              content: const Text(
                "Cela supprimera définitivement les données de l'application, y compris vos transactions et vos préférences",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Non')),
                TextButton(
                    onPressed: () {
                      resetData(ctx);
                    },
                    child: const Text('Oui'))
              ],
            ));
  }

  pickTime(BuildContext context) async {
    TimeOfDay? pickedT = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        helpText: 'SELECT REMINDER TIME');

    if (pickedT != null) {
      setState(() {
        pickedTime = pickedT;
      });
      prefs.setInt(Strings.reminderHour, pickedT.hour);
      prefs.setInt(Strings.reminderMin, pickedT.minute);
      //enableNotification();
    }
  }

  /* enableNotification() {
    notificationService.showNotificationDaily(
        id: 1,
        title: 'Money Manager',
        body: 'Have you recorded your transactions today?',
        scheduleTime: pickedTime!);
  } */

  resetData(ctx) {
    Hive.box<Transaction>('transactions').clear();
    Hive.box<Category>('categories').clear();
    TransactionController transactionController = Get.find();
    transactionController.filterdList.clear();
    prefs.clear();
    Navigator.pushAndRemoveUntil(
        ctx,
        MaterialPageRoute(
          builder: (ctx) => const SplashScreen(),
        ),
        (route) => false);
  }

  feedback() async {
    final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        //path: 'ihsanpv007@gmail.com',
        path: 'frdmoussiliou@gmail.com',
        query: 'subject=Feedback a propros de Money Manager app&body=');

    if (!await launchUrl(emailLaunchUri)) {
      throw '';
    }
  }
}

class SettingsVisibility extends AbstractSettingsTile {
  final bool visibe;
  final Widget child;
  const SettingsVisibility(
      {super.key, required this.visibe, required this.child});
  @override
  Widget build(BuildContext context) {
    return Visibility(visible: visibe, child: child);
  }
}
