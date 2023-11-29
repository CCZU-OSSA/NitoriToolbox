import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/window_effect.dart';
import 'package:nitoritoolbox/core/translator.dart';

Translator thememodeTR = Translator(ThemeMode.values)
    .setTranslate(ThemeMode.dark, "🌙深色模式")
    .setTranslate(ThemeMode.light, "🔆浅色模式")
    .defaultName("🌗跟随系统");

Translator panedisplayTR = Translator(PaneDisplayMode.values)
    .setTranslate(PaneDisplayMode.compact, "兼容")
    .setTranslate(PaneDisplayMode.open, "保持开启")
    .setTranslate(PaneDisplayMode.minimal, "最小化")
    .setTranslate(PaneDisplayMode.top, "顶部")
    .defaultName("自适应");

List<WindowEffect> supportEffects = [
  WindowEffect.disabled,
  WindowEffect.aero,
  WindowEffect.acrylic,
  WindowEffect.mica,
  WindowEffect.tabbed
];

Translator wineffectTR = Translator(supportEffects)
    .setTranslate(WindowEffect.acrylic, "Acrylic")
    .setTranslate(WindowEffect.aero, "Aero")
    .setTranslate(WindowEffect.mica, "Mica")
    .setTranslate(WindowEffect.tabbed, "Tabbed")
    .defaultName("关闭");
