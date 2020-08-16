import 'package:flutter/cupertino.dart';
import 'package:flutter_app_update_example/update/update_parser.dart';
import 'package:flutter_app_update_example/update/update_prompter.dart';
import 'package:flutter_app_update_example/utils/common.dart';
import 'package:flutter_app_update_example/utils/toast.dart';
import 'package:install_plugin/install_plugin.dart';

import '../utils/http.dart';

/// 版本更新管理
class UpdateManager {
  ///全局初始化
  static init(
      {String baseUrl, int timeout = 5000, Map<String, dynamic> headers}) {
    HttpUtils.init(baseUrl: baseUrl, timeout: timeout, headers: headers);
  }

  static void checkUpdate(BuildContext context, String url) {
    HttpUtils.get(url).then((response) {
      UpdateParser.parseJson(response.toString()).then((value) => {
            UpdatePrompter(
                updateEntity: value,
                onInstall: (String filePath) {
                  CommonUtils.installAPP(filePath);
                }).show(context)
          });
    }).catchError((onError) {
      ToastUtils.error(onError);
    });
  }
}

typedef InstallCallback = Function(String filePath);
