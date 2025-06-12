import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poche/controllers/yearly_chart_controller.dart';
import 'package:poche/screens/statistics/monthly_chart.dart';
import 'package:poche/widgets/period_bar.dart';

class YearlyChart extends StatefulWidget {
  const YearlyChart({Key? key}) : super(key: key);

  @override
  State<YearlyChart> createState() => _YearlyChartState();
}

class _YearlyChartState extends State<YearlyChart> {
  final YearlyChartContoller chartController = Get.find();
  String period = '';
  int filterType = 0;

  @override
  void initState() {
    super.initState();
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
            child: GetBuilder<YearlyChartContoller>(
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

/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poche/controllers/yearly_chart_controller.dart';
import 'package:poche/models/chart_data_model.dart';
import 'package:poche/widgets/period_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class YearlyChart extends StatefulWidget {
  const YearlyChart({Key? key}) : super(key: key);

  @override
  State<YearlyChart> createState() => _YearlyChartState();
}

class _YearlyChartState extends State<YearlyChart> {
  final YearlyChartContoller chartController = Get.find();
  String period = '';
  int filterType = 0;

  @override
  void initState() {
    super.initState();
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
          child: GetBuilder<YearlyChartContoller>(
            builder: (controller) {
              return BarChartView(
                controller: controller,
              );
            },
          ),
        )
      ],
    );
  }
}

class BarChartView extends StatelessWidget {
  const BarChartView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final YearlyChartContoller controller;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        BarSeries<CatChartData, String>(
          dataSource: controller.displyDataList,
          xValueMapper: (CatChartData data, _) => data.category,
          yValueMapper: (CatChartData data, _) => data.toatal,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
} */

/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poche/controllers/yearly_chart_controller.dart';
import 'package:poche/models/chart_data_model.dart';
import 'package:poche/widgets/period_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class YearlyChart extends StatefulWidget {
  const YearlyChart({Key? key}) : super(key: key);

  @override
  State<YearlyChart> createState() => _YearlyChartState();
}

class _YearlyChartState extends State<YearlyChart> {
  final YearlyChartContoller chartController = Get.find();
  String period = '';
  int filterType = 0;

  @override
  void initState() {
    super.initState();
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
          child: GetBuilder<YearlyChartContoller>(
            builder: (controller) {
              return LineChartView(
                controller: controller,
              );
            },
          ),
        )
      ],
    );
  }
}

class LineChartView extends StatelessWidget {
  const LineChartView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final YearlyChartContoller controller;

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

