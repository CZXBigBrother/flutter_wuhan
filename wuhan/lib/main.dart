import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
// import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:wuhan/list.dart';
// https://download-1257933677.cos.ap-shanghai.myqcloud.com/json/image/main.dart.js

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '武汉肺炎实时动态',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: '武汉肺炎实时动态'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.url}) : super(key: key);
  final String title;
  String url;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getHttp();
    // this.downloadData();
  }

  Map data;
  void getHttp() async {
    try {
      Map<String, String> headerMap = new Map();
      headerMap["Access-Control-Allow-Origin"] =
          "download-1257933677.cos.ap-shanghai.myqcloud.com";
      Dio dio = new Dio();
      dio.options.headers = headerMap;

      Response response = await dio.get(widget.url == null
          ? "https://download-1257933677.cos.ap-shanghai.myqcloud.com/json/result.json"
          : widget.url)
        ..headers.add('Access-Control-Allow-Origin', '*');
      // print(response);
      Map data = json.decode(response.toString());
      print(data);
      this.data = data;
      this.setState(() {});
    } catch (e) {
      print(e);
    }
  }

  // void downloadData() async {
  //   var url =
  //       'https://download-1257933677.cos.ap-shanghai.myqcloud.com/json/result.json';
  //   var response = await html.HttpRequest.getString(url);
  //   var responseBody = response;
  //   Map data = json.decode(responseBody);
  //   print(data);
  //   this.data = data;
  //   this.setState(() {});
  // }

  Widget getRight() {
    if (widget.url == null) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Center(
              child: Text("历史数据"),
            )),
        onTap: () {
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (ctx) => new ListControler()));
        },
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> child = [
      this.getCellTitle(),
      Divider(
        height: 0.5,
      ),
    ];

    Widget data;
    if (this.data == null) {
      data = Container(
        margin: EdgeInsets.all(5),
        child: Text("数据正在加载中"),
      );
    } else {
      data = Container();
      for (Map<String, dynamic> item in this.data["data"]["data"]) {
        child.add(this.getCellDesc(
          item['country'],
          item['confirme'].toString(),
          item['dead'].toString(),
          item['cure'].toString(),
          item['image'],
        ));
        child.add(
          Divider(
            height: 0.5,
          ),
        );
      }
    }
    child.add(data);
    child.addAll([this.getCellTime(), this.getWikipedia()]);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: [this.getRight()],
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.only(top: 5, left: 5, right: 5),
            child: ListView(children: child,),
            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: child,
            // ),
          ),
        ));
  }

  Widget getCellTime() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child:
          Text("最后更新时间为:${this.data != null ? this.data["data"]["time"] : ""}"),
    );
  }

  Widget getWikipedia() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Text("所有数据均来自 wikipedia,在此向一线医护人员致敬"),
    );
  }

  Widget getCellTitle() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "国家",
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[Text("确诊")],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[Text("死亡")],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[Text("治愈")],
          ),
        ),
      ],
    );
  }

  Widget getCellDesc(
      String country, String confirme, String dead, String cure, String image) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(image),
              Text(
                country,
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[Text(confirme)],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                dead,
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[Text(cure)],
          ),
        ),
      ],
    );
  }
}
