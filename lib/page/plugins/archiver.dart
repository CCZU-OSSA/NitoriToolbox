import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/lang.dart';

class SNZipPage extends StatefulWidget {
  const SNZipPage({super.key});

  @override
  State<StatefulWidget> createState() => StateSNZipPage();
}

class StateSNZipPage extends State<SNZipPage> {
  String? unzipTargetFile;
  String? unzipTargetDir;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(children: [
      const NitoriTitle("解压缩"),
      Expander(
          initiallyExpanded: true,
          header: const NitoriText("解压"),
          content: Column(
            children: [
              ListTile(
                title: const NitoriText("格式"),
                trailing: DropDownButton(title: text("自动检测"), items: [
                  MenuFlyoutItem(text: text("text"), onPressed: () {})
                ]),
              ),
              ListTile(
                title: const NitoriText("解压到"),
                trailing: NitoriText(unzipTargetDir ?? "目标文件文件夹"),
              ),
              ListTile(
                title: const NitoriText("当前文件"),
                trailing: NitoriText(unzipTargetFile ?? "无"),
              ),
              ListTile(
                title: const NitoriText("创建新文件夹"),
                trailing: ToggleSwitch(checked: true, onChanged: (v) {}),
              ),
              height20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                      child: const NitoriText("选择文件"),
                      onPressed: () {
                        FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: [
                              "zip",
                              "rar",
                              "7z"
                            ]).then((value) {
                          if (value != null) {
                            setState(() {
                              unzipTargetFile = value.files[0].path;
                            });
                          }
                        });
                      }),
                  Button(
                      child: const NitoriText("解压到..."),
                      onPressed: () {
                        FilePicker.platform.getDirectoryPath().then((value) {
                          if (value != null) {
                            setState(() {
                              unzipTargetDir = value;
                            });
                          }
                        });
                      }),
                  Button(child: const NitoriText("解压"), onPressed: () {})
                ].joinElement(width20),
              )
            ].joinElement(height05),
          )),
      height05,
      const Expander(
          initiallyExpanded: true,
          header: NitoriText("压缩"),
          content: NitoriText("压缩"))
    ]);
  }
}
