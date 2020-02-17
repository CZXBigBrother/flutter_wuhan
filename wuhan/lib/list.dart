import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wuhan/main.dart';

class ListControler extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListControlerState();
  }
}

class ListControlerState extends State<ListControler> {
  StreamController<Map> stream = new StreamController.broadcast();
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

      Response response = await dio.get(
          "https://download-1257933677.cos.ap-shanghai.myqcloud.com/json/list-result.json")
        ..headers.add('Access-Control-Allow-Origin', '*');
      // print(response);
      Map data = json.decode(response.toString());
      print(data);
      this.data = data;
      this.stream.sink.add(data);
      // this.setState(() {});
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("历史数据"),
        centerTitle: true,
      ),
      body: StreamBuilder<Map>(
        stream: this.stream.stream,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Text("正在加载中..."),
            );
          } else {
            List<Widget> list = [];
            // print(list);
            for (String item in snapshot.data['data']) {
              list.add(ListTile(
                title: Text(item),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (ctx) => new MyHomePage(
                            title: "历史动态",
                            url:
                                'https://download-1257933677.cos.ap-shanghai.myqcloud.com/json/' +
                                    item,
                          )));
                },
              ));

              list.add(Divider(
                height: 0.5,
              ));
            }
            return ListView(
              children: list,
            );
          }
        },
      ),
    );
  }
}
