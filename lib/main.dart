import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poche/models/category.dart';
import 'package:poche/models/transaction.dart';
import 'package:poche/screens/onboard/on_board.dart';

Future main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  //await dotenv.load();
  //await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(CategoryAdapter());
  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<Category>('categories');
  await Hive.openBox('storage');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      theme: ThemeData(
        fontFamily: "Poppins",
        //primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.orange),
        floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.orange),
      ),
      debugShowCheckedModeBanner: false,
      home:
      //const WebViewExample(),
      const OnboardingScreen(),
      //const WebViewApp(),
      //const ChatScreen(),
    );
  }
}
