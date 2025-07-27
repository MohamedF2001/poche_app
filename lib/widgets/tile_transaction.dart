import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:poche/constants/app_theme.dart';
import 'package:poche/controllers/transaction_controller.dart';
import 'package:poche/models/transaction.dart';
import 'package:poche/screens/transaction/add_transaction.dart';
import 'package:poche/util.dart';

class TransactionTile extends StatefulWidget {
  const TransactionTile(
      {super.key,
      required this.transaction,
      required this.transactionController,
      this.enableSlide = true});
  final Transaction transaction;
  final TransactionController transactionController;
  final bool enableSlide;

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  final DateTime today = DateTime.now();

  final textColors = [Colors.green, Colors.red];

  @override
  void initState() {
    initializeDateFormatting('fr', null).then((_) {
      // Votre code principal ici
      //DateFormat('d MMM y, E').format(date);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: widget.enableSlide,
      key: ObjectKey(widget.transaction),
      endActionPane: ActionPane(
          extentRatio: 0.25,
          dragDismissible: true,
          motion: const DrawerMotion(),
          children: [
            /*  SlidableAction(
            onPressed: (ctx) {},
            backgroundColor:const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit),*/

            SlidableAction(
              flex: 1,
              autoClose: true,
              onPressed: (ctx) {
                final Transaction transactionCopy = Transaction(
                    date: widget.transaction.date,
                    category: widget.transaction.category,
                    amount: widget.transaction.amount,
                    type: widget.transaction.type);
                widget.transactionController
                    .deleteTransaction(widget.transaction);
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    backgroundColor: AppTheme.darkGray,
                    content: const Text('Transaction Supprimée'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          widget.transactionController
                              .addTransaction(transactionCopy);
                        }),
                  ));
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
            )
          ]),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border.symmetric(
                horizontal: BorderSide(color: Color(0x22000000), width: .5))),
        child: InkWell(
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddTransaction(
              transaction: widget.transaction,
            );
          })),
          onLongPress: () {
            if (widget.enableSlide) {
              Util.showSnackbar(
                  context, 'Glissez vers la gauche pour supprimer');
            }
          },
          child: Row(
            children: [
              TileDateView(widget.transaction.date),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.transaction.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (widget.transaction.description != null &&
                        widget.transaction.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          widget.transaction.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.darkGray),
                        ),
                      ),
                  ],
                ),
              ),
              Text('${widget.transaction.amount.toString()} F CFA',
                  style: TextStyle(
                      color: textColors[widget.transaction.type.index],
                      fontSize: 14,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}

class TileDateView extends StatelessWidget {
  final DateTime date;
  final DateTime today = DateTime.now();
  TileDateView(this.date, {super.key, required});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: getDateString(today) == getDateString(date)
          ? BoxDecoration(
              color: const Color(0x00E0E0E0),
              border: Border.all(width: .5),
              borderRadius: BorderRadius.circular(5))
          : BoxDecoration(
              color: const Color(0xfff0f0f0),
              borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.all(3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            date.day.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              //letterSpacing: 1,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            DateFormat('MMM', 'fr').format(date).toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  String getDateString(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}
