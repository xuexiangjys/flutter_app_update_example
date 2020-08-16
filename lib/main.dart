import 'package:flutter/material.dart';
import 'package:flutter_app_update_example/update/update.dart';

import 'utils/toast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ToastUtils.init(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Update Demo'),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _updateUrl =
      "https://gitee.com/xuexiangjys/XUpdate/raw/master/jsonapi/update_test.json";

  @override
  void initState() {
    super.initState();
    UpdateManager.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, //文本是起始端对齐
                    children: <Widget>[
                  ButtonBar(
                    alignment:
                        MainAxisAlignment.start, //布局方向，默认MainAxisAlignment.end
                    mainAxisSize: MainAxisSize.min, //主轴大小，默认MainAxisSize.max
                    children: <Widget>[
                      RaisedButton(
                        child: Text('版本更新'),
                        color: Theme.of(context).primaryColor,
                        onPressed: checkUpdate,
                      ),
                    ],
                  ),
                ])));
  }

  void checkUpdate() {
    UpdateManager.checkUpdate(context, _updateUrl);
  }
}
