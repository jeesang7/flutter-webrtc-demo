import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/model/carebox.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'bloc/carebox_bloc.dart';

class AdminPage extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<AdminPage> {
  late Carebox carebox;

  @override
  void initState() {
    super.initState();
    bloc.fetchStatus();
    _startTimer(false);
  }

  @override
  void deactivate() {
    _startTimer(true);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('관리자')),
        body: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  Container(
                    child: Text(
                      "현재 혈압",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2!,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    "최고",
                    style: Theme.of(context).textTheme.headline3!,
                  ),
                  StreamBuilder(
                      stream: bloc.status,
                      builder: (context, AsyncSnapshot<Carebox> snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!.systolic,
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontWeight: FontWeight.bold),
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    "최저",
                    style: Theme.of(context).textTheme.headline3!,
                  ),
                  StreamBuilder(
                      stream: bloc.status,
                      builder: (context, AsyncSnapshot<Carebox> snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!.diastolic,
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontWeight: FontWeight.bold),
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  StreamBuilder(
                      stream: bloc.status,
                      builder: (context, AsyncSnapshot<Carebox> snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data!.result) {
                            case "normal":
                              return Container(
                                // margin: const EdgeInsets.all(30.0),
                                padding:
                                    const EdgeInsets.fromLTRB(50, 5, 50, 5),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.green, width: 3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                child: Text(
                                  "정상",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                ),
                              );
                            case "prehypertension":
                              return Container(
                                // margin: const EdgeInsets.all(30.0),
                                padding:
                                    const EdgeInsets.fromLTRB(50, 5, 50, 5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.orange, width: 3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                child: Text(
                                  "전고혈압",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange),
                                ),
                              );
                            case "hypertension":
                              return Container(
                                // margin: const EdgeInsets.all(30.0),
                                padding:
                                    const EdgeInsets.fromLTRB(50, 5, 50, 5),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.red, width: 3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                child: Text(
                                  "고혈압",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                ),
                              );
                            default:
                              break;
                          }
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                ],
              ),
              flex: 2,
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  Container(
                    child: Text(
                      "측정 기록",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline2!,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Container(
                      width: size.width * 0.5,
                      height: size.height * 0.3,
                      child: SfCartesianChart(
                        primaryXAxis: NumericAxis(interval: 1),
                        primaryYAxis: NumericAxis(
                            minimum: 50,
                            maximum: 200,
                            interval: 20,
                            labelFormat: '{value}',
                            axisLine: const AxisLine(width: 0),
                            majorTickLines: const MajorTickLines(
                                color: Colors.transparent)),
                        series: _getDashedLineSeries(),
                        tooltipBehavior: TooltipBehavior(enable: true),
                      )),
                  Container(
                    width: size.width * 0.5,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('날짜')),
                        DataColumn(label: Text('측정')),
                        DataColumn(label: Text('상태')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('10')),
                          DataCell(Text('110 / 62')),
                          DataCell(Text(
                            '전고혈압',
                            style: TextStyle(color: Colors.orange),
                          )),

                          // DataCell(Text('13')),
                          // DataCell(Text('14')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('11')),
                          DataCell(Text('115 / 70')),
                          DataCell(Text(
                            '고혈압',
                            style: TextStyle(color: Colors.red),
                          )),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('12')),
                          DataCell(Text('142 / 82')),
                          DataCell(Text(
                            '정상',
                            style: TextStyle(color: Colors.green),
                          )),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('13')),
                          DataCell(Text('129 / 75')),
                          DataCell(Text(
                            '고혈압',
                            style: TextStyle(color: Colors.red),
                          )),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('14')),
                          DataCell(Text('108 / 62')),
                          DataCell(Text(
                            '저혈압',
                            style: TextStyle(color: Colors.blue),
                          )),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
              flex: 3,
            )
          ],
        ),
      ),
    );
  }

  /// The method returns dashed line series to chart.
  List<LineSeries<_ChartData, num>> _getDashedLineSeries() {
    final List<_ChartData> chartData = <_ChartData>[
      _ChartData(10, 110, 62),
      _ChartData(11, 115, 70),
      _ChartData(12, 143, 82),
      _ChartData(13, 132, 68),
      _ChartData(14, 127, 73),
      _ChartData(15, 151, 63),
      _ChartData(16, 128, 77),
    ];
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
          color: Colors.red,
          animationDuration: 2500,
          dashArray: <double>[15, 3, 3, 3],
          dataSource: chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          width: 2,
          name: '최고',
          markerSettings: const MarkerSettings(isVisible: true)),
      LineSeries<_ChartData, num>(
          color: Colors.blue,
          animationDuration: 2500,
          dataSource: chartData,
          dashArray: <double>[15, 3, 3, 3],
          width: 2,
          name: '최저',
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y2,
          markerSettings: const MarkerSettings(isVisible: true)),
    ];
  }

  void _startTimer(bool stop) {
    const sec = Duration(seconds: 3);
    Timer.periodic(sec, (Timer t) {
      if (stop) {
        t.cancel();
      }
      print('hi!');
      bloc.fetchStatus();
    });
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  final int x;
  final int y;
  final int y2;
}
