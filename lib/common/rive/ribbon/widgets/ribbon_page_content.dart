import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

class RibbonPageContent extends StatelessWidget {
  const RibbonPageContent({
    required this.child,
    required this.onScroll,
    super.key,
  });

  final Widget child;
  final VoidCallback onScroll;

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: (_) {
          onScroll();
          return false;
        },
        child: Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.transparent,
            appBarTheme: Theme.of(context).appBarTheme.copyWith(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              scrolledUnderElevation: 0,
              systemOverlayStyle:
                  Theme.of(context).brightness == Brightness.dark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
            ),
          ),
          child: child,
        ),
      );
}
