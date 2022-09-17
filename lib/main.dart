import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/const_city.dart';
import 'constants/const_layouts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(
        title: 'Harita Çevirici',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _maps = [];

  String dropdownValueCity = '1/250.000 Ölçekli Pafta';
  String dropdownLayoutOne = '1/100.000 Ölçekli Pafta';
  String dropdownLayoutTwo = '1/50.000 Ölçekli Pafta';
  String dropdownLayoutThree = '1/25.000 Ölçekli Pafta';

  String _conclution = '';
  String _conclution1 = '';
  String concCoordOne = '';
  String concCoordTwo = '';
  String concCoordThree = '';
  String concCoordFour = '';
  String upEditValue = '';
  String downEditValue = '';
  final controller = TextEditingController();

  Future<void> readJson(String conc) async {
    final String response =
        await rootBundle.loadString('assets/data/dummy.json');
    final data = await json.decode(response);
    _maps = data["maps"];

    print(conc);
    final String coordinate1 = conc.substring(0, 5);
    final String coordinate2 = conc.substring(5, 10);

    setState(() {
      _maps.forEach((element) {
        if (element['sehir'] == dropdownValueCity &&
            element['pafta1'] == dropdownLayoutOne &&
            element['pafta2'] == dropdownLayoutTwo &&
            element['pafta3'] == dropdownLayoutThree) {
          print("sehir: " + element['sehir']);
          print("mgrs1: " + element['mgrs1']);
          print("mgrs2: " + element['mgrs2']);
          print("mgrs3: " + element['mgrs3']);
          print("mgrs4: " + element['mgrs4']);

          final firstCoordinate =
              (int.parse(coordinate1) - double.parse(element['saga']).round());
          final secondCoordinate = (int.parse(coordinate2) -
              double.parse(element['yukari']).round());

          downEditValue = element['yukari'];
          upEditValue = element['saga'];

          print('first coordinate: ${firstCoordinate}');

          print('second coordinate: ${secondCoordinate}');
          concCoordOne =
              '\n${element['mgrs1']}${firstCoordinate}${secondCoordinate}';
          if (element['mgrs2'] != '') {
            concCoordTwo =
                '\n${element['mgrs2']}${firstCoordinate}${secondCoordinate}';
          }
          if (element['mgrs3'] != '') {
            concCoordThree =
                '\n${element['mgrs3']}${firstCoordinate}${secondCoordinate}';
          }
          if (element['mgrs4'] != '') {
            concCoordFour =
                '\n${element['mgrs4']}${firstCoordinate}${secondCoordinate}';
          }

          print("conclution coordinate 1: " + concCoordOne);
          print("conclution coordinate 2: " + concCoordTwo);
          print("conclution coordinate 3: " + concCoordThree);
          print("conclution coordinate 4: " + concCoordFour);
        }
      });
    });

    _conclution1 =
        '${concCoordOne}${concCoordTwo}${concCoordThree}${concCoordFour}';
  }

  void _printLastestValue() {
    print(controller.text);
    setState(() {
      _conclution = controller.text;
    });
  }

  @override
  void initState() {
    controller.addListener(_printLastestValue);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 2.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.purple[100],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widgetDropdownCities(),
                  widgetDropdownLayoutOne(),
                  widgetDropdownLayoutTwo(),
                  widgetDropdownLayoutThree(),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 2.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.purple[100],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Yukarı Düzeltme Değeri: ${downEditValue}'),
                  Text('Sağa Düzeltme Değeri: ${upEditValue}'),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                decoration: const InputDecoration(
                  labelText: 'Koordinat Giriniz',
                  hintText: '10 haneli koordinat giriniz.',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 2.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.purple[100],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sonuçlar: ${_conclution1}'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  concCoordOne = '';
                  concCoordTwo = '';
                  concCoordThree = '';
                  concCoordFour = '';
                });
                readJson(_conclution);
              },
              child: const Text('Hesapla'),
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetDropdownCities() {
    return DropdownButton<String>(
      value: dropdownValueCity,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValueCity = value!;
        });
      },
      items: constCities.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget widgetDropdownLayoutOne() {
    return DropdownButton<String>(
      value: dropdownLayoutOne,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownLayoutOne = value!;
        });
      },
      items: constLayoutOne.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget widgetDropdownLayoutTwo() {
    return DropdownButton<String>(
      value: dropdownLayoutTwo,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownLayoutTwo = value!;
        });
      },
      items: constLayoutTwo.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget widgetDropdownLayoutThree() {
    return DropdownButton<String>(
      value: dropdownLayoutThree,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownLayoutThree = value!;
        });
      },
      items: constLayoutThree.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
