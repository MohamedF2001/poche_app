import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poche/controllers/transaction_controller.dart';

class FilterBarv extends StatefulWidget {
  const FilterBarv({
    Key? key,
  }) : super(key: key);

  @override
  State<FilterBarv> createState() => _FilterBarvState();
}

class _FilterBarvState extends State<FilterBarv> {
  final List<String> items = [
    'Tout',
    'Aujourd hui',
    'Hier',
    'Cette semaine',
    'Ce mois',
    'Personnalisé'
  ];
  int selFilterIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setFilter(items[index]);
                    setState(() {
                      selFilterIndex = index;
                    });
                  },
                  child: Card(
                    color: selFilterIndex == index
                        ? const Color(0xFFF3f3f3)
                        : Colors.white,
                    margin: selFilterIndex == index
                        ? const EdgeInsets.only(top: 10)
                        : const EdgeInsets.only(bottom: 5),
                    shape: const RoundedRectangleBorder(),
                    elevation: selFilterIndex == index ? 0 : 2,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 100),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          items[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: selFilterIndex == index
                                ? Colors.black
                                : const Color(0x77000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  setFilter(var selction) async {
    final TransactionController controller = Get.find();
    final DateTime now = DateTime.now();
    switch (selction) {
      case 'Tout':
        controller.clearFilter();
        break;
      case 'Aujourd hui':
        DateTime start = DateTime(now.year, now.month, now.day);
        DateTime end = start.add(const Duration(days: 1));
        controller.setFilter(start, end);
        break;
      case 'Hier':
        DateTime start = DateTime(now.year, now.month, now.day - 1);
        DateTime end = start.add(const Duration(days: 1));
        controller.setFilter(start, end);
        break;
      case 'Cette semaine':
        DateTime start = DateTime(now.year, now.month, now.day - 6);
        DateTime end = DateTime(start.year, start.month, start.day + 7);
        controller.setFilter(start, end);
        break;
      case 'Ce mois':
        DateTime start = DateTime(now.year, now.month, 1);
        DateTime end = DateTime(start.year, start.month + 1, start.day);
        controller.setFilter(start, end);
        break;

      case 'Personalisé':
        DateTimeRange? picked = await showDateRangePicker(
            context: context,
            saveText: 'APPLY',
            firstDate: DateTime(2000),
            lastDate: DateTime(2101));
        if (picked != null) {
          controller.setFilter(
              picked.start, picked.end.add(const Duration(days: 1)));
        }

        break;
      default:
        break;
    }
  }
}
