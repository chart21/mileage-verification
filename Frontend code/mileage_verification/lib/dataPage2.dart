import 'package:flutter/material.dart';
import 'package:mileage_verification/lineChart.dart';
import 'main.dart';

class DatePage2 extends StatefulWidget {
  const DatePage2({Key key}) : super(key: key);

  @override
  _DatePage2State createState() => _DatePage2State();
}

class _DatePage2State extends State<DatePage2> {
  var changed;
  var suspicious;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changed = false;

    // suspicious = 0;
    isSuspicious();
    //delete later
    // if (curIndex == 2) suspicious = 1;
    // if (curIndex == 3) suspicious = 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            //mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Mileage History'),
              IconButton(
                  onPressed: refreshBlockchain, icon: Icon(Icons.refresh))
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: buildOnRefresh,
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 10),
                        // width: 200,
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: curIndex <= images.length
                            ? Image.asset(
                                images[curIndex - 1],
                                //width: 100,
                              )
                            : Container(color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                models[curIndex],
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              Row(
                                children: <Widget>[
                                  Text("Car UID: ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  Text(uids[curIndex].toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text("Odometer UID: ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  Text(oids[curIndex].toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Text(
                                  values[values.length - 1].toString() +
                                      " miles",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))
                            ]),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: LineChartSample2(),
                  ),
                  Container(
                    color: suspicious == 0
                        ? Colors.green
                        : suspicious == 1 ? Colors.yellow : Colors.red,
                    height: 100,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    child: suspicious == 0
                        ? Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  child: Icon(
                                    Icons.check,
                                    size: 60,
                                  ),
                                ),
                              ),
                              Text(
                                'Consistent mileage data',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          )
                        : suspicious == 1
                            ? Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      child: Icon(
                                        Icons.cloud_circle,
                                        size: 60,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Suspicious mileage data',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              )
                            : Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      child: Icon(
                                        Icons.clear,
                                        size: 60,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Fake mileage data',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Future<Null> buildOnRefresh() {
    refreshBlockchain();
    return Future(null);
  }

  void refreshBlockchain() async {
    uids = [];
    oids = [];
    models = [];

    final balanceFunction = contract.function('getOdometers');
    final balance = await ethClient
        .call(contract: contract, function: balanceFunction, params: []);
    first = balance.elementAt(0);
    print(first.toString());
    for (int i = 0; i < first.length; i++) {
      uids.add(first[i][0]);
      oids.add(first[i][1]);
      models.add(first[i][5]);
    }

    timestamps = [];
    values = [];
    for (int j = 0; j < first[curIndex][4].length; j++) {
      //print(first[i][4][j]);
      values.add(int.tryParse(first[curIndex][4][j].toString()) * 100);
      timestamps.add(int.tryParse(first[curIndex][3][j].toString()));
      timestamps[j] =
          (timestamps[j] - int.tryParse(first[curIndex][6].toString())) / 86400;
      print("Jo" + first[curIndex][6].toString());
      timestamps[j] = timestamps[j] * 40;
      //avg += double.parse(values[j].toString());
    }
    //

    //avg = avg / (timestamps[timestamps.length - 1]);
    avg = double.parse(values[values.length - 1].toString());
    if (timestamps[timestamps.length - 1] > 1)
      avg = avg / (timestamps[timestamps.length - 1]);
    print(curIndex);

    setState(() {
      changed = !changed;
      isSuspicious();
    });
  }

  void isSuspicious() {
    suspicious = 0;
    for (int i = 1; i < values.length; i++) {
      var diffVal = double.parse(values[i].toString()) -
          double.parse(values[i - 1].toString());
      var diffTimeStamps = double.parse(timestamps[i].toString()) -
          double.parse(timestamps[i - 1].toString());
      if (diffVal / diffTimeStamps <
          avg * 0.2) //and significant timestamp length
      {
        suspicious = 1;
      }

      if (diffVal < 0) suspicious = 2;
    }
  }
}
