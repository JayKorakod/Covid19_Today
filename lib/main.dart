import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nextflow_covid_today/covid_today_result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nextflow COVID-19 Today',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: MyHomePage(title: 'Nextflow COVID-19 Today'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  CovidTodayResult _dataFromWebAPI;

  @override
  void initState(){
    super.initState();

    print('init state');
    getData();
  }
  
  Future<void> getData() async {
      print('get data');
      var response = await http.get('https://covid19.th-stat.com/api/open/today');
      print(response.body);

      setState(() {
        _dataFromWebAPI = covidTodayResultFromJson(response.body);
      });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('ผู้ติดเชื้อสะสม'),
            subtitle: Text('${_dataFromWebAPI?.confirmed ?? "loading"}'),
          ),
          ListTile(
            title: Text('หายแล้ว'),
            subtitle: Text('${_dataFromWebAPI?.recovered ?? "loading"}'),
          ),
          ListTile(
            title: Text('รักษาอยู่ในโรงพยาบาล'),
            subtitle: Text('${_dataFromWebAPI?.hospitalized ?? "loading"}'),
          ),
          ListTile(
            title: Text('เสียชีวิต'),
            subtitle: Text('${_dataFromWebAPI?.deaths ?? "loading"}'),
          )
        ],
      )
    );
  }
}
