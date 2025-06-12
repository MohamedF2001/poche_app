import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:poche/controllers/chart_controller.dart';
import 'package:poche/controllers/monthly_chart_controller.dart';
import 'package:poche/models/chart_data_model.dart';
import 'package:poche/widgets/empty_view.dart';
import 'package:poche/widgets/period_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonthlyChart extends StatefulWidget {
  const MonthlyChart({Key? key}) : super(key: key);

  @override
  State<MonthlyChart> createState() => _MonthlyChartState();
}

class _MonthlyChartState extends State<MonthlyChart> {
  final MonthlyChartContollrt chartController = Get.find();
  String period = '';
  int filterType = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr', null).then((_) {
    // Votre code principal ici
          //DateFormat('d MMM y, E').format(date);
  });
  }

  @override
  Widget build(BuildContext context) {
    period = chartController.getPeriod();
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: PeriodBar(
            title: period,
            onPrevPress: () {
              chartController.prev();
              setState(() {
                period = chartController.getPeriod();
              });
            },
            onNextPress: () {
              chartController.next();
              setState(() {
                period = chartController.getPeriod();
              });
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: GetBuilder<MonthlyChartContollrt>(
              builder: (controller) {
                return PieChartView(
                  controller: controller,
                );
              },
            ))
      ],
    );
  }
}

class PieChartView extends StatelessWidget {
  const PieChartView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ChartController controller;
  final List<String> filterTypes = const [
    'Dépenses',
    'Revenus',
    "Vue d'ensemble"
  ];
  final List<Color> overviewPalte = const [
    Color(0xff4EAE51),
    Color(0xffFF5F5F)
  ];
  final List<Color> palette = const <Color>[
    Color.fromRGBO(75, 135, 185, 1),
    Color.fromRGBO(192, 108, 132, 1),
    Color.fromRGBO(246, 114, 128, 1),
    Color.fromARGB(255, 245, 156, 120),
    Color.fromRGBO(116, 180, 155, 1),
    Color.fromRGBO(0, 168, 181, 1),
    Color.fromRGBO(73, 76, 162, 1),
    Color.fromARGB(255, 255, 185, 32),
    Color.fromARGB(255, 91, 255, 41),
    Color.fromRGBO(104, 255, 205, 1)
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: List<Widget>.generate(
            3,
            (int index) {
              return ChoiceChip(
                label: Text(filterTypes[index]),
                labelStyle: const TextStyle(fontSize: 13),
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                selected: controller.currTypeFilter == index,
                onSelected: (bool selected) {
                  controller.setTypeFiler(index);
                },
                backgroundColor: Colors.grey.shade200,
                selectedColor: Colors.orangeAccent,
                shape: StadiumBorder(
                    side: BorderSide(
                        width: 0.5,
                        color: controller.currTypeFilter == index
                            ? Colors.orange
                            : Colors.grey)),
              );
            },
          ).toList(),
        ),
        controller.displyDataList.isNotEmpty
            ? SfCircularChart(
                legend: const Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                  position: LegendPosition.bottom,
                ),
                palette:
                    controller.currTypeFilter == 2 ? overviewPalte : palette,
                tooltipBehavior: TooltipBehavior(
                    enable: true,
                    borderColor: Colors.black,
                    borderWidth: 1,
                    format: 'point.x: point.y F CFA'), //////
                series: <CircularSeries>[
                  PieSeries<CatChartData, String>(
                    animationDuration: 700,
                    dataSource: controller.displyDataList,
                    explode: true,
                    explodeGesture: ActivationMode.singleTap,
                    xValueMapper: (CatChartData data, _) => data.category,
                    yValueMapper: (CatChartData data, _) => data.toatal,
                    dataLabelMapper: (CatChartData data, _) => data.category,
                    sortingOrder: SortingOrder.descending,
                    legendIconType: LegendIconType.circle,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      connectorLineSettings:
                          ConnectorLineSettings(type: ConnectorType.curve),
                      overflowMode: OverflowMode.shift,
                      showZeroValue: false,
                      labelPosition: ChartDataLabelPosition.outside,
                    ),
                  )
                ],
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: const EmptyView(
                  icon: Icons.bar_chart,
                  label: 'Aucune donnée trouvée',
                  color: Color.fromARGB(249, 26, 93, 148),
                ),
              ),
      ],
    );
  }
} 

/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:poche/controllers/chart_controller.dart';
import 'package:poche/controllers/monthly_chart_controller.dart';
import 'package:poche/models/chart_data_model.dart';
import 'package:poche/widgets/empty_view.dart';
import 'package:poche/widgets/period_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonthlyChart extends StatefulWidget {
  const MonthlyChart({Key? key}) : super(key: key);

  @override
  State<MonthlyChart> createState() => _MonthlyChartState();
}

