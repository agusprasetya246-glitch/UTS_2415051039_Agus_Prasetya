class Breakpoints {
  Breakpoints._();

  static const double medium = 600;
  static const double expanded = 840;

  static bool isCompact(double width) => width < medium;
  static bool isExpanded(double width) => width >= expanded;

  static int catalogColumns(double width) {
    if (width < medium) return 2;
    if (width < expanded) return 3;
    return 4;
  }
}
