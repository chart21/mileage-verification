import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'dataPage2.dart';

final apiUrl =
    "..."; //Replace with the API to your Ethereum PoA chain

final httpClient = new Client();
var ethClient = new Web3Client(apiUrl, httpClient);

final EthereumAddress contractAddr =
    // EthereumAddress.fromHex('0xe6149811251d29e0fbd2bfe2b8bec05fb096a35d');
    EthereumAddress.fromHex('0xe4f8d3b9af94d3948e14bea80d4b251eb44b12c5');

final jsonD = """ [
    {
      "constant": false,
      "inputs": [
        {"name": "carModel", "type": "string"},
        {"name": "carID", "type": "uint256"},
        {"name": "odometerID", "type": "uint256"}
      ],
      "name": "addOdometer",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {"name": "value", "type": "uint256"}
      ],
      "name": "addValue",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "constant": true,
      "inputs": [
        {"name": "index", "type": "uint256"}
      ],
      "name": "getOdometerFromIndex",
      "outputs": [
        {
          "components": [
            {"name": "carID", "type": "uint256"},
            {"name": "odometerID", "type": "uint256"},
            {"name": "odometerAddress", "type": "address"},
            {"name": "timestamps", "type": "uint256[]"},
            {"name": "values", "type": "uint256[]"},
            {"name": "carModel", "type": "string"},
            {"name": "start_Time", "type": "uint256"}
          ],
          "name": "",
          "type": "tuple"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "getOdometers",
      "outputs": [
        {
          "components": [
            {"name": "carID", "type": "uint256"},
            {"name": "odometerID", "type": "uint256"},
            {"name": "odometerAddress", "type": "address"},
            {"name": "timestamps", "type": "uint256[]"},
            {"name": "values", "type": "uint256[]"},
            {"name": "carModel", "type": "string"},
            {"name": "start_Time", "type": "uint256"}
          ],
          "name": "",
          "type": "tuple[]"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    }
  ]""";

//static final String jsonData = jsonD.toString();

final String name = "Mileage";

//  final contract = DeployedContract(
//    ContractAbi.fromJson(jsonData, 'MetaCoin'), contractAddr);

final contract =
    DeployedContract(ContractAbi.fromJson(jsonD, name), contractAddr);

final car1 = {"uid": "X12345", "model": "BMW i3", "status": "verfied"};
final car2 = {"uid": "X12346", "model": "BMW i4", "status": "suspicous"};
final car3 = {"uid": "X12347", "model": "BMW i5", "status": "verfied"};
final car4 = {"uid": "X12348", "model": "BMW i6", "status": "verfied"};
var myCars = [car3, car4];
var allCars = [car1, car2];
var models = [];
var uids = [];
var oids = [];
const images = ['i8_2.png', 'tiguan.png', 'a6.png', 'fiat.png'];
var values = [];
var timestamps = [];
var avg = double.parse('0');
var first;
var curIndex;
void main() async {
  final balanceFunction = contract.function('getOdometers');
  final balance = await ethClient
      .call(contract: contract, function: balanceFunction, params: []);
  first = balance.elementAt(0);
  print(first.toString());
  for (int i = 0; i < first.length; i++) {
    //print(i);
    uids.add(first[i][0]);
    oids.add(first[i][1]);

    models.add(first[i][5]);
    print(first[i][0]);
    print(first[i][5]);
    print(first[i]);
  }
  print(timestamps);
  print(values);
  print(avg);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Mileage Verification'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var cars = <Widget>[];

  @override
  Widget build(BuildContext context) {
    cars.add(
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: ListTile(
          leading: Container(
            child: Center(
                child: Text('Image',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            width: 150,
          ),
          title: Text('Model',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          trailing: Text('UID  ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
      ),
    );
    for (int i = 1; i < uids.length; i++) {
      cars.add(CustomListTile(
        modelNumber: uids[i].toString(),
        text: models[i].toString(),
        index: i,
      ));
    }
    print(cars.length);
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(children: cars),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String text;
  final String modelNumber;
  final int index;

  const CustomListTile({Key key, this.modelNumber, this.text, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: ListTile(
        leading: Container(
            //child: Text('X012381421'),
            width: 150,
            height: 80,
            //color: Colors.white,
            child: index <= images.length
                ? Image.asset(
                    images[index - 1],
                    width: 150,
                  )
                : Container(color: Colors.grey)),
        title: Text(text),
        trailing: Text(modelNumber),
        onTap: () {
          curIndex = index;
          timestamps = [];
          values = [];
          for (int j = 0; j < first[index][4].length; j++) {
            //print(first[i][4][j]);
            values.add(int.tryParse(first[index][4][j].toString()) * 100);
            timestamps.add(int.tryParse(first[index][3][j].toString()));
            timestamps[j] =
                (timestamps[j] - int.tryParse(first[index][6].toString())) /
                    86400;
            print("Jo" + first[index][6].toString());
            timestamps[j] = timestamps[j] * 40;
            //avg += double.parse(values[j].toString());
          }
          //

          //avg = avg / (timestamps[timestamps.length - 1]);
          avg = double.parse(values[values.length - 1].toString());
          if (timestamps[timestamps.length - 1] > 1)
            avg = avg / (timestamps[timestamps.length - 1]);
          print(index);

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DatePage2();
          }));
        },
      ),
    );
  }
}
