import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:librebook/app_localizations.dart';
import 'package:librebook/controllers/settings_controller.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/widgets/folder_picker/folder_picker.dart';
import 'package:librebook/ui/widgets/folder_picker/picker_common.dart';
import 'package:package_info/package_info.dart';

class SettingView extends StatelessWidget {
  final _settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 8, left: 8, right: 8),
      children: [
        ListTile(
            title: Text(
              AppLocalizations.of(context).translate('download-location'),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            subtitle: FutureBuilder(
              future: _settingsController.getDownloadLocation(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data, style: Theme.of(context).textTheme.caption);
                } else {
                  return Container();
                }
              },
            ),
            leading: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(
                Icons.save_outlined,
                size: 26,
              ),
            ),
            onTap: () async {
              var newDirectory = await FilesystemPicker.open(
                context: context,
                rootDirectory: Directory('/storage/emulated/0'),
                fsType: FilesystemType.folder,
                title:
                    AppLocalizations.of(context).translate('download-location'),
                rootName:
                    AppLocalizations.of(context).translate('internal-storage'),
                pickText: AppLocalizations.of(context)
                    .translate('download-location-save'),
                folderIconColor: primaryColor,
              );

              print(newDirectory);

              if (newDirectory != null) {
                // Do something with the picked directory
                _settingsController.setDownloadLocation(newDirectory);
              }
            }),
        Divider(
          height: 2,
          thickness: 1,
        ),
        Obx(
          () => SwitchListTile(
            title:
                Text(AppLocalizations.of(context).translate('dark-mode'), style: Theme.of(context).textTheme.bodyText1),
            activeColor: primaryColor,
            secondary: Icon(Icons.brightness_4),
            value: _settingsController.isDarkMode.value,
            onChanged: (val) => _settingsController.setDarkMode(val),
          ),
        ),
        Divider(
          height: 2,
          thickness: 1,
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).translate('synchronize'), style: Theme.of(context).textTheme.bodyText1),
          subtitle: Text(AppLocalizations.of(context)
              .translate('get-default-scraper-settings'), style: Theme.of(context).textTheme.caption,),
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(
              Icons.sync,
              size: 26,
            ),
          ),
          onTap: () {
            //TODO; implement synchronize settings
            Get.rawSnackbar(
                title:
                    AppLocalizations.of(context).translate('under-development'),
                message: AppLocalizations.of(context)
                    .translate('under-development-message'),
                icon: Icon(
                  Icons.warning,
                  color: Colors.white,
                ),
                animationDuration: Duration(milliseconds: 500),
                duration: Duration(milliseconds: 1500));
          },
        ),
        Divider(
          height: 2,
          thickness: 1,
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).translate('about'), style: Get.textTheme.bodyText1,),
          leading: Icon(
            Icons.info_outline,
            size: 26,
          ),
          onTap: () async {
            final packageInfo = await PackageInfo.fromPlatform();
            Get.dialog(AboutDialog(
              applicationIcon: Container(
                  width: 60,
                  height: 60,
                  child: Image.asset('assets/icon/icon.png')),
              applicationVersion: 'v' + packageInfo.version,
              applicationLegalese: '© 2021 Bagas Wastu',
              children: [
                verticalSpaceMedium,
                Text(
                  AppLocalizations.of(context)
                      .translate('librebook-description'),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ));
          },
        ),
      ],
    );
  }
}
