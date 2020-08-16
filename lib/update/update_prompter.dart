import 'package:flutter/cupertino.dart';
import 'package:flutter_app_update_example/update/update.dart';
import 'package:flutter_app_update_example/utils/common.dart';
import 'package:flutter_app_update_example/utils/http.dart';
import 'package:flutter_app_update_example/utils/toast.dart';
import 'package:flutter_update_dialog/flutter_update_dialog.dart';
import 'dart:io';

import 'entity/update_entity.dart';

class UpdatePrompter {
  /// 版本更新信息
  final UpdateEntity updateEntity;

  final InstallCallback onInstall;

  UpdateDialog _dialog;

  double _progress = 0.0;

  File _apkFile;

  UpdatePrompter({@required this.updateEntity, @required this.onInstall});

  void show(BuildContext context) async {
    if (_dialog != null && _dialog.isShowing()) {
      return;
    }
    String title = "是否升级到${updateEntity.versionName}版本？";
    String updateContent = getUpdateContent();
    if (Platform.isAndroid) {
      _apkFile = await CommonUtils.getApkFileByUpdateEntity(updateEntity);
    }
    if (_apkFile != null && _apkFile.existsSync()) {
      _dialog = UpdateDialog.showUpdate(
        context,
        title: title,
        updateContent: updateContent,
        updateButtonText: "安装",
        extraHeight: 10,
        enableIgnore: updateEntity.isIgnorable,
        isForce: updateEntity.isForce,
        onUpdate: doInstall,
      );
    } else {
      _dialog = UpdateDialog.showUpdate(
        context,
        title: title,
        updateContent: updateContent,
        extraHeight: 10,
        enableIgnore: updateEntity.isIgnorable,
        isForce: updateEntity.isForce,
        onUpdate: onUpdate,
      );
    }
  }

  String getUpdateContent() {
    String targetSize =
        CommonUtils.getTargetSize(updateEntity.apkSize.toDouble());
    String updateContent = "";
    if (targetSize.isNotEmpty) {
      updateContent += "新版本大小：$targetSize\n";
    }
    updateContent += updateEntity.updateContent;
    return updateContent;
  }

  void onUpdate() {
    if (Platform.isIOS) {
      doInstall();
      return;
    }

    HttpUtils.downloadFile(updateEntity.downloadUrl, _apkFile.path,
        onReceiveProgress: (int count, int total) {
      _progress = count.toDouble() / total;
      if (_progress <= 1.0001) {
        _dialog.update(_progress);
      }
    }).then((value) {
      doInstall();
    }).catchError((value) {
      ToastUtils.success("下载失败！");
      _dialog.dismiss();
    });
  }

  /// 安装
  void doInstall() {
    _dialog.dismiss();
    onInstall.call(_apkFile != null ? _apkFile.path : updateEntity.downloadUrl);
  }
}
