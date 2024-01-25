import 'package:flutter/material.dart';
import 'package:flutter_highlighting/flutter_highlighting.dart';
import 'package:flutter_highlighting/themes/atom-one-dark-reasonable.dart';
import 'package:flutter_highlighting/themes/atom-one-light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:highlighting/languages/all.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:nitoritoolbox/controllers/shell.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MarkdownBlockWidget extends StatelessWidget {
  final String data;
  final String? imageDirectory;
  const MarkdownBlockWidget(this.data, {super.key, this.imageDirectory});

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: data,
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrlString(href);
        }
      },
      imageDirectory: imageDirectory,
      shrinkWrap: true,
      builders: {
        "latex": LatexElementBuilder(),
        "code": CodeElementBuilder(Theme.of(context).colorScheme),
      },
      extensionSet: md.ExtensionSet(
        [
          const md.FencedCodeBlockSyntax(),
          const md.TableSyntax(),
          const md.UnorderedListWithCheckboxSyntax(),
          const md.OrderedListWithCheckboxSyntax(),
          const md.FootnoteDefSyntax(),
          LatexBlockSyntax()
        ],
        [
          md.InlineHtmlSyntax(),
          md.StrikethroughSyntax(),
          md.AutolinkExtensionSyntax(),
          LatexInlineSyntax()
        ],
      ),
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  final ColorScheme colorScheme;
  CodeElementBuilder(this.colorScheme);

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var lang = element.attributes['class']?.substring(9) ?? "plaintext";
    if (!allLanguages.containsKey(lang)) {
      lang = "plaintext";
    }
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colorScheme.onSurfaceVariant)),
        width: element.textContent.lines().length > 1 ? double.infinity : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: HighlightView(
            element.textContent,
            languageId: lang,
            theme: colorScheme.brightness == Brightness.dark
                ? atomOneDarkReasonableTheme
                : atomOneLightTheme,
            padding: const EdgeInsets.all(8),
            textStyle: const TextStyle(
                fontFamily: "FiraCode", fontFamilyFallback: ["GlowSans"]),
          ),
        ));
  }
}
