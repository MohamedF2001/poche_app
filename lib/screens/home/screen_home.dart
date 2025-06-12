import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:poche/constants/app_theme.dart';
import 'package:poche/controllers/category_controller.dart';
import 'package:poche/controllers/monthly_chart_controller.dart';
import 'package:poche/controllers/transaction_controller.dart';
import 'package:poche/controllers/yearly_chart_controller.dart';
import 'package:poche/screens/aa/gemi.dart';
import 'package:poche/screens/transaction/add_transaction.dart';
import 'package:poche/screens/transaction/screen_transactions.dart';
import 'package:poche/widgets/filter_bar.dart';
import 'package:poche/widgets/menu_widget.dart';
import 'package:poche/widgets/search_transaction.dart';
import 'package:poche/widgets/tile_transaction.dart';
import '../../models/transaction.dart';
import '../../widgets/empty_view.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final transactionController = Get.put(TransactionController());
  final cateoryController = Get.put(CategoryController());
  final chartController = Get.put(MonthlyChartContollrt());
  final ychartController = Get.put(YearlyChartContoller());
  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;

  final textColor = const Color(0xff324149);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    transactionController.clearFilter();
    super.dispose();
  }

  @override
  Widget build(BuildContext mContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Bienvenue ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const MenuWidget(),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: TransactionSearchDelegate(),
              );
            },
            tooltip: 'Chercher',
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ChatScreen();
                    },
                  ),
                );
              },
              child: Image.asset(
                "assets/images/iaa.png",
                width: 30,
                height: 30,
              ),
            ),
          )
        ],
      ),
      backgroundColor: const Color(0xFFF3f3f3),
      floatingActionButton: /* SpeedDial(
        icon: Icons.add,
        backgroundColor: Colors.orange,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.blue.shade200,
            child: Image.asset(
              "assets/images/iaa.png",
              width: 30,
              height: 30,
            ),
            label: 'Assistant IA',
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ChatScreen();
                  },
                ),
              );
            },
          ),
          SpeedDialChild(
            foregroundColor: Colors.black,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.add),
            label: 'Nouvelle Transaction',
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AddTransaction();
                  },
                ),
              );
            },
          ),
        ],
      ), */

          FloatingActionButton(
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return
                    //ChatPage();
                    //const ChatScreen();
                    const AddTransaction();
              },
            ),
          );
        },
        tooltip: 'Nouvelle Transaction',
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: GetBuilder<TransactionController>(
        builder: (controller) {
          calculateBalances(controller.filterdList);
          return ListView(
            children: [
              const FilterBarv(),
              const SizedBox(height: 25),
              _buildBalanceWidget(textColor),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Opérations récentes',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const TransactionsScreen()));
                      },
                      child: Text(
                        'Voir tout',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                child: controller.filterdList.isEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: const EmptyView(
                            icon: Icons.receipt_long,
                            label: 'Aucune opérations '),
                      )
                    : SlidableAutoCloseBehavior(
                        closeWhenOpened: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.filterdList.length < 5
                              ? controller.filterdList.length
                              : 5,
                          itemBuilder: (context, index) {
                            Transaction currItem =
                                controller.filterdList[index];
                            return TransactionTile(
                                transaction: currItem,
                                transactionController: transactionController);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  //conteneur de la balance
  Container _buildBalanceWidget(Color textColor) {
    return Container(
      width: double.infinity,
      height: 195,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: Colors.orange.shade100,
          boxShadow: const [
            BoxShadow(blurRadius: 5, color: Color.fromARGB(65, 0, 0, 0))
          ],
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Solde Total',
                      style: TextStyle(
                          color: AppTheme.darkGray,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      "assets/images/walet.png",
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '$totalBalance F CFA',
                  /* '\u{20B9} $totalBalance', */
                  style: const TextStyle(
                      fontSize: 20,
                      color: AppTheme.darkGray,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      //border: Border.all(width: 5, color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [
                            0.1,
                            0.8,
                            0.95
                          ],
                          colors: [
                            Color(0x0027FF2E),
                            Color(0x3227FF2E),
                            Color(0x8827FF2E),
                            //Colors.green,
                          ]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/revenues.png",
                                width: 20,
                                height: 20,
                              ),
                              /* const Icon(
                                Icons.arrow_downward,
                                color: AppTheme.darkGray,
                                size: 18,
                              ), */
                              const SizedBox(width: 10),
                              const Text('Revenus',
                                  style: TextStyle(
                                      color: AppTheme.darkGray,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '$totalBalance F CFA',
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                                //color: Color(0xff4EAE51),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [
                            0.1,
                            .8,
                            .95
                          ],
                          colors: [
                            Color(0x00FF6969),
                            Color(0x32FF6969),
                            Color(0x88FF6969)
                          ]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/depenses.png",
                                width: 20,
                                height: 20,
                              ),
                              /* Icon(
                                Icons.arrow_upward,
                                color: AppTheme.darkGray,
                                size: 18,
                              ), */
                              const SizedBox(width: 10),
                              const Text('Dépenses',
                                  style: TextStyle(
                                      color: AppTheme.darkGray,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '$totalExpense F CFA',
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                                //color: Color(0xffFF5F5F),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  //conteneur de la balance

  ////////////////////////////////
  /* calculateBalances(List<Transaction> tarnsactions) {
    totalBalance = 0;
    totalExpense = 0;
    totalIncome = 0;
    for (Transaction transaction in tarnsactions) {
      if (transaction.type == TransactionType.income) {
        totalBalance += transaction.amount;
        totalIncome += transaction.amount;
      } else {
        totalBalance -= transaction.amount;
        totalExpense += transaction.amount;
      }
    }
  } */
  calculateBalances(List<Transaction> transactions) {
    totalBalance = 0;
    totalExpense = 0;
    totalIncome = 0;
    for (Transaction transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        totalBalance += transaction.amount; // Ajoute le montant au solde total
        totalIncome +=
            transaction.amount; // Ajoute le montant au total des revenus
      } else {
        totalBalance -=
            transaction.amount; // Soustrait le montant du solde total
        totalExpense +=
            transaction.amount; // Ajoute le montant au total des dépenses
      }
    }
  }

  //-----------------------------
}
