extension DisplayFilter on String {
  String displayFilter() {
    return replaceAllMapped(
            RegExp(r"\x1b\[[\x30-\x3f]*[\x20-\x2f]*[\x40-\x7e]"), (match) => "")
        .replaceAllMapped(RegExp(r"\x1b[PX^_].*?\x1b\\"), (match) => "")
        .replaceAllMapped(RegExp(r"\x1b\][^\a]*(?:\a|\x1b\\)"), (match) => "")
        .replaceAllMapped(RegExp(r"\x1b[\[\]A-Z\\^_@]"), (match) => "");
  }
}