class _MonthlyChartState extends State<MonthlyChart> {
  final MonthlyChartContollrt chartController = Get.find();
  String period = '';
  int filterType = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr', null).then((_) {
    // Votre code principal ici
          //DateFormat('d MMM y, E').format(date);
  });
  }

  @override
  Widget build(BuildContext context) {
    period = chartController.getPeriod();
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: PeriodBar(
            title: period,
            onPrevPress: () {
              chartController.prev();
              setState(() {
                period = chartController.getPeriod();
              });
            },
            onNextPress: () {
              chartController.next();
              setState(() {
                period = chartController.getPeriod();
              });
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: GetBuilder<MonthlyChartContollrt>(
              builder: (controller) {
                return BarChartView(
                  controller: controller,
                );
              },
            ))
      ],
    );
  }
}

class BarChartView extends StatelessWidget {
  const BarChartView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ChartController controller;
  final List<String> filterTypes = const [
    'Dépenses',
    'Revenus',
    "Vue d'ensemble"
  ];
  final List<Color> overviewPalte = const [
    Color(0xff4EAE51),
    Color(0xffFF5F5F)
  ];
  final List<Color> palette = const <Color>[
    Color.fromRGBO(75, 135, 185, 1),
    Color.fromRGBO(192, 108, 132, 1),
    Color.fromRGBO(246, 114, 128, 1),
    Color.fromARGB(255, 245, 156, 120),
    Color.fromRGBO(116, 180, 155, 1),
    Color.fromRGBO(0, 168, 181, 1),
    Color.fromRGBO(73, 76, 162, 1),
    Color.fromARGB(255, 255, 185, 32),
    Color.fromARGB(255, 91, 255, 41),
    Color.fromRGBO(104, 255, 205, 1)
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: List<Widget>.generate(
            3,
            (int index) {
              return ChoiceChip(
                label: Text(filterTypes[index]),
                labelStyle: const TextStyle(fontSize: 13),
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                selected: controller.currTypeFilter == index,
                onSelected: (bool selected) {
                  controller.setTypeFiler(index);
                },
                backgroundColor: Colors.grey.shade200,
                selectedColor: const Color(0xffc8e2f8),
                shape: StadiumBorder(
                    side: BorderSide(
                        width: 0.5,
                        color: controller.currTypeFilter == index
                            ? Colors.blue
                            : Colors.grey)),
              );
            },
          ).toList(),
        ),
        controller.displyDataList.isNotEmpty
            ? SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: _buildSeries(controller),
                tooltipBehavior: TooltipBehavior(
                    enable: true,
                    borderColor: Colors.black,
                    borderWidth: 1,
                    format: 'point.x: \u{20B9}point.y F CFA'),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: const EmptyView(
                  icon: Icons.bar_chart,
                  label: 'Aucune donnée trouvée',
                  color: Color.fromARGB(249, 26, 93, 148),
                ),
              ),
      ],
    );
  }

  List<ChartSeries<CatChartData, String>> _buildSeries(ChartController controller) {
    return [
      BarSeries<CatChartData, String>(
        dataSource: controller.displyDataList,
        xValueMapper: (CatChartData data, _) => data.category,
        yValueMapper: (CatChartData data, _) => data.toatal,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    ];
  }
}

 */


/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:poche/controllers/monthly_chart_controller.dart';
import 'package:poche/models/chart_data_model.dart';
import 'package:poche/widgets/period_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonthlyChart extends StatefulWidget {
  const MonthlyChart({Key? key}) : super(key: key);

  @override
  State<MonthlyChart> createState() => _MonthlyChartState();
}

class _MonthlyChartState extends State<MonthlyChart> {
  final MonthlyChartContollrt chartController = Get.find();
  String period = '';
  int filterType = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr', null).then((_) {
    // Votre code principal ici
          //DateFormat('d MMM y, E').format(date);
  });
  }

  @override
  Widget build(BuildContext context) {
    period = chartController.getPeriod();
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: PeriodBar(
            title: period,
            onPrevPress: () {
              chartController.prev();
              setState(() {
                period = chartController.getPeriod();
              });
            },
            onNextPress: () {
              chartController.next();
              setState(() {
                period = chartController.getPeriod();
              });
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: GetBuilder<MonthlyChartContollrt>(
              builder: (controller) {
                return LineChartView(
                  controller: controller,
                );
              },
            ))
      ],
    );
  }
}

class LineChartView extends StatelessWidget {
  const LineChartView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final MonthlyChartContollrt controller;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        LineSeries<CatChartData, String>(
          dataSource: controller.displyDataList,
          xValueMapper: (CatChartData data, _) => data.category,
          yValueMapper: (CatChartData data, _) => data.toatal,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
} */


