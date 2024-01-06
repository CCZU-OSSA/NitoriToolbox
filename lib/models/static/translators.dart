import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/models/static/enums.dart';

final trBackgroundImageType = StringTranslator(BackgroundImageType.values)
    .translate(BackgroundImageType.local, "本地")
    .translate(BackgroundImageType.network, "网络")
    .translate(BackgroundImageType.wallpaper, "壁纸");

final trNavigationLabelType = StringTranslator(NavigationRailLabelType.values)
    .translate(NavigationRailLabelType.all, "全部")
    .translate(NavigationRailLabelType.selected, "选中")
    .translate(NavigationRailLabelType.none, "隐藏");

final trThemeMode = StringTranslator(ThemeMode.values)
    .translate(ThemeMode.system, "系统")
    .translate(ThemeMode.dark, "深色")
    .translate(ThemeMode.light, "浅色");
