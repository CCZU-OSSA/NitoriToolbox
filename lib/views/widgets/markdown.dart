import 'package:flutter/material.dart';
import 'package:flutter_highlighting/flutter_highlighting.dart';
import 'package:flutter_highlighting/themes/atom-one-dark-reasonable.dart';
import 'package:flutter_highlighting/themes/atom-one-light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher_string.dart';

class MarkdownBlockWidget extends StatelessWidget {
  final String data;
  const MarkdownBlockWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: data,
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrlString(href);
        }
      },
      shrinkWrap: true,
      builders: {
        "latex": LatexElementBuilder(),
        "code": CodeElementBuilder(
            isDark: Theme.of(context).brightness == Brightness.dark),
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
  final bool isDark;
  CodeElementBuilder({this.isDark = true});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return SizedBox(
      width: double.infinity,
      child: HighlightView(
        element.textContent,
        languageId: element.attributes['class']?.substring(9) ?? "rust",
        theme: isDark ? atomOneDarkReasonableTheme : atomOneLightTheme,
        padding: const EdgeInsets.all(8),
        textStyle: const TextStyle(fontFamily: "FiraCode"),
      ),
    );
  }
}
